/*=============================================================================
  INC30712391 — DEPLOYMENT (VIEW-ONLY)          detolle (Doug Tolley), 2026-07-27
  =============================================================================
  Resolves the IPOPS 1 & 2 fan-out at the REPORTING layer only. NO change to
  spInsertValsToAdjValTemp and NO change to any row in HedgeAccountingValues.

  WHAT THIS DOES
    ALTER dbo.vw_curr_InTraderOps1  — de-dup + reconstruct correct per-lot values
    ALTER dbo.vw_hist_InTraderOps1  — same (this is the one Power BI reads)

  WHY IT WORKS WITHOUT A DATA FIX
    A multiple-unwind lot is stored as N identical rows whose SwapWeight is 1/N
    of correct, so each row carries only 1/N of the hedge. These views rebuild
    the whole from the component columns the base view already exposes:
        BookValueAdjHedge  -> SUM  (N rows x hedge/N  = full hedge)
        BookValueAdjUnwind -> SUM  (genuine per-record pieces)
        BookValueHedged    =  MAX(BookValue) + SUM(hedge) + SUM(unwind)
        UnrealizedPLHedged =  MAX(FairValue) - BookValueHedged
    Robust to any fan-out factor N.

  SCOPE / DEFERRED TO JIRA
    In scope : IPOPS 1 & 2 (this view family) — the incident's stated scope.
    Deferred : IPOPS 3 (vw_*_InTraderAccounting) — verify involvement first,
               MRO (has GL-tie logic), Call Reports (read a precomputed table),
               and the source-level proc fix (spInsertValsToAdjValTemp).

  ROLLBACK
    Re-deploy the original view bodies from source control
    (Database/dbo/Views/vw_curr_InTraderOps1.sql and vw_hist_InTraderOps1.sql).
    No data was changed, so rollback is view-definition-only.

  POST-DEPLOY VALIDATION
    Run the SELECT at the bottom (commented). Expect ONE row per lot and the
    reconstructed BVA of -3,612,888.76 for the 9 lots of 91282CAV3 in 100AUST.
=============================================================================*/


/*=============================================================================
  1 of 2 — CURRENT-DAY view
=============================================================================*/
ALTER view [dbo].[vw_curr_InTraderOps1] as
/* INC30712391 view-only fix — detolle 2026-07-27. De-dup the multiple-unwind
   fan-out and reconstruct correct per-lot values. No proc/table change. */
SELECT
      Detail.AsOfDate
    , Detail.Group_IT
    , Detail.Intent_IT
    , Detail.Security_IT
    , Detail.Ticket_IT
    , CAST(MAX(Detail.BookValue_IT) AS decimal(19,2))                       AS BookValue_IT
    , CAST(  MAX(Detail.BookValue_IT)
           + SUM(Detail.BookValueAdjHedge)
           + SUM(Detail.BookValueAdjUnwind) AS decimal(19,2))               AS BookValueHedged
    , CAST(  SUM(Detail.BookValueAdjHedge)
           + SUM(Detail.BookValueAdjUnwind) AS decimal(19,2))               AS BookValueAdjustment
    , CAST(SUM(Detail.BookValueAdjHedge)  AS decimal(19,2))                 AS BookValueAdjHedge
    , CAST(SUM(Detail.BookValueAdjUnwind) AS decimal(19,2))                 AS BookValueAdjUnwind
    , CAST(MAX(Detail.FairValue_IT)    AS decimal(19,2))                    AS FairValue_IT
    , CAST(MAX(Detail.UnrealizedPL_IT) AS decimal(19,2))                    AS UnrealizedPL_IT
    , CAST(  MAX(Detail.FairValue_IT)
           - ( MAX(Detail.BookValue_IT)
             + SUM(Detail.BookValueAdjHedge)
             + SUM(Detail.BookValueAdjUnwind) ) AS decimal(19,2))           AS UnrealizedPLHedged
FROM (
    select
    Vals.AsOfDate,
    Vals.Portfolio as Group_IT,
    hold.CurrentIntent as Intent_IT,
    Vals.SecurityId as Security_IT,
    Vals.Ticket as Ticket_IT,
    ISNULL(CAST(Vals.BookValue as decimal (19,2)), 0) as BookValue_IT,
    ISNULL(CAST(Vals.BookValueHedged as decimal (19,2)), 0) as BookValueHedged,
    ISNULL(CAST((Vals.BookValueHedged - Vals.BookValue) as decimal(19,2)),0) as BookValueAdjustment,
    CAST((ISNULL(Vals.BookValueHedged,0) - ISNULL(Vals.BookValue,0)) - (ISNULL(ValsTotal.TotalUnamortized,0) - ISNULL(ValsTotal.TotalUnaccreted,0)) as decimal (19,2)) as BookValueAdjHedge,
    ISNULL(CAST((ISNULL(amort.unamortized,0) - ISNULL(accret.unaccreted,0)) as decimal (19,2)), 0) as BookValueAdjUnwind,
    ISNULL(CAST(Vals.FairValue as decimal (19,2)), 0) as FairValue_IT,
    ISNULL(CAST(hold.UnrealizedPL as decimal (19,2)), 0) as UnrealizedPL_IT,
    ISNULL(CAST(Vals.UnrealizedPLHedged as decimal (19,2)), 0) as UnrealizedPLHedged
    from dbo.HedgeAccountingValues as Vals
    inner join InputData.ip_CUSD_holdings as hold
        on Vals.FK_ip_CUSD_holdings = hold.PK_ip_CUSD_holdings
    left join dbo.CalypsoHedgeTrades as Hedge
        on Vals.FK_CalypsoHedgeTrades = Hedge.PK_CalypsoHedgeTrades
    left join InputData.ip_accret as accret
        on Vals.FK_ip_accret = accret.PK_ip_accret
    left join InputData.ip_amort as amort
        on Vals.FK_ip_amort = amort.PK_ip_amort
    inner join(SELECT Vals.AsOfDate, Vals.Ticket,
        SUM(amort.Unamortized) as TotalUnamortized,
        SUM(accret.Unaccreted) as TotalUnaccreted
        from dbo.HedgeAccountingValues as Vals
    inner join InputData.ip_CUSD_holdings as hold
        on Vals.FK_ip_CUSD_holdings = hold.PK_ip_CUSD_holdings
    left join dbo.CalypsoHedgeTrades as Hedge
        on Vals.FK_CalypsoHedgeTrades = Hedge.PK_CalypsoHedgeTrades
    left join InputData.ip_accret as accret
        on Vals.FK_ip_accret = accret.PK_ip_accret
    left join InputData.ip_amort as amort
        on Vals.FK_ip_amort = amort.PK_ip_amort
    GROUP BY Vals.AsOfDate, Vals.Ticket) ValsTotal
        on Vals.Ticket = ValsTotal.Ticket
        and Vals.AsOfDate = ValsTotal.AsOfDate
    where Vals.JobId = (select max(JobId) from dbo.HedgeAccountingValues)
    and hold.IsSettled = 'Y'
) AS Detail
GROUP BY
      Detail.AsOfDate
    , Detail.Group_IT
    , Detail.Intent_IT
    , Detail.Security_IT
    , Detail.Ticket_IT
GO


/*=============================================================================
  2 of 2 — HISTORICAL view  (the one Power BI IPOPS 1 & 2 actually read)
=============================================================================*/
ALTER view [dbo].[vw_hist_InTraderOps1] as
/* INC30712391 view-only fix — detolle 2026-07-27. De-dup the multiple-unwind
   fan-out and reconstruct correct per-lot values. No proc/table change. */
SELECT
      Detail.AsOfDate
    , Detail.Group_IT
    , Detail.Intent_IT
    , Detail.Security_IT
    , Detail.Ticket_IT
    , CAST(MAX(Detail.BookValue_IT) AS decimal(19,2))                       AS BookValue_IT
    , CAST(  MAX(Detail.BookValue_IT)
           + SUM(Detail.BookValueAdjHedge)
           + SUM(Detail.BookValueAdjUnwind) AS decimal(19,2))               AS BookValueHedged
    , CAST(  SUM(Detail.BookValueAdjHedge)
           + SUM(Detail.BookValueAdjUnwind) AS decimal(19,2))               AS BookValueAdjustment
    , CAST(SUM(Detail.BookValueAdjHedge)  AS decimal(19,2))                 AS BookValueAdjHedge
    , CAST(SUM(Detail.BookValueAdjUnwind) AS decimal(19,2))                 AS BookValueAdjUnwind
    , CAST(MAX(Detail.FairValue_IT)    AS decimal(19,2))                    AS FairValue_IT
    , CAST(MAX(Detail.UnrealizedPL_IT) AS decimal(19,2))                    AS UnrealizedPL_IT
    , CAST(  MAX(Detail.FairValue_IT)
           - ( MAX(Detail.BookValue_IT)
             + SUM(Detail.BookValueAdjHedge)
             + SUM(Detail.BookValueAdjUnwind) ) AS decimal(19,2))           AS UnrealizedPLHedged
FROM (
    select
    Vals.AsOfDate,
    Vals.Portfolio as Group_IT,
    hold.CurrentIntent as Intent_IT,
    Vals.SecurityId as Security_IT,
    Vals.Ticket as Ticket_IT,
    ISNULL(CAST(Vals.BookValue as decimal (19,2)), 0) as BookValue_IT,
    ISNULL(CAST(Vals.BookValueHedged as decimal (19,2)), 0) as BookValueHedged,
    ISNULL(CAST((Vals.BookValueHedged - Vals.BookValue) as decimal(19,2)),0) as BookValueAdjustment,
    CAST((ISNULL(Vals.BookValueHedged,0) - ISNULL(Vals.BookValue,0)) - (ISNULL(ValsTotal.TotalUnamortized,0) - ISNULL(ValsTotal.TotalUnaccreted,0)) as decimal (19,2)) as BookValueAdjHedge,
    ISNULL(CAST((ISNULL(amort.unamortized,0) - ISNULL(accret.unaccreted,0)) as decimal (19,2)), 0) as BookValueAdjUnwind,
    ISNULL(CAST(Vals.FairValue as decimal (19,2)), 0) as FairValue_IT,
    ISNULL(CAST(hold.UnrealizedPL as decimal (19,2)), 0) as UnrealizedPL_IT,
    ISNULL(CAST(Vals.UnrealizedPLHedged as decimal (19,2)), 0) as UnrealizedPLHedged
    from dbo.HedgeAccountingValues as Vals
    inner join InputData.ip_CUSD_holdings as hold
        on Vals.FK_ip_CUSD_holdings = hold.PK_ip_CUSD_holdings
    left join dbo.CalypsoHedgeTrades as Hedge
        on Vals.FK_CalypsoHedgeTrades = Hedge.PK_CalypsoHedgeTrades
    left join InputData.ip_accret as accret
        on Vals.FK_ip_accret = accret.PK_ip_accret
    left join InputData.ip_amort as amort
        on Vals.FK_ip_amort = amort.PK_ip_amort
    inner join(SELECT Vals.AsOfDate, Vals.Ticket,
        SUM(amort.Unamortized) as TotalUnamortized,
        SUM(accret.Unaccreted) as TotalUnaccreted
        from dbo.HedgeAccountingValues as Vals
    inner join InputData.ip_CUSD_holdings as hold
        on Vals.FK_ip_CUSD_holdings = hold.PK_ip_CUSD_holdings
    left join dbo.CalypsoHedgeTrades as Hedge
        on Vals.FK_CalypsoHedgeTrades = Hedge.PK_CalypsoHedgeTrades
    left join InputData.ip_accret as accret
        on Vals.FK_ip_accret = accret.PK_ip_accret
    left join InputData.ip_amort as amort
        on Vals.FK_ip_amort = amort.PK_ip_amort
        where hold.IsSettled = 'Y'
    GROUP BY Vals.AsOfDate, Vals.Ticket) ValsTotal
        on Vals.Ticket = ValsTotal.Ticket
        and Vals.AsOfDate = ValsTotal.AsOfDate
        where hold.IsSettled = 'Y'
) AS Detail
GROUP BY
      Detail.AsOfDate
    , Detail.Group_IT
    , Detail.Intent_IT
    , Detail.Security_IT
    , Detail.Ticket_IT
GO


/*=============================================================================
  POST-DEPLOY VALIDATION  (run after the two ALTERs above)
  -----------------------------------------------------------------------------
  Expect: exactly ONE row per lot; each affected lot BookValueAdjHedge ~ -79,741.23,
  BookValueAdjustment (BVA) ~ -3,612,888.76; grain check returns ZERO rows.
=============================================================================*/
--SELECT AsOfDate, Group_IT, Security_IT, Ticket_IT,
--       BookValue_IT, BookValueHedged, BookValueAdjustment,
--       BookValueAdjHedge, BookValueAdjUnwind
--FROM   dbo.vw_hist_InTraderOps1
--WHERE  AsOfDate = '2026-07-22'
--  AND  Group_IT = '100AUST'
--ORDER  BY Security_IT, Ticket_IT;

-- grain check — must return NO rows (one row per lot):
--SELECT AsOfDate, Ticket_IT, COUNT(*) AS Rows_In_View
--FROM   dbo.vw_hist_InTraderOps1
--WHERE  AsOfDate = '2026-07-22'
--GROUP  BY AsOfDate, Ticket_IT
--HAVING COUNT(*) > 1;
