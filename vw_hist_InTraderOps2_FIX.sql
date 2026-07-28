

CREATE view [dbo].[vw_hist_InTraderOps2_FIX] as
/***********************************************************
View Description:Will show all historical records for the InTradersOps2 report.
Used By: Hedge Accounting Batch

Created by: Spencer Gansluckner
Created when:  7/11/2019

Modifications:
Date			By						Reason/What changed
--------		-------------			-------------------
07/11/2019		Spencer Gansluckner		Creation
10/28/2019		Spencer Gansluckner		Added 2 new fields: BookValueAdjHedge & BookValueAdjUnwind per jira item HA-511
05/28/2024		Subham Maiti			Added CTE change for multiple unwind
07/02/2024      Sushma Kusumba          Added IsSettled Flag as 'Y' for CUSD holdings to exclude Intrader intraday records
07/24/2026      detolle (Doug Tolley)   INC30712391 — Take BookValueAdjHedge ONCE per ticket (MAX) instead of SUM, so it
                                        is not double-counted across the multiple-unwind fan-out rows. Companion to the
                                        spInsertValsToAdjValTemp SwapWeights fix. See "INC30712391 FIX NOTES" below.
*************************************************************/

/*=============================================================================
  INC30712391 FIX NOTES  —  detolle (Doug Tolley), 2026-07-24 10:22 EDT
  -----------------------------------------------------------------------------
  This is the COMPANION view change to the fix in
  spInsertValsToAdjValTemp_FIX (same change as vw_curr_InTraderOps2_FIX, applied
  to the historical view). Deploy the set together.

  BACKGROUND
      For a lot that carries more than one unwind record, HedgeAccountingValues
      holds one row PER unwind record (fan-out). Those rows are IDENTICAL in
      BookValueHedged / BookValue / total unwind, and therefore identical in the
      per-row BookValueAdjHedge below — they differ only in BookValueAdjUnwind
      (each row joins to its own ip_accret / ip_amort).

  WHAT WAS WRONG
      The InTraderOps2 rollup did SUM([BookValueAdjHedge]) grouped by ticket.
      Because the fan-out rows carry the SAME hedge value, that SUM double-counts
      the hedge. Today it is masked only because the SwapWeight was itself halved
      upstream (the two bugs cancelled for this column). Once
      spInsertValsToAdjValTemp_FIX makes SwapWeight correct, this SUM would
      double the Hedge column (e.g. -159,482.48 instead of -79,741.24 per lot).

  THE FIX
      Take the hedge value ONCE per ticket with MAX([BookValueAdjHedge]) — the
      rows are identical for this column, so MAX (or MIN) returns the single
      correct value. BookValueAdjUnwind stays SUM(...) because each fan-out row
      contributes a distinct unwind piece that must still be totalled.
=============================================================================*/
WITH InTraderOps AS (
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
	WHERE hold.IsSettled = 'Y'
GROUP BY Vals.AsOfDate, Vals.Ticket) ValsTotal
	on Vals.Ticket = ValsTotal.Ticket
	and Vals.AsOfDate = ValsTotal.AsOfDate
WHERE hold.IsSettled = 'Y'
),

InTraderOps2 AS (
SELECT DISTINCT a.[AsOfDate]
      ,[Group_IT]
      ,[Intent_IT]
      ,[Security_IT]
      ,a.[Ticket_IT]
      ,[BookValue_IT]
      ,[BookValueHedged]
      ,[BookValueAdjustment]
      ,b.[BookValueAdjHedge]
      ,b.[BookValueAdjUnwind]
      ,[FairValue_IT]
      ,[UnrealizedPL_IT]
      ,[UnrealizedPLHedged]
  FROM InTraderOps a
  INNER JOIN (
SELECT [AsOfDate]
      ,[Ticket_IT]
      -- INC30712391 FIX: MAX (take once), not SUM. The multiple-unwind fan-out rows
      -- carry an identical BookValueAdjHedge; SUM double-counted the hedge. Paired with
      -- the SwapWeights fix in spInsertValsToAdjValTemp_FIX. (was: SUM([BookValueAdjHedge]))
      ,MAX([BookValueAdjHedge]) as BookValueAdjHedge
      ,SUM([BookValueAdjUnwind]) as [BookValueAdjUnwind]
  FROM InTraderOps
  group by [AsOfDate], Ticket_IT
) b
on a.AsOfDate = b.AsOfDate
and a.Ticket_IT = b.Ticket_IT
)

SELECT [AsOfDate]
      ,[Group_IT]
      ,[Intent_IT]
      ,[BookValue_IT]
      ,[BookValueHedged]
      ,[BookValueAdjustment]
      ,[BookValueAdjHedge]
      ,[BookValueAdjUnwind]
      ,[FairValue_IT]
      ,[UnrealizedPL_IT]
      ,[UnrealizedPLHedged]
  FROM InTraderOps2

GO
