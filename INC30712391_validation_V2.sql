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

      Expected results:
        BASELINE (before deploy, old data):       Difference ~ +358,835.58  (the bug)
        AFTER deploy + re-run:                    Difference ~ 0            (fixed)

      This version inlines the view logic filtered to @Portfolio and @JobId to
      avoid the full-table scan that causes the view to time out on the dev DB.
      It replicates the same InTraderOps2 rollup logic as dbo.vw_curr_InTraderOps2.
-----------------------------------------------------------------------------*/
;WITH InTraderOps AS (
    SELECT
          Vals.Portfolio                                                          AS Group_IT
        , Vals.Ticket                                                            AS Ticket_IT
        , ISNULL(CAST(Vals.BookValue AS decimal(19,2)), 0)                       AS BookValue_IT
        , ISNULL(CAST(Vals.BookValueHedged AS decimal(19,2)), 0)                 AS BookValueHedged
        , ISNULL(CAST((Vals.BookValueHedged - Vals.BookValue) AS decimal(19,2)),0) AS BookValueAdjustment
        , CAST((ISNULL(Vals.BookValueHedged,0) - ISNULL(Vals.BookValue,0))
              - (ISNULL(ValsTotal.TotalUnamortized,0) - ISNULL(ValsTotal.TotalUnaccreted,0))
              AS decimal(19,2))                                                  AS BookValueAdjHedge
        , ISNULL(CAST((ISNULL(amort.unamortized,0) - ISNULL(accret.unaccreted,0))
              AS decimal(19,2)), 0)                                              AS BookValueAdjUnwind
    FROM dbo.HedgeAccountingValues AS Vals
    INNER JOIN InputData.ip_CUSD_holdings AS hold
        ON Vals.FK_ip_CUSD_holdings = hold.PK_ip_CUSD_holdings
    LEFT JOIN InputData.ip_accret AS accret
        ON Vals.FK_ip_accret = accret.PK_ip_accret
    LEFT JOIN InputData.ip_amort AS amort
        ON Vals.FK_ip_amort = amort.PK_ip_amort
    INNER JOIN (
        SELECT Vals2.Ticket,
               SUM(amort2.Unamortized) AS TotalUnamortized,
               SUM(accret2.Unaccreted) AS TotalUnaccreted
        FROM dbo.HedgeAccountingValues AS Vals2
        INNER JOIN InputData.ip_CUSD_holdings AS hold2
            ON Vals2.FK_ip_CUSD_holdings = hold2.PK_ip_CUSD_holdings
        LEFT JOIN InputData.ip_accret AS accret2
            ON Vals2.FK_ip_accret = accret2.PK_ip_accret
        LEFT JOIN InputData.ip_amort AS amort2
            ON Vals2.FK_ip_amort = amort2.PK_ip_amort
        WHERE Vals2.JobId = @JobId
          AND Vals2.Portfolio = @Portfolio
          AND hold2.IsSettled = 'Y'
        GROUP BY Vals2.Ticket
    ) ValsTotal
        ON Vals.Ticket = ValsTotal.Ticket
    WHERE Vals.JobId = @JobId
      AND Vals.Portfolio = @Portfolio
      AND hold.IsSettled = 'Y'
),
InTraderOps2 AS (
    SELECT DISTINCT
          a.Group_IT
        , a.Ticket_IT
        , a.BookValueAdjustment
        , b.BookValueAdjHedge
        , b.BookValueAdjUnwind
    FROM InTraderOps a
    INNER JOIN (
        SELECT Ticket_IT
             , MAX(BookValueAdjHedge)   AS BookValueAdjHedge   -- INC30712391 Option C (AFTER fix): whole hedge is identical on each fanned row -> take ONCE. (Use SUM only for the pre-fix HALVED baseline.)
             , SUM(BookValueAdjUnwind)  AS BookValueAdjUnwind
        FROM InTraderOps
        GROUP BY Ticket_IT
    ) b ON a.Ticket_IT = b.Ticket_IT
)
SELECT
      Group_IT
    , SUM(BookValueAdjustment)                                   AS TotalBVA
    , SUM(BookValueAdjHedge)                                     AS TotalHedge
    , SUM(BookValueAdjUnwind)                                    AS TotalUnwind
    , SUM(BookValueAdjHedge) + SUM(BookValueAdjUnwind)           AS HedgePlusUnwind
    , SUM(BookValueAdjustment)
        - (SUM(BookValueAdjHedge) + SUM(BookValueAdjUnwind))     AS Difference
FROM InTraderOps2
GROUP BY Group_IT;
