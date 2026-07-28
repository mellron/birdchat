/*=============================================================================
  INC30712391 — Reproduce the IPOPS reports in SQL (no Power BI needed)
  detolle, 2026-07-25   (read-only)

  The Power BI IPOPS reports read the vw_hist_* views (custom SQL) and do the
  roll-up in Power BI. This script reproduces what each report shows AND the
  corrected value, so you can review the fix without opening Power BI.

  Run against whichever DB you want to check (dev = fixed, prod = unfixed).
  Key tell: BookValueAdjustment = -3,612,888.76/lot => dev/fixed.
            = -3,573,018.15/lot => prod/unfixed.
=============================================================================*/
DECLARE @AsOfDate  date        = '2026-07-22';
DECLARE @Portfolio varchar(20) = '100AUST';
DECLARE @Cusip     varchar(20) = '91282CAV3';


/*-----------------------------------------------------------------------------
  IPOPS1 — ticket level (reproduces the IP_Ops 1 page).
  Power BI sums BookValueAdjHedge across the 2 fan-out rows => "AsReportShows".
  The fix takes it once per ticket => "Corrected".
-----------------------------------------------------------------------------*/
SELECT
      Ticket_IT
    , COUNT(*)                          AS RowsPerTicket              -- expect 2 (fan-out)
    , MAX(BookValueAdjustment)          AS BookValueAdjustment        -- shown once (identical per row)
    , SUM(BookValueAdjHedge)            AS Hedge_AsReportShows        -- Power BI SUM  -> doubled
    , MAX(BookValueAdjHedge)            AS Hedge_Corrected            -- take once     -> the fix
    , SUM(BookValueAdjUnwind)           AS Unwind
    , MAX(BookValueAdjustment)
        - (SUM(BookValueAdjHedge) + SUM(BookValueAdjUnwind)) AS Diff_AsReportShows   -- ~ +79,741 (over)
    , MAX(BookValueAdjustment)
        - (MAX(BookValueAdjHedge) + SUM(BookValueAdjUnwind)) AS Diff_Corrected       -- ~ 0
FROM dbo.vw_hist_InTraderOps1
WHERE AsOfDate = @AsOfDate AND Group_IT = @Portfolio AND Security_IT = @Cusip
GROUP BY Ticket_IT
ORDER BY Ticket_IT;


/*-----------------------------------------------------------------------------
  IPOPS2 — portfolio summary (reproduces the IP_Ops 2 page).
  De-dup to ticket first (BVA once, unwind summed), then roll to portfolio.
  Shows the "Difference" both as the report shows it and corrected.
-----------------------------------------------------------------------------*/
;WITH PerTicket AS (
    SELECT
          Group_IT, Ticket_IT
        , MAX(BookValueAdjustment) AS BVA
        , SUM(BookValueAdjHedge)   AS Hedge_Sum      -- Power BI current (doubles fan-out lots)
        , MAX(BookValueAdjHedge)   AS Hedge_Once     -- corrected
        , SUM(BookValueAdjUnwind)  AS Unwind
    FROM dbo.vw_hist_InTraderOps1
    WHERE AsOfDate = @AsOfDate AND Group_IT = @Portfolio
    GROUP BY Group_IT, Ticket_IT
)
SELECT
      Group_IT
    , SUM(BVA)        AS Total_BookValueAdjustment
    , SUM(Hedge_Sum)  AS Total_Hedge_AsReportShows
    , SUM(Hedge_Once) AS Total_Hedge_Corrected
    , SUM(Unwind)     AS Total_Unwind
    , SUM(BVA) - (SUM(Hedge_Sum)  + SUM(Unwind)) AS Difference_AsReportShows   -- ~ +717,671 (over, DB-fixed/PBI-not)
    , SUM(BVA) - (SUM(Hedge_Once) + SUM(Unwind)) AS Difference_Corrected       -- ~ 0 (after PBI Max change)
FROM PerTicket
GROUP BY Group_IT;


/*-----------------------------------------------------------------------------
  IPOPS3 — from vw_hist_MRO (what the exported "IP Ops 3" columns actually match).
  MRO de-dups the fan-out (SELECT DISTINCT), so no doubling: the fix simply
  corrects the value. Expect FairValueHypo ~ -79,741.23/lot, total ~ -717,671.10.
-----------------------------------------------------------------------------*/
SELECT
      Ticket_IT
    , FairValueHypo
    , BookValueHedged
    , BookValueAdjustment
    , HedgeUnwindAmortization
FROM dbo.vw_hist_MRO
WHERE AsOfDate = @AsOfDate AND Security_IT = @Cusip
ORDER BY Ticket_IT;
