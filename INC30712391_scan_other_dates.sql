/*=============================================================================
  INC30712391 — SCAN OTHER DATES for the fan-out / halved-SwapWeight issue
  Read-only.  Answers: did this happen on days other than 7/22/2026 (before OR after)?

  HOW IT DETECTS IT (no reference data needed):
    Within a hedge pool, each lot's SwapWeight = CurrentFace / SUM(CurrentFace),
    so the DISTINCT lots' SwapWeights sum to EXACTLY 1.0 when correct. The fan-out
    (a hedged lot that also carries prior-unwind accretion -> multiple HAV rows per
    lot) doubles the face in the denominator, so each weight is halved and the
    distinct-lot sum drops to ~0.5 (or 1/N for an N-way fan-out). That shortfall
    is the fingerprint of this bug.

  READING THE RESULTS (reflects CURRENT stored data):
    Finding = 'UNDERSTATED ...'  -> SwapWeight fractioned; that date is STILL buggy
                                    (SumSwapWeight ~0.5 = 2x fan-out; ~0.33 = 3x, etc.)
    Finding = 'fan-out, weight OK' -> the trigger condition existed but the weight is
                                    correct now (date already reprocessed/fixed, or benign)
    No rows for a date            -> neither the effect nor the condition on that date.

  BL's claim ("not before 7/22"): widen @FromDate; if nothing shows before 7/22, confirmed.
  NOTE: pool grain = Xref_HedgeMapping.PoolId (matches the SwapWeights CTE denominator).
=============================================================================*/

DECLARE @FromDate date = '2026-01-01';                 -- widen to check earlier history
DECLARE @ToDate   date = CAST(GETDATE() AS date);
DECLARE @Tol      decimal(19,9) = 0.99;                -- distinct-lot weight sum below this = flagged

;WITH hav AS (   -- collapse the fan-out: one row per (date, mapping, lot); count the fanned rows
    SELECT  h.AsOfDate, h.FK_Xref_HedgeMapping, h.Ticket, h.SecurityId, h.Portfolio, h.HedgeId,
            SwapWeight = MAX(h.SwapWeight),
            FanoutRows = COUNT(*)
    FROM    dbo.HedgeAccountingValues h
    WHERE   h.IsAdjustedRecord = 'y'
      AND   h.SwapWeight > 0                            -- hedged lots only
      AND   h.AsOfDate BETWEEN @FromDate AND @ToDate
    GROUP BY h.AsOfDate, h.FK_Xref_HedgeMapping, h.Ticket, h.SecurityId, h.Portfolio, h.HedgeId
),
pool AS (   -- map each hedge mapping to its PoolId (the weight denominator's grain)
    SELECT DISTINCT PK_Xref_HedgeMapping, PoolId
    FROM   dbo.Xref_HedgeMapping
    WHERE  ActiveMapping = 'y'
),
per_lot AS (
    SELECT  hav.AsOfDate, p.PoolId, hav.HedgeId, hav.SecurityId, hav.Portfolio,
            hav.Ticket, hav.SwapWeight, hav.FanoutRows
    FROM    hav
    JOIN    pool p ON p.PK_Xref_HedgeMapping = hav.FK_Xref_HedgeMapping
),
per_pool AS (
    SELECT  AsOfDate, PoolId,
            SecurityId    = MIN(SecurityId),
            Portfolio     = MIN(Portfolio),
            HedgeId       = MIN(HedgeId),
            DistinctLots  = COUNT(*),
            SumSwapWeight = SUM(SwapWeight),
            MaxFanoutRows = MAX(FanoutRows)
    FROM    per_lot
    GROUP BY AsOfDate, PoolId
)

/*--- RESULT 1: per-DATE summary (the headline "which days") ---*/
SELECT  AsOfDate,
        Pools_Understated = SUM(CASE WHEN SumSwapWeight < @Tol THEN 1 ELSE 0 END),
        Pools_FanoutOnly  = SUM(CASE WHEN SumSwapWeight >= @Tol AND MaxFanoutRows > 1 THEN 1 ELSE 0 END)
FROM    per_pool
GROUP BY AsOfDate
HAVING  SUM(CASE WHEN SumSwapWeight < @Tol OR MaxFanoutRows > 1 THEN 1 ELSE 0 END) > 0
ORDER BY AsOfDate;

/*--- RESULT 2: detail — every affected pool/date ---*/
;WITH hav AS (
    SELECT  h.AsOfDate, h.FK_Xref_HedgeMapping, h.Ticket, h.SecurityId, h.Portfolio, h.HedgeId,
            SwapWeight = MAX(h.SwapWeight), FanoutRows = COUNT(*)
    FROM    dbo.HedgeAccountingValues h
    WHERE   h.IsAdjustedRecord = 'y' AND h.SwapWeight > 0
      AND   h.AsOfDate BETWEEN @FromDate AND @ToDate
    GROUP BY h.AsOfDate, h.FK_Xref_HedgeMapping, h.Ticket, h.SecurityId, h.Portfolio, h.HedgeId
),
pool AS (SELECT DISTINCT PK_Xref_HedgeMapping, PoolId FROM dbo.Xref_HedgeMapping WHERE ActiveMapping='y'),
per_lot AS (
    SELECT hav.AsOfDate, p.PoolId, hav.HedgeId, hav.SecurityId, hav.Portfolio, hav.Ticket, hav.SwapWeight, hav.FanoutRows
    FROM hav JOIN pool p ON p.PK_Xref_HedgeMapping = hav.FK_Xref_HedgeMapping
),
per_pool AS (
    SELECT AsOfDate, PoolId, SecurityId=MIN(SecurityId), Portfolio=MIN(Portfolio), HedgeId=MIN(HedgeId),
           DistinctLots=COUNT(*), SumSwapWeight=SUM(SwapWeight), MaxFanoutRows=MAX(FanoutRows)
    FROM per_lot GROUP BY AsOfDate, PoolId
)
SELECT  AsOfDate, Portfolio, SecurityId, HedgeId, PoolId,
        DistinctLots, MaxFanoutRows,
        SumSwapWeight = CAST(SumSwapWeight AS decimal(19,6)),
        ImpliedFanFactor = CAST(1.0 / NULLIF(SumSwapWeight,0) AS decimal(10,3)),   -- ~2.0 => halved
        Finding = CASE
                    WHEN SumSwapWeight < @Tol THEN '*** UNDERSTATED - SwapWeight fractioned by fan-out ***'
                    WHEN MaxFanoutRows > 1    THEN 'fan-out present, weight OK (reprocessed/benign)'
                    ELSE 'ok'
                  END
FROM    per_pool
WHERE   SumSwapWeight < @Tol OR MaxFanoutRows > 1
ORDER BY AsOfDate, Portfolio, SecurityId;
