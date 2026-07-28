/*=============================================================================
  INC30712391 — STEP 4: Repopulate the Call Report tables and TIE OUT
  detolle (Doug Tolley), 2026-07-28

  *** DEV DB ONLY — this script WRITES (DELETE + INSERT on CallReport_RCB/HCB). ***

  WHY THIS EXISTS
    IPOPS 2 and IPOPS 3 (and the RCB / HCB Call Reports) do NOT read the
    InTraderOps1 views — they read the CallReport_RCB / CallReport_HCB TABLES,
    which are populated by spInsertValsIntoCallRptRCB / ...HCB. Those procs read
    HedgeAccountingValues and de-dup the fan-out with `group by ...BookValueHedged`.
    That de-dup is CORRECT; the only defect was that the stored value was HALVED.
    Now that the Option C proc fix (spInsertValsToAdjValTemp) has made the stored
    BookValueHedged WHOLE (proven by INC30712391_validation_V2.sql, Sections 1-3),
    re-running these two procs should produce a CORRECT Call Report with NO change
    to the ~1,000-line CallRpt procs themselves.

  PREREQUISITE (must already be done on this dev DB, in order):
    1. INC30712391_DEPLOY.sql            (proc fix + MAX views)
    2. INC30712391_rebuild_job1794.sql   (HedgeAccountingValues rebuilt = WHOLE)
    -> Section 2 of validation_V2 shows SwapWeight 0.111111111 and BVA -3,612,888.76.
       If that is not true yet, STOP — run steps 1-2 first.

  HOW TO RUN
    Run the whole script in ONE connection. It snapshots the current (pre-fix /
    halved) Call Report rows for JobId 1794, clears them, re-runs both real procs
    against the now-whole HAV, then shows the BEFORE/AFTER delta plus an
    independent expected number computed straight from HedgeAccountingValues.
=============================================================================*/
SET NOCOUNT ON;

DECLARE @JobId          int         = 1794;
DECLARE @Cusip          varchar(20) = '91282CAV3';   -- the affected pool
DECLARE @HedgeId        varchar(20) = '519';          -- its hedge
DECLARE @T_AsOfDate     date;
DECLARE @T_InTraderDate date;
DECLARE @OrigStatus     smallint;

SELECT @T_AsOfDate     = AsOfDate,
       @T_InTraderDate = InTraderDate,
       @OrigStatus     = StatusId
FROM dbo.BatchJobs
WHERE JobId = @JobId;

-- sanity: dates + status before we write anything. (Procs skip if StatusId = 99.)
SELECT @JobId AS JobId, @T_AsOfDate AS AsOfDate,
       @T_InTraderDate AS InTraderDate, @OrigStatus AS OrigStatusId;


/*-----------------------------------------------------------------------------
  1.  SNAPSHOT the current (BEFORE) Call Report rows for this job.
      If these were last populated by the original 7/22 batch, they carry the
      HALVED BookValueHedged — that is our baseline to measure the correction.
-----------------------------------------------------------------------------*/
IF OBJECT_ID('tempdb..#rcb_before') IS NOT NULL DROP TABLE #rcb_before;
SELECT LineNumber, Section, Subsection_1, Subsection_2, Subsection_3, Subsection_4,
       CurrentIntent, BookValue, BookValueHedged, FairValue, WriteOff
INTO   #rcb_before
FROM   dbo.CallReport_RCB
WHERE  JobId = @JobId;

IF OBJECT_ID('tempdb..#hcb_before') IS NOT NULL DROP TABLE #hcb_before;
SELECT LineNumber, Section, Subsection_1, Subsection_2, Subsection_3, Subsection_4,
       CurrentIntent, BookValue, BookValueHedged, FairValue, WriteOff
INTO   #hcb_before
FROM   dbo.CallReport_HCB
WHERE  JobId = @JobId;

SELECT 'RCB before' AS Snapshot, COUNT(*) AS Rows,
       CAST(SUM(BookValue)       AS decimal(19,2)) AS TotalBookValue,
       CAST(SUM(BookValueHedged) AS decimal(19,2)) AS TotalBookValueHedged
FROM   #rcb_before
UNION ALL
SELECT 'HCB before', COUNT(*),
       CAST(SUM(BookValue)       AS decimal(19,2)),
       CAST(SUM(BookValueHedged) AS decimal(19,2))
FROM   #hcb_before;


/*-----------------------------------------------------------------------------
  2.  Clear this job's Call Report rows (the procs INSERT; they do not replace),
      so re-running does not duplicate.
-----------------------------------------------------------------------------*/
DELETE FROM dbo.CallReport_RCB WHERE JobId = @JobId;
DELETE FROM dbo.CallReport_HCB WHERE JobId = @JobId;


/*-----------------------------------------------------------------------------
  3.  Re-run the REAL Call Report procs against the now-WHOLE HedgeAccountingValues.
      (These are the exact production procs — no modification. The point is to
       prove the source fix flows through them untouched.)
-----------------------------------------------------------------------------*/
EXEC dbo.spInsertValsIntoCallRptRCB @JobId, @T_AsOfDate, @T_InTraderDate;
EXEC dbo.spInsertValsIntoCallRptHCB @JobId, @T_AsOfDate, @T_InTraderDate;

-- The two procs advance JobId 1794's StatusId (RCB sets 25). To leave the job as
-- you found it, uncomment the next line to restore the original status:
-- EXEC dbo.spUpdateBatchStatusId @JobId, @OrigStatus;


/*-----------------------------------------------------------------------------
  4.  BEFORE vs AFTER — RCB, by report line. Only rows whose BookValueHedged moved.
      EXPECT: the AFS US-Treasury line(s) carrying 91282CAV3 (and their subtotal)
      drop in BookValueHedged by the hedge correction. The whole thing nets to
      -358,835.58 on the detail lines (whole data absorbs the full hedge, so the
      hedged book value comes DOWN). Unwind/BookValue are unchanged.
-----------------------------------------------------------------------------*/
;WITH a AS (
    SELECT LineNumber, CurrentIntent,
           SUM(BookValue)       AS BV_before,
           SUM(BookValueHedged) AS BVH_before
    FROM   #rcb_before
    GROUP BY LineNumber, CurrentIntent
),
b AS (
    SELECT LineNumber, CurrentIntent,
           SUM(BookValue)       AS BV_after,
           SUM(BookValueHedged) AS BVH_after
    FROM   dbo.CallReport_RCB
    WHERE  JobId = @JobId
    GROUP BY LineNumber, CurrentIntent
)
SELECT  COALESCE(a.LineNumber, b.LineNumber)     AS LineNumber,
        COALESCE(a.CurrentIntent, b.CurrentIntent) AS CurrentIntent,
        CAST(a.BVH_before AS decimal(19,2))       AS BVH_before,
        CAST(b.BVH_after  AS decimal(19,2))       AS BVH_after,
        CAST(ISNULL(b.BVH_after,0) - ISNULL(a.BVH_before,0) AS decimal(19,2)) AS BVH_delta
FROM    a
FULL JOIN b ON a.LineNumber = b.LineNumber AND a.CurrentIntent = b.CurrentIntent
WHERE   ABS(ISNULL(b.BVH_after,0) - ISNULL(a.BVH_before,0)) > 0.005
ORDER BY LineNumber, CurrentIntent;


/*-----------------------------------------------------------------------------
  4b. BEFORE vs AFTER — HCB (same idea; usually no change unless HTM lots hedged).
-----------------------------------------------------------------------------*/
;WITH a AS (
    SELECT LineNumber, CurrentIntent, SUM(BookValueHedged) AS BVH_before
    FROM   #hcb_before GROUP BY LineNumber, CurrentIntent
),
b AS (
    SELECT LineNumber, CurrentIntent, SUM(BookValueHedged) AS BVH_after
    FROM   dbo.CallReport_HCB WHERE JobId = @JobId GROUP BY LineNumber, CurrentIntent
)
SELECT  COALESCE(a.LineNumber, b.LineNumber)       AS LineNumber,
        COALESCE(a.CurrentIntent, b.CurrentIntent) AS CurrentIntent,
        CAST(a.BVH_before AS decimal(19,2))        AS BVH_before,
        CAST(b.BVH_after  AS decimal(19,2))        AS BVH_after,
        CAST(ISNULL(b.BVH_after,0) - ISNULL(a.BVH_before,0) AS decimal(19,2)) AS BVH_delta
FROM    a
FULL JOIN b ON a.LineNumber = b.LineNumber AND a.CurrentIntent = b.CurrentIntent
WHERE   ABS(ISNULL(b.BVH_after,0) - ISNULL(a.BVH_before,0)) > 0.005
ORDER BY LineNumber, CurrentIntent;


/*-----------------------------------------------------------------------------
  5.  INDEPENDENT EXPECTED NUMBERS — computed straight from HedgeAccountingValues
      (the source of truth), so you have something to tie the delta to.

      Collapses the fan-out per lot (BookValueHedged is identical across the
      fanned rows -> MAX; accret/amort are genuine per-row -> SUM), then:
        WholeHedge   = sum over lots of [ (BVH - BV) - (Unamort - Unaccret) ]
        (this is the hedge basis adjustment the Call Report should now embed)

      EXPECT:
        WholeHedge_Now      ~ -717,671.10   (= Calypso hypothetical MTM)
        Correction_vs_Half  ~ -358,835.58   (= the RCB BVH delta on the Treasury
                                              detail line(s) in Section 4)
-----------------------------------------------------------------------------*/
;WITH perlot AS (
    SELECT  Vals.Ticket,
            MAX(CAST(Vals.BookValueHedged AS decimal(19,2))) AS BVH,
            MAX(CAST(Vals.BookValue       AS decimal(19,2))) AS BV,
            SUM(ISNULL(am.Unamortized,0))                    AS TotUnamort,
            SUM(ISNULL(ac.Unaccreted,0))                     AS TotUnaccret
    FROM    dbo.HedgeAccountingValues AS Vals
    INNER JOIN InputData.ip_CUSD_holdings AS hold
        ON Vals.FK_ip_CUSD_holdings = hold.PK_ip_CUSD_holdings
       AND hold.IsSettled = 'Y'
    LEFT JOIN InputData.ip_accret AS ac ON Vals.FK_ip_accret = ac.PK_ip_accret
    LEFT JOIN InputData.ip_amort  AS am ON Vals.FK_ip_amort  = am.PK_ip_amort
    WHERE   Vals.AsOfDate   = @T_AsOfDate
      AND   Vals.JobId      = @JobId
      AND   Vals.SecurityId = @Cusip
      AND   Vals.HedgeId    = @HedgeId
    GROUP BY Vals.Ticket
)
SELECT  @Cusip AS Cusip,
        COUNT(*) AS Lots,
        CAST(SUM((BVH - BV) - (TotUnamort - TotUnaccret)) AS decimal(19,2)) AS WholeHedge_Now,      -- ~ -717,671.10
        CAST(SUM((BVH - BV) - (TotUnamort - TotUnaccret)) / 2.0 AS decimal(19,2)) AS Correction_vs_Half  -- ~ -358,835.58
FROM    perlot;
