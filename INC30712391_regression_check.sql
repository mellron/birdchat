/*=============================================================================
  INC30712391 — REGRESSION CHECK  (read-only, except Section C's baseline table)
  detolle (Doug Tolley), 2026-07-25

  Purpose: prove the Option C change set does not disturb anything it shouldn't.
    A. Who else reads the vw_*_InTraderOps1 views (grain-change blast radius)
    B. Which lots the fix actually touches, portfolio-wide (other-affected-lots scan)
    C. Before/after proof that ONLY the affected lots' SwapWeight/BookValueHedged moved
    D. Grain integrity — the de-duped view returns exactly one row per lot

  Run Sections A, B, D any time on the fixed DB.
  Section C needs a baseline captured on a FRESH restore BEFORE the deploy (see notes).
=============================================================================*/
DECLARE @AsOfDate date = '2026-07-22';


/*=============================================================================
  SECTION A — WHO READS THE InTraderOps1 VIEWS?
  Expect: only reporting consumers (Power BI, external) — NO in-DB proc/view/fn
  that depends on the two-rows-per-lot grain. Anything returned here must be
  reviewed before deploy.
=============================================================================*/
PRINT '--- A1: objects referencing vw_curr_InTraderOps1 ---';
SELECT referencing_schema_name, referencing_entity_name, referencing_class_desc
FROM   sys.dm_sql_referencing_entities('dbo.vw_curr_InTraderOps1', 'OBJECT');

PRINT '--- A2: objects referencing vw_hist_InTraderOps1 ---';
SELECT referencing_schema_name, referencing_entity_name, referencing_class_desc
FROM   sys.dm_sql_referencing_entities('dbo.vw_hist_InTraderOps1', 'OBJECT');

PRINT '--- A3: text scan (catches dynamic SQL the dependency views miss) ---';
SELECT o.type_desc, s.name AS schema_name, o.name AS object_name
FROM   sys.sql_modules m
JOIN   sys.objects o ON m.object_id = o.object_id
JOIN   sys.schemas s ON o.schema_id = s.schema_id
WHERE  m.definition LIKE '%vw_curr_InTraderOps1%'
   OR  m.definition LIKE '%vw_hist_InTraderOps1%'
ORDER  BY o.type_desc, s.name, o.name;
-- NOTE: in-DB only. External consumers (Power BI, SSIS, SSRS) won't appear here —
-- we already know Power BI reads vw_hist_InTraderOps1 and BENEFITS from the de-dup.


/*=============================================================================
  SECTION B — OTHER AFFECTED LOTS (portfolio-wide, runs on the fixed DB)
  Every adjusted (hedged) lot that has MORE THAN ONE stored row = a fan-out lot.
  Those with a non-zero hedge (BookValueAdjHedge <> 0) had a real dollar change;
  those with hedge = 0 only change in row count (view display), not value.
=============================================================================*/
;WITH FanOut AS (
    SELECT AsOfDate, Portfolio, SecurityId, Ticket, COUNT(*) AS RowsPerTicket
    FROM   dbo.HedgeAccountingValues
    WHERE  AsOfDate = @AsOfDate
      AND  IsAdjustedRecord = 'Y'
    GROUP  BY AsOfDate, Portfolio, SecurityId, Ticket
    HAVING COUNT(*) > 1
)
SELECT f.Portfolio, f.SecurityId, f.Ticket, f.RowsPerTicket,
       v.BookValueAdjHedge, v.BookValueAdjUnwind, v.BookValueAdjustment,
       CASE WHEN v.BookValueAdjHedge <> 0 THEN 'YES - dollar impact'
            ELSE 'no  - unwind only (row-count change only)' END AS LiveHedge
FROM   FanOut f
LEFT   JOIN dbo.vw_hist_InTraderOps1 v
       ON v.AsOfDate = f.AsOfDate AND v.Ticket_IT = f.Ticket
ORDER  BY CASE WHEN v.BookValueAdjHedge <> 0 THEN 0 ELSE 1 END,
         f.Portfolio, f.SecurityId, f.Ticket;
-- The "YES - dollar impact" rows are the true blast radius. On 7/22 that should be
-- the 9 lots of 91282CAV3 in 100AUST; anything else is a newly-found affected lot.


/*=============================================================================
  SECTION C — BEFORE / AFTER PROOF  (only the affected lots moved)
  -----------------------------------------------------------------------------
  C1: run on a FRESH restore, BEFORE deploying the proc fix (captures the
      original/unfixed SwapWeight & BookValueHedged for every lot on the date).
  C2: run AFTER deploy + rebuild — lists every lot whose values changed. The
      changed set MUST equal the affected lots from Section B; anything else is
      an unexpected side effect.
=============================================================================*/

-- ---- C1 : BASELINE CAPTURE (run BEFORE deploy) --------------------------------
IF OBJECT_ID('dbo.zz_INC30712391_Baseline') IS NOT NULL DROP TABLE dbo.zz_INC30712391_Baseline;
SELECT AsOfDate, Portfolio, SecurityId, Ticket,
       MAX(SwapWeight)                      AS SwapWeight,
       MAX(BookValueHedged)                 AS BookValueHedged,
       MAX(BookValueHedged - BookValue)     AS BVA
INTO   dbo.zz_INC30712391_Baseline
FROM   dbo.HedgeAccountingValues
WHERE  AsOfDate = @AsOfDate
GROUP  BY AsOfDate, Portfolio, SecurityId, Ticket;
-- (harmless scratch table; drop it after the check)

-- ---- C2 : COMPARE (run AFTER deploy + rebuild) --------------------------------
;WITH AfterFix AS (
    SELECT AsOfDate, Portfolio, SecurityId, Ticket,
           MAX(SwapWeight)                  AS SwapWeight,
           MAX(BookValueHedged)             AS BookValueHedged,
           MAX(BookValueHedged - BookValue) AS BVA
    FROM   dbo.HedgeAccountingValues
    WHERE  AsOfDate = @AsOfDate
    GROUP  BY AsOfDate, Portfolio, SecurityId, Ticket
)
SELECT b.Portfolio, b.SecurityId, b.Ticket,
       b.SwapWeight      AS SwapWeight_Before, a.SwapWeight      AS SwapWeight_After,
       b.BookValueHedged AS BVH_Before,        a.BookValueHedged AS BVH_After,
       b.BVA             AS BVA_Before,         a.BVA             AS BVA_After
FROM   dbo.zz_INC30712391_Baseline b
JOIN   AfterFix a
       ON a.AsOfDate = b.AsOfDate AND a.Ticket = b.Ticket
WHERE  b.SwapWeight <> a.SwapWeight
   OR  b.BookValueHedged <> a.BookValueHedged
ORDER  BY b.Portfolio, b.SecurityId, b.Ticket;
-- EXPECT: only the affected lots (Section B "dollar impact" set). If a lot appears
-- here that ISN'T in that set, the fix moved something it shouldn't have — stop and review.
-- Also worth a row-count sanity: number of changed lots should equal that set's size.


/*=============================================================================
  SECTION D — GRAIN INTEGRITY (de-duped view = exactly one row per lot)
  Expect ZERO rows. Any row means a ticket appears more than once in the view
  (unexpected split) — the de-dup GROUP BY would need review.
=============================================================================*/
SELECT AsOfDate, Ticket_IT, COUNT(*) AS Rows_In_View
FROM   dbo.vw_hist_InTraderOps1
WHERE  AsOfDate = @AsOfDate
GROUP  BY AsOfDate, Ticket_IT
HAVING COUNT(*) > 1;
