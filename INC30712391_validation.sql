/*=============================================================================
  INC30712391 — Validation / test script   (read-only SELECTs)
  detolle (Doug Tolley), 2026-07-24

  PURPOSE
    Prove, on a dev DB restored from prod, that:
      (BEFORE fix) Portfolio 100AUST is short $358,835.58 because HAT stores a
                   halved SwapWeight (1/18) and a halved BookValueHedged on the
                   9 lots of the new hedge (HedgeId 519, CUSIP 91282CAV3), and
      (AFTER fix)  SwapWeight = 1/9, BookValueHedged picks up the full hedge, and
                   BookValueAdjustment = BookValueAdjHedge + BookValueAdjUnwind.

  HOW TO USE
    Run sections 0-3 as the BASELINE right after the restore (before deploying).
    Then deploy the fix into the REAL objects (spInsertValsToAdjValTemp + both
    vw_*_InTraderOps2 views), re-run the batch for 2026-07-22 so
    HedgeAccountingValues is rebuilt, and run sections 0-3 again as the AFTER.

    All queries are read-only. Nothing here changes data.
=============================================================================*/

DECLARE @AsOfDate  date        = '2026-07-22';   -- incident date
DECLARE @HedgeId   varchar(20) = '519';          -- the new pay-fixed hedge
DECLARE @Portfolio varchar(20) = '100AUST';
DECLARE @Cusip     varchar(20) = '91282CAV3';

-- Latest job for that date (auto-follows a re-run that creates a new JobId)
DECLARE @JobId int =
    (SELECT MAX(JobId) FROM dbo.HedgeAccountingValues WHERE AsOfDate = @AsOfDate);


/*-----------------------------------------------------------------------------
  0.  Batch job status — heads-up for the re-run
      spInsertValsToAdjValTemp skips when StatusId = 99 (complete). If the
      restored 1794 job is already 99, reset it or run a fresh 7/22 batch.
-----------------------------------------------------------------------------*/
SELECT JobId, AsOfDate, StatusId
FROM dbo.BatchJobs
WHERE AsOfDate = @AsOfDate
ORDER BY JobId;


/*-----------------------------------------------------------------------------
  1.  Row-level fingerprint of the fan-out (the mechanism)
      Expect 2 rows per Ticket (one per unwind accret record).
        BEFORE fix : SwapWeight ~ 0.055555556  (1/18)
        AFTER  fix : SwapWeight ~ 0.111111111  (1/9)   <- doubled = corrected
      Row count per ticket stays 2 either way (the fan-out is by design; the fix
      only corrects the divisor, not the number of rows).
-----------------------------------------------------------------------------*/
SELECT
      Ticket
    , SecurityId
    , Portfolio
    , COUNT(*) OVER (PARTITION BY Ticket)      AS RowsPerTicket
    , FK_ip_accret
    , FK_ip_amort
    , SwapWeight
    , BookValue
    , BookValueHedged
    , (BookValueHedged - BookValue)            AS BookValueAdjustment
FROM dbo.HedgeAccountingValues
WHERE AsOfDate = @AsOfDate
  AND JobId    = @JobId
  AND HedgeId  = @HedgeId
ORDER BY Ticket, FK_ip_accret;


/*-----------------------------------------------------------------------------
  2.  One value per lot (DISTINCT collapses the identical fan-out rows)
      Expect 9 rows.
        BEFORE fix : BookValueAdjustment ~ -3,573,018.15  (hedge piece -39,870.62)
        AFTER  fix : BookValueAdjustment ~ -3,612,888.77  (hedge piece -79,741.24)
-----------------------------------------------------------------------------*/
SELECT DISTINCT
      Ticket
    , SwapWeight
    , BookValue
    , BookValueHedged
    , (BookValueHedged - BookValue)            AS BookValueAdjustment
FROM dbo.HedgeAccountingValues
WHERE AsOfDate = @AsOfDate
  AND JobId    = @JobId
  AND HedgeId  = @HedgeId
ORDER BY Ticket;


/*-----------------------------------------------------------------------------
  3.  THE MONEY CHECK — IPOPS2 portfolio tie-out
      Difference = BookValueAdjustment - (BookValueAdjHedge + BookValueAdjUnwind)
      The identity should hold (Difference = 0).

      Run this against whichever view matches the state you are in:

        BASELINE (before deploy, old data, original view):
            dbo.vw_curr_InTraderOps2            -> Difference ~ +358,835.58   (the bug)

        AFTER deploy + re-run, using the FIXED view:
            dbo.vw_curr_InTraderOps2_FIX (or the altered real view)
                                                -> Difference ~ 0             (fixed)

        AFTER re-run but using the ORIGINAL (SUM) view on corrected data
        (demonstrates why the proc can't ship alone):
            dbo.vw_curr_InTraderOps2            -> Difference ~ +717,671.10   (doubled the other way)

      NOTE: the view self-selects MAX(JobId) across HedgeAccountingValues, so it
      reflects the newest run automatically. Make sure 2026-07-22 is the latest
      job on the dev DB (a fresh 7/22 batch will be).

      Edit the FROM below to point at the view you want to test.
-----------------------------------------------------------------------------*/
SELECT
      Group_IT
    , SUM(BookValueAdjustment)                                   AS TotalBVA
    , SUM(BookValueAdjHedge)                                     AS TotalHedge
    , SUM(BookValueAdjUnwind)                                    AS TotalUnwind
    , SUM(BookValueAdjHedge) + SUM(BookValueAdjUnwind)           AS HedgePlusUnwind
    , SUM(BookValueAdjustment)
        - (SUM(BookValueAdjHedge) + SUM(BookValueAdjUnwind))     AS Difference
FROM dbo.vw_curr_InTraderOps2            -- <-- swap to _FIX view for the AFTER test
WHERE Group_IT = @Portfolio
GROUP BY Group_IT;
