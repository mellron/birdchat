CREATE view [dbo].[vw_hist_InTraderOps1_FIX] as
/***********************************************************
View Description: Historical records for the InTraderOps1 report (IPOPS 1 & 2 source).
Used By: Hedge Accounting Batch / Power BI IPOPS reports

Created by: Spencer Gansluckner  (7/11/2019)

Modifications:
Date			By						Reason/What changed
--------		-------------			-------------------
07/11/2019		Spencer Gansluckner		Creation
10/28/2019		Spencer Gansluckner		Added BookValueAdjHedge & BookValueAdjUnwind (HA-511)
05/24/2024		Subham Maiti			Added valstotal change for multiple unwind
07/02/2024      Sushma Kusumba          Added IsSettled Flag as 'Y'
07/27/2026      detolle (Doug Tolley)   INC30712391 — VIEW-ONLY fix. Collapse the multiple-unwind FAN-OUT
                                        to one row per ticket AND reconstruct the correct per-lot figures
                                        from components, with NO change to the proc or HedgeAccountingValues.
                                        (Historical mirror of vw_curr_InTraderOps1_FIX.)
*************************************************************/

/*=============================================================================
  INC30712391 FIX NOTES — detolle (Doug Tolley), 2026-07-27   (VIEW-ONLY approach)
  -----------------------------------------------------------------------------
  Resolves the IPOPS 1 & 2 fan-out WITHOUT touching spInsertValsToAdjValTemp or
  the HedgeAccountingValues table. The stored SwapWeight / BookValueHedged stay
  as-is (halved); this view RECONSTRUCTS the correct per-lot figures from the
  component columns the base view already exposes.

  PROBLEM   A lot with N prior-unwind accretion records is stored as N identical
            HedgeAccountingValues rows (they differ only in BookValueAdjUnwind /
            FK_ip_accret). SwapWeight = CurrentFace / TotalCurrentFace, and
            TotalCurrentFace is summed over the fanned rows, so each row's weight
            is 1/N of correct => each row carries only 1/N of the hedge.

  FIX       GROUP BY ticket and rebuild:
              BookValueAdjHedge   -> SUM   (each row = hedge/N; the N rows sum to the whole)
              BookValueAdjUnwind  -> SUM   (genuine per-record pieces)
              BookValueHedged     =  MAX(BookValue) + SUM(hedge) + SUM(unwind)
              BookValueAdjustment =  SUM(hedge) + SUM(unwind)
              UnrealizedPLHedged  =  MAX(FairValue) - BookValueHedged   (proc identity, line 752)
              BookValue/FairValue/UnrealizedPL -> MAX  (constant across the fan-out)
            Robust to any fan-out factor N, not just 2.

  WHY SUM (not MAX) ON THE HEDGE
            Because HedgeAccountingValues is left UNCHANGED, each stored row still
            holds only HALF (1/N) of the hedge, so SUM restores the whole. The
            earlier proc-based Option C used MAX because the proc fix had already
            made each row whole — that source-level path is DEFERRED to the JIRA.

  VERIFIED  7/22 lot 403085277 (2-way fan-out): SUM(hedge) = -79,741.23,
            SUM(unwind) = -3,533,147.53, BVA = -3,612,888.76. Ties exactly.

  SCOPE     IPOPS 1 & 2 only (this view family). IPOPS 3 (vw_*_InTraderAccounting),
            MRO, Call Reports, and the source-proc fix are deferred to the JIRA for
            detailed research — including confirming whether IPOPS 3 is involved
            (the reporter's IPOPS-3-origin remark is unconfirmed opinion).

  DEPLOY    ALTER the REAL dbo.vw_hist_InTraderOps1 with this body. Power BI reads
            it by name (rolling 180-day filter) => no Power BI change. This _FIX
            object exists for side-by-side testing only.

  GRAIN     Output is one row per lot (AsOfDate/Group/Intent/Security/Ticket).
            Repo scan: only the Power BI IPOPS reports read this view.
=============================================================================*/
SELECT
      Detail.AsOfDate
    , Detail.Group_IT
    , Detail.Intent_IT
    , Detail.Security_IT
    , Detail.Ticket_IT
    , CAST(MAX(Detail.BookValue_IT) AS decimal(19,2))                       AS BookValue_IT
    -- Rebuild hedged book value = book value + FULL hedge + FULL unwind.
    -- Per-row hedge is only 1/N of correct; SUM over the fanned rows restores the whole.
    , CAST(  MAX(Detail.BookValue_IT)
           + SUM(Detail.BookValueAdjHedge)
           + SUM(Detail.BookValueAdjUnwind) AS decimal(19,2))               AS BookValueHedged
    -- BVA = full hedge + full unwind (NOT MAX of the stored, understated column).
    , CAST(  SUM(Detail.BookValueAdjHedge)
           + SUM(Detail.BookValueAdjUnwind) AS decimal(19,2))               AS BookValueAdjustment
    , CAST(SUM(Detail.BookValueAdjHedge)  AS decimal(19,2))                 AS BookValueAdjHedge   -- fan-out: 1/N each -> SUM to whole
    , CAST(SUM(Detail.BookValueAdjUnwind) AS decimal(19,2))                 AS BookValueAdjUnwind  -- fan-out: genuine per-record pieces
    , CAST(MAX(Detail.FairValue_IT)    AS decimal(19,2))                    AS FairValue_IT
    , CAST(MAX(Detail.UnrealizedPL_IT) AS decimal(19,2))                    AS UnrealizedPL_IT
    -- UnrealizedPLHedged = FairValue - BookValueHedged  (identity from proc line 752).
    , CAST(  MAX(Detail.FairValue_IT)
           - ( MAX(Detail.BookValue_IT)
             + SUM(Detail.BookValueAdjHedge)
             + SUM(Detail.BookValueAdjUnwind) ) AS decimal(19,2))           AS UnrealizedPLHedged
FROM (
    -- ===== unchanged base body of dbo.vw_hist_InTraderOps1 =====
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
        where hold.IsSettled = 'Y'           --Added flag filter to exclude Intrader Intraday records
    -- ===== end base body =====
) AS Detail
GROUP BY
      Detail.AsOfDate
    , Detail.Group_IT
    , Detail.Intent_IT
    , Detail.Security_IT
    , Detail.Ticket_IT

GO
