/*=============================================================================
  INC30712391 — Rebuild HedgeAccountingValues for JobId 1794 using the FIXED proc
  detolle (Doug Tolley), 2026-07-24

  *** DEV DB ONLY — this script WRITES (DELETE + INSERT for JobId 1794). ***

  WHY THIS INSTEAD OF re-running spBatch1:
    spIdentifyBatchDates aborts (FATAL status 99) when a completed job already
    exists for the AsOfDate — which 1794 is. The official CorrectionRun path also
    aborts unless you first clear HedgeAccountingValues, both CallReport tables,
    AND CalypsoHedgeTrades, then reload Calypso. For a validation we don't need
    that: job 1794 already has all inputs loaded, so we just re-run the calc +
    persist steps against it (no new job, no Calypso reload). The real
    spInsertValsToAdjValTemp has been ALTERed with the fix on this dev DB.

  HOW TO RUN:
    Run the whole thing in ONE connection/session — ##AdjustedValues is a global
    temp table and must survive between the EXEC calls. Then run the validation
    script (§3 with SUM->MAX, or query vw_curr_InTraderOps2_FIX).
=============================================================================*/
SET NOCOUNT ON;

DECLARE @JobId          int  = 1794;
DECLARE @T_AsOfDate     date;
DECLARE @T_CalypsoDate  date;
DECLARE @T_InTraderDate date;

SELECT @T_AsOfDate     = AsOfDate,
       @T_CalypsoDate  = CalypsoDate,
       @T_InTraderDate = InTraderDate
FROM dbo.BatchJobs
WHERE JobId = @JobId;

-- sanity: confirm the three dates before writing anything
SELECT @JobId AS JobId, @T_AsOfDate AS AsOfDate,
       @T_CalypsoDate AS CalypsoDate, @T_InTraderDate AS InTraderDate;

-- 1. Clear this job's persisted rows (adjusted + non-adjusted) so we don't duplicate.
DELETE FROM dbo.HedgeAccountingValues WHERE JobId = @JobId;

-- 2. (Re)create the ##AdjustedValues global temp table.
EXEC dbo.spCreateAdjValTempTable @JobId;

-- 3. FIXED adjusted-values calc — real proc was ALTERed with the fix on this dev DB.
EXEC dbo.spInsertValsToAdjValTemp @JobId, @T_AsOfDate, @T_CalypsoDate, @T_InTraderDate;

-- 4. Adjusted yields (operates on ##AdjustedValues).
EXEC dbo.spInsertAdjYieldsToAdjValTemp @JobId;

-- 5. Move adjusted temp rows -> HedgeAccountingValues.
EXEC dbo.spInsertTmpValsIntoAdjValsTable @JobId;

-- 6. Non-adjusted (non-hedged) rows -> HedgeAccountingValues, so portfolio totals are complete.
EXEC dbo.spInsertNonAdjValsToAcctgTable @JobId, @T_AsOfDate, @T_InTraderDate;

-- 7. (Optional, to mirror the full batch — only if your baseline relied on it)
-- EXEC dbo.LoadSoldUnwindValues @JobId, @T_AsOfDate;

-- Quick post-rebuild peek at the 9 lots: expect SwapWeight ~0.111111111 and
-- BookValueAdjustment ~ -3,612,888.77.
SELECT DISTINCT Ticket, SwapWeight, BookValue, BookValueHedged,
       (BookValueHedged - BookValue) AS BookValueAdjustment
FROM dbo.HedgeAccountingValues
WHERE AsOfDate = @T_AsOfDate AND JobId = @JobId AND HedgeId = '519'
ORDER BY Ticket;
