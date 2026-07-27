/*=============================================================================
  INC30712391 — VIEW-ONLY VALIDATION            detolle (Doug Tolley), 2026-07-27
  =============================================================================
  For the VIEW-ONLY (Option D) fix. The proc is UNCHANGED and no row in
  HedgeAccountingValues is changed — the job was re-run with the ORIGINAL proc,
  so the stored rows are the halved / fanned-out BASELINE. The VIEWS do the
  correction, so we validate the VIEW OUTPUT, not the table.

  RUN ORDER
    STEP 0 + STEP 1  -> BEFORE deploying INC30712391_DEPLOY_viewonly.sql
    (deploy the 2 ALTER VIEWs)
    STEP 1 + 2 + 3   -> AFTER deploy
    STEP 4 + 5       -> AFTER deploy (prove data untouched / no-op on normal lots)
=============================================================================*/
DECLARE @AsOfDate  date        = '2026-07-22';
DECLARE @Portfolio varchar(20) = '100AUST';
DECLARE @Security  varchar(30) = '91282CAV3';   -- the affected pool's security


/*=============================================================================
  STEP 0 — BASELINE (any time): stored data is the halved / fanned-out state.
  Proves we are testing view-only against UNFIXED data (original proc output).
=============================================================================*/
PRINT '--- STEP 0: stored HAV rows (EXPECT 2 rows/lot, SwapWeight ~0.055555556) ---';
SELECT  Ticket,
        COUNT(*)          AS RowsPerTicket,
        MAX(SwapWeight)   AS SwapWeight_Stored
FROM    dbo.HedgeAccountingValues
WHERE   AsOfDate = @AsOfDate
  AND   Portfolio = @Portfolio
  AND   IsAdjustedRecord = 'Y'
GROUP BY Ticket
ORDER BY Ticket;
-- EXPECT: RowsPerTicket = 2, SwapWeight_Stored ~ 0.055555556 (1/18). This is the
-- intentional baseline — view-only does NOT change it.


/*=============================================================================
  STEP 1 — GRAIN: run BEFORE and AFTER the ALTER.
=============================================================================*/
PRINT '--- STEP 1: rows-per-lot in the view (BEFORE: >0 rows; AFTER: ZERO rows) ---';
SELECT  AsOfDate, Ticket_IT, COUNT(*) AS Rows_In_View
FROM    dbo.vw_hist_InTraderOps1
WHERE   AsOfDate = @AsOfDate
  AND   Group_IT = @Portfolio
GROUP BY AsOfDate, Ticket_IT
HAVING  COUNT(*) > 1;
-- BEFORE deploy: returns the fanned lots (2/lot).  AFTER deploy: ZERO rows.


/*=============================================================================
  STEP 2 — AFTER: the view returns ONE correct row per lot.
=============================================================================*/
PRINT '--- STEP 2: reconstructed per-lot values (AFTER deploy) ---';
SELECT  AsOfDate, Group_IT, Security_IT, Ticket_IT,
        BookValue_IT, BookValueHedged, BookValueAdjustment,
        BookValueAdjHedge, BookValueAdjUnwind, UnrealizedPLHedged
FROM    dbo.vw_hist_InTraderOps1
WHERE   AsOfDate = @AsOfDate
  AND   Group_IT = @Portfolio
ORDER BY Security_IT, Ticket_IT;
-- EXPECT per affected lot: one row; BookValueAdjHedge ~ -79,741.23;
-- BookValueAdjustment (BVA) ~ -3,612,888.76.


/*=============================================================================
  STEP 3 — POWER BI EQUIVALENCE: what the report SUMs = the correct number.
  Power BI sums BookValueAdjHedge across the view rows. With one row per lot,
  SUM == the single value, so the pool hedge total = Calypso hypo (not halved,
  not doubled).
=============================================================================*/
PRINT '--- STEP 3: report-level roll-up by security (AFTER deploy) ---';
SELECT  Group_IT, Security_IT,
        COUNT(*)                 AS Lots,
        SUM(BookValueAdjHedge)   AS Report_Hedge_Total,
        SUM(BookValueAdjUnwind)  AS Report_Unwind_Total,
        SUM(BookValueAdjustment) AS Report_BVA_Total
FROM    dbo.vw_hist_InTraderOps1
WHERE   AsOfDate = @AsOfDate
  AND   Group_IT = @Portfolio
GROUP BY Group_IT, Security_IT
ORDER BY Security_IT;
-- EXPECT for @Security (91282CAV3): Lots = 9, Report_Hedge_Total ~ -717,671.10
-- (= Calypso HypoMTM). Before the fix this column showed either the doubled or
-- the halved value depending on how the rows were rolled up.


/*=============================================================================
  STEP 4 — DATA UNTOUCHED: prove the fix changed no stored value.
=============================================================================*/
PRINT '--- STEP 4: stored SwapWeight still halved for the AFFECTED lots (proves view-only) ---';
-- Must filter to the affected security's fanned lots. A blind MAX over the whole
-- portfolio returns 1.0 from unrelated single-swap lots and proves nothing.
SELECT  Ticket, COUNT(*) AS RowsPerTicket, MAX(SwapWeight) AS SwapWeight_Stored
FROM    dbo.HedgeAccountingValues
WHERE   AsOfDate = @AsOfDate
  AND   Portfolio = @Portfolio
  AND   SecurityId = @Security
  AND   IsAdjustedRecord = 'Y'
GROUP BY Ticket
HAVING  COUNT(*) > 1        -- the fanned lots
ORDER BY Ticket;
-- EXPECT: the 9 hedged lots at RowsPerTicket=2, SwapWeight_Stored ~0.055555556
-- (unchanged). The correction lives ONLY in the view, not the table.


/*=============================================================================
  STEP 5 — NO-OP ON NON-FANNED LOTS: a single-row lot is unchanged by the fix.
  For a lot with exactly one stored row, the reconstruction is a pass-through:
  MAX(BookValue) + SUM(hedge) + SUM(unwind) == the original stored BookValueHedged.
  This query compares the de-duped view's BookValueHedged against the raw stored
  value for every NON-fanned lot; it must return ZERO mismatches.
=============================================================================*/
PRINT '--- STEP 5: non-fanned lots unchanged (AFTER deploy; EXPECT zero rows) ---';
;WITH SingleRowLots AS (
    SELECT AsOfDate, Ticket, MAX(BookValueHedged) AS Stored_BVH
    FROM   dbo.HedgeAccountingValues
    WHERE  AsOfDate = @AsOfDate
      AND  IsAdjustedRecord = 'Y'
    GROUP BY AsOfDate, Ticket
    HAVING COUNT(*) = 1
)
SELECT  s.Ticket,
        s.Stored_BVH,
        v.BookValueHedged AS View_BVH,
        (v.BookValueHedged - s.Stored_BVH) AS Diff
FROM    SingleRowLots s
JOIN    dbo.vw_hist_InTraderOps1 v
        ON v.AsOfDate = s.AsOfDate AND v.Ticket_IT = s.Ticket
WHERE   ABS(v.BookValueHedged - s.Stored_BVH) > 0.01;
-- EXPECT: ZERO rows. Any row = the fix moved a lot that had no fan-out (should not happen).
