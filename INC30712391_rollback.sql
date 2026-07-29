/*=============================================================================
  INC30712391 — SQL ROLLBACK SCRIPT
  Reverts INC30712391_DEPLOY.sql (Option C). Restores the 3 deployed objects to
  their ORIGINAL, pre-fix definitions (verified: zero fix markers in the bodies).
  Prepared by: detolle (Doug Tolley).

  REVERTS (the same 3 objects the deploy ALTERs), as ALTER back to original:
    1. ALTER PROCEDURE dbo.spInsertValsToAdjValTemp   (undo SwapWeight de-dup fix)
    2. ALTER VIEW      dbo.vw_curr_InTraderOps1        (undo fan-out collapse)
    3. ALTER VIEW      dbo.vw_hist_InTraderOps1        (undo fan-out collapse)

  SCOPE: SQL OBJECTS ONLY. Re-running HAV / Call Report jobs to regenerate data is
  handled separately under the emergency ID (out of scope for this rollback).
  ENVIRONMENTS: identical for UAT and Production (object definitions are the same).
  NOTE: reverting code while corrected (whole) data remains in HAV can double-count
  in the SUM-based reports; if data remediation ran, coordinate the data revert
  under the emergency ID.
=============================================================================*/

SET NOCOUNT ON;
GO

/*-----------------------------------------------------------------------------
  1 of 3 — ALTER PROCEDURE dbo.spInsertValsToAdjValTemp  ->  ORIGINAL (pre-fix)
-----------------------------------------------------------------------------*/


/***********************************************************
SP Description:Inserts records to the ##AdjustedValues temporary tables for those tickets which are actively mapped in the dbo.Xref_HedgeMapping table and are therefore adjusted tickets
Used By: Hedge Accounting Batch

Created by: Spencer Gansluckner
Created when:  7/11/2019

Modifications:
Date			By						Reason/What changed
--------		-------------			-------------------
7/11/2019		Spencer Gansluckner		Creation
8/27/2020		Spencer Gansluckner		Added 3 new columns (delay, constantprepaymenterate, maturitydate) that are needed for calculating MBS adjusted yields
12/10/2020		Spencer Gansluckner		Added 30 days to Delay per InTrader reccommendations.  This was done so the adjusted book yields are correct.
12/16/2020		Spencer Gansluckner		Added PurchasePrice since MBS need that to calculate the book yield.
2/06/2021		Spencer Gansluckner		Filtered CalypsoHedgeTrades (T and T1) for just effective trades
3/27/2023		Spencer Gansluckner		Created new multiple swap approach
04/09/2024		Aadil Desai				Added logic for multiple unwind
07/02/2024      Sushma Kusumba          Added IsSettled Flag as 'Y' for CUSD holdings to exclude Intrader intraday records 
*************************************************************/
ALTER PROCEDURE [dbo].[spInsertValsToAdjValTemp]

@JobId int,
@T_AsOfDate date,
@T_CalypsoDate date,
@T_InTraderDate date

AS

BEGIN

	DECLARE @StatusId smallint


	SET @StatusId = (select StatusId from dbo.BatchJobs where JobId = @JobId)	
	If @StatusId != 99 
		BEGIN
			DECLARE @IsActiveMapping varchar(1)
			DECLARE @IsNotUnwound varchar(1)
			DECLARE @T1_InTrader date
			DECLARE @T1_Calypso date
			DECLARE @T1_AsOfDate date
			DECLARE @300EquityRate decimal(19,9)
			DECLARE @300TaxRate decimal(19,9)
			DECLARE @CodeType varchar(50)
			DECLARE @IsAdjustedRecord varchar(1)
			DECLARE @IsUnwound varchar(1)
			DECLARE @Effective varchar(50) --added 2/6/2021


			SET @IsActiveMapping = (select 
									ParameterValue 
									from dbo.BatchParameters 
									where ParameterName = 'IsActiveMapping')
			SET @IsNotUnwound = (select
								 ParameterValue 
								 from dbo.BatchParameters 
								 where ParameterName = 'IsNotUnwound')

			SET @IsUnwound = (select
								 ParameterValue 
								 from dbo.BatchParameters 
								 where ParameterName = 'IsUnwound')

			SET @T1_InTrader = (select 
								dates.PreviousBusinessDay 
								from dbo.BatchJobs as jobs 
								inner join dbo.Xref_Dates as dates
									on jobs.InTraderDate = dates.AsOfDate 
								where JobId = @JobId)

			SET @T1_AsOfDate = (select 
								dates.PreviousBusinessDay 
								from dbo.BatchJobs as jobs 
								inner join dbo.Xref_Dates as dates
									on jobs.AsOfDate = dates.AsOfDate 
								where JobId = @JobId)


			SET @T1_Calypso = (select 
								dates.PreviousBusinessDay 
								from dbo.BatchJobs as jobs 
								inner join dbo.Xref_Dates as dates
									on jobs.CalypsoDate = dates.AsOfDate 
								where JobId = @JobId)

			SET @300EquityRate =	(select
									ParameterValue
									from dbo.BatchParameters
									Where ParameterName = '300EquityRate')

			SET @300TaxRate =		(select
									ParameterValue
									from dbo.BatchParameters
									Where ParameterName = '300TaxRate')

			SET @IsAdjustedRecord =		(select
									ParameterValue
									from dbo.BatchParameters
									Where ParameterName = 'IsAdjustedRecord')

			SET @CodeType =			(select
									ParameterValue
									from dbo.BatchParameters
									Where ParameterName = 'CouponFrequency')

			-- added @Effective variable on 2/6/2021
			SET @Effective =		(select
									ParameterValue
									from dbo.BatchParameters
									Where ParameterName = 'EffectiveHedgeStatus')

;


With Mappings as
(
	select
	Mapping.PK_Xref_HedgeMapping,
	Mapping.SwapTradeID,
	Mapping.HypoTradeID,
	Mapping.HedgeId,
	Mapping.CurrentTicket,
	UnwindTicket.UnwindTicket as CurrentUnwindTicket,
	Mapping.PoolId
	from dbo.Xref_HedgeMapping as Mapping with (NOLOCK)
	left join [dbo].[Xref_UnwindTicket] as UnwindTicket with (NOLOCK)
	on Mapping.CurrentTicket = UnwindTicket.CurrentTicket 
	and UnwindTicket.ActiveMapping = @IsActiveMapping
	where Mapping.ActiveMapping = @IsActiveMapping
),


T1Mappings as
(
	select
	a.PK_Xref_HedgeMapping,
	a.SwapTradeID,
	a.HypoTradeID,
	a.HedgeId,
	a.CurrentTicket,
	CASE When TicketChanges.OldTicket IS NULL Then a.CurrentTicket Else TicketChanges.OldTicket End as JoiningTicket,
	a.CurrentUnwindTicket,
	a.PoolId
	from Mappings as a
	left join	(--find any changed tickets
				select
				TicketChanges.OldTicket,
				TicketChanges.CurrentTicket
				from dbo.Xref_TicketChanges as TicketChanges with (NOLOCK)
				where TicketChanges.TicketChangeDate = @T_AsOfDate) as TicketChanges
		on a.CurrentTicket = TicketChanges.CurrentTicket
),


PoolMappings as
(
	select distinct
	PoolId,
	CurrentTicket,
	CurrentUnwindTicket
	from Mappings
),

T1PoolMappings as
(
	select distinct
	PoolId,
	CurrentTicket,
	CurrentUnwindTicket,
	JoiningTicket
	from T1Mappings
),

bndhold as--get a list of asset holding info for T and T-1
(
	select
	bndhold.ProcessDate,
	bndhold.PK_ip_CUSD_holdings,
	bndhold.Portfolio,
	bndhold.SecurityId,
	bndhold.Ticket,
	bndhold.SecurityType,
	bndhold.Maturity,
	bndhold.EstimatedMaturity,
	bndhold.CallDate,
	bndhold.SecurityRate,
	bndhold.CurrentFace,
	bndhold.BookValue,
	bndhold.FairValue,
	bndhold.BookYield,
	bndhold.TaxEquivalentYield,
	bndhold.InterestPaymentSchedule,
	CASE when bndhold.[Delay] is not null Then bndhold.[Delay] + 30 Else bndhold.[Delay] End as [Delay], --modified this value to get the correct delay per intrader
	bndhold.PurchasePrice -- added 12/16/2020
	from InputData.ip_CUSD_holdings as bndhold with (NOLOCK)
	where bndhold.ProcessDate IN(
	@T_InTraderDate,
	@T1_InTrader)
	and bndhold.[IsSettled] = 'Y'
),
 
bndAccru as--get a list of accrual ifo for T
(
	select
	bndAccru.ProcessDate,
	bndAccru.PK_ip_CUSD_accrual,
	bndAccru.Ticket,
	bndAccru.DailyAccrual,
	bndAccru.LastInterestPaidDate,
	bndAccru.NextInterestPaidDate
	from InputData.ip_CUSD_accrual as bndAccru
	where bndAccru.ProcessDate = @T_InTraderDate
),

Hedges as --get a list of hedge infor for T and T-1
(
	select
	Hedges.AsOfDate,
	Hedges.PK_CalypsoHedgeTrades,
	Hedges.SwapTradeId,
	Hedges.HypoTradeId,
	Hedges.HedgeId,
	Hedges.SwapMTM,
	Hedges.SwapAccrued,
	Hedges.HypoMTM,
	Hedges.HypoAccrued
	from dbo.CalypsoHedgeTrades as Hedges with (NOLOCK)
	where Hedges.AsOfDate IN(
	@T_CalypsoDate,
	@T1_Calypso)
	and Hedges.HedgeStatus = @Effective
),

EnrichedHedges as--grabs data from Hedges cte  for T and T-1 and then joins the mapping data to it
(
	select
	Hedges.AsOfDate,
	Hedges.PK_CalypsoHedgeTrades,
	Hedges.SwapTradeId,
	Hedges.HypoTradeId,
	Hedges.HedgeId,
	Hedges.SwapMTM,
	Hedges.SwapAccrued,
	Hedges.HypoMTM,
	Hedges.HypoAccrued,
	Mappings.PK_Xref_HedgeMapping,
	Mappings.CurrentTicket,
	Mappings.CurrentUnwindTicket,
	Mappings.PoolId
	from Hedges as Hedges
	inner join Mappings as Mappings
		on Hedges.SwapTradeId = Mappings.SwapTradeID
		and Hedges.HypoTradeId = Mappings.HypoTradeID
		and Hedges.HedgeId = Mappings.HedgeId

),

THedgePools as
(
	select distinct
	a.AsOfDate,
	b.PoolId,
	a.SwapTradeId,
	a.HypoTradeId
	from EnrichedHedges as a
	inner join Mappings as b
		on a.SwapTradeId = b.SwapTradeID
		and a.HypoTradeId = b.HypoTradeID
		and a.HedgeId = b.HedgeId
	where a.AsOfDate = @T_CalypsoDate
),

T1EnrichedHedges as
(
	select
	Hedges.AsOfDate,
	Hedges.PK_CalypsoHedgeTrades,
	Hedges.SwapTradeId,
	Hedges.HypoTradeId,
	Hedges.HedgeId,
	Hedges.SwapMTM,
	Hedges.SwapAccrued,
	Hedges.HypoMTM,
	Hedges.HypoAccrued,
	Mappings.PK_Xref_HedgeMapping,
	Mappings.CurrentTicket,
	Mappings.JoiningTicket,
	Mappings.CurrentUnwindTicket,
	Mappings.PoolId
	from Hedges as Hedges
	inner join T1Mappings as Mappings
		on Hedges.SwapTradeId = Mappings.SwapTradeID
		and Hedges.HypoTradeId = Mappings.HypoTradeID
		and Hedges.HedgeId = Mappings.HedgeId
),


T1HedgePools as
(
	select distinct
	a.AsOfDate,
	b.PoolId,
	a.SwapTradeId,
	a.HypoTradeId
	from T1EnrichedHedges as a
	inner join Mappings as b
		on a.SwapTradeId = b.SwapTradeID
		and a.HypoTradeId = b.HypoTradeID
		and a.HedgeId = b.HedgeId
	where a.AsOfDate = @T1_Calypso
),

THedgesSummedByPool as
(
	select
	a.AsOfDate,
	a.PoolId,
	sum(b.SwapMTM) as SwapMTM,
	sum(b.SwapAccrued) as SwapAccrued,
	sum(b.HypoMTM) as HypoMTM,
	sum(b.HypoAccrued) as HypoAccrued
	from THedgePools as a
	inner join Hedges as b
		on a.SwapTradeId = b.SwapTradeId
		and a.HypoTradeId = b.HypoTradeId
	where b.AsOfDate = @T_CalypsoDate
	group by
	a.AsOfDate,
	a.PoolId
),

T1HedgesSummedByPool as
(
	select
	a.AsOfDate,
	a.PoolId,
	sum(b.SwapMTM) as SwapMTM,
	sum(b.SwapAccrued) as SwapAccrued,
	sum(b.HypoMTM) as HypoMTM,
	sum(b.HypoAccrued) as HypoAccrued
	from T1HedgePools as a
	inner join Hedges as b
		on a.SwapTradeId = b.SwapTradeId
		and a.HypoTradeId = b.HypoTradeId
	where b.AsOfDate = @T1_Calypso
	group by
	a.AsOfDate,
	a.PoolId
),

MinPkMapping as
(
	select
	min(a.PK_Xref_HedgeMapping) as PK_Xref_HedgeMapping,
	a.PoolId
	from Mappings as a
	group by
	a.PoolId
),

MinSwapTradeData as
(
	select distinct
	Mapping.PK_Xref_HedgeMapping,
	Mapping.SwapTradeID,
	Mapping.HypoTradeID,
	Mapping.HedgeId,
	Mapping.PoolId
	from Mappings as Mapping
	inner join MinPkMapping as MinPk
		on Mapping.PK_Xref_HedgeMapping = MinPk.PK_Xref_HedgeMapping
											

),

T1MinPkMapping as
(
	select
	min(a.PK_Xref_HedgeMapping) as PK_Xref_HedgeMapping,
	a.PoolId
	from T1Mappings as a
	group by
	a.PoolId
),

T1MinSwapTradeData as
(
	select
	Mapping.PK_Xref_HedgeMapping,
	Mapping.SwapTradeID,
	Mapping.HypoTradeID,
	Mapping.HedgeId,
	Mapping.PoolId
	from T1Mappings as Mapping
	inner join T1MinPkMapping as T1MinPk
		on Mapping.PK_Xref_HedgeMapping = T1MinPk.PK_Xref_HedgeMapping

),

MinSwapPk as
(
	select
	min(a.PK_CalypsoHedgeTrades) as PK_CalypsoHedgeTrades,
	a.PoolId
	from EnrichedHedges as a
	where a.AsOfDate = @T_CalypsoDate
	group by
	a.PoolId
),

MinSwapHedgeData as
(
	select distinct
	a.PK_CalypsoHedgeTrades,
	a.PoolId
	from EnrichedHedges as a
	inner join MinSwapPk as MinSwapPk
		on a.PK_CalypsoHedgeTrades = MinSwapPk.PK_CalypsoHedgeTrades
),

accret as--find securities that are mapped on T in the accretion file
(
	select
	accret.ProcessDate,
	accret.Ticket,
	accret.ToDate,
	accret.ConstantPrepaymentRate--added 08/27/2020
	from InputData.ip_CUSD_accret as accret with (NOLOCK)
	where accret.ProcessDate = @T_InTraderDate
),

amort as--find securities that are mapped on T in the amortization file
(
	select
	amort.ProcessDate,
	amort.Ticket,
	amort.ToDate,
	amort.ConstantPrepaymentRate--added 08/27/2020
	from InputData.ip_CUSD_amort as amort with (NOLOCK)
	where amort.ProcessDate = @T_InTraderDate
),


ToDates as --union of unamort and unaccret to get the todates needed for the yield calculations on day T
(
	select distinct
	ToDates.Ticket,
	ToDates.ToDate,
	ToDates.ConstantPrepaymentRate
	from		(select
				accret.Ticket,
				accret.ToDate,
				accret.ConstantPrepaymentRate
				from accret as accret

				union all

				select
				amort.Ticket,
				amort.ToDate,
				amort.ConstantPrepaymentRate
				from amort as amort) as ToDates
),


codes as --get a list of codes for coupon frequencies
(
	select
	Codes.Code,
	Codes.CodeValue
	from dbo.Xref_Codes as Codes with (NOLOCK)
	where Codes.CodeType = @CodeType
),

unamort as --get amortization info for tickets that were unwound for date T
(
	select
	amort.ProcessDate,
	amort.PK_ip_amort,
	amort.Ticket,
	amort.Unamortized
	from InputData.ip_amort as amort with (NOLOCK)
	where amort.ProcessDate = @T_InTraderDate
),

unaccret as --get accretion info for tickets that were unwound for date T
(
	select
	accret.ProcessDate,
	accret.PK_ip_accret,
	accret.Ticket,
	accret.Unaccreted
	from InputData.ip_accret as accret with (NOLOCK)
	where accret.ProcessDate = @T_InTraderDate
),

PoolMappingsEnriched as
(
	select
	a.PoolId,
	a.CurrentTicket,
	a.CurrentUnwindTicket,
	b.PK_ip_accret,
	b.Unaccreted,
	c.PK_ip_amort,
	c.Unamortized
	from PoolMappings as a
	left join unaccret as b
		on a.CurrentUnwindTicket = b.Ticket
	left join unamort as c
		on a.CurrentUnwindTicket = c.Ticket
),


PoolMappingsEnrichedFinal as
(
	select
	a.PoolId,
	a.CurrentTicket,
	d.CurrentUnwindTicket,
	d.PK_ip_accret,
	a.Unaccreted,
	d.PK_ip_amort,
	a.Unamortized
	from		(select
				a.PoolId,
				a.CurrentTicket,
				a.CurrentUnwindTicket,
				sum(a.Unaccreted) as Unaccreted,
				sum(a.Unamortized) as Unamortized
				from PoolMappingsEnriched as a
				group by
				a.PoolId,
				a.CurrentTicket,
				a.CurrentUnwindTicket) as a

	left join	(select
				b.PoolId,
				b.CurrentTicket,
				b.CurrentUnwindTicket,
				c.PK_ip_accret,
				c.PK_ip_amort
				from		(select
							b.PoolId,
							b.CurrentTicket,
							min(CurrentUnwindTicket) as CurrentUnwindTicket
							from PoolMappingsEnriched as b
							group by
							b.PoolId,
							b.CurrentTicket,
							b.CurrentUnwindTicket) as b
				left join	(select
							c.PoolId,
							c.CurrentTicket,
							c.CurrentUnwindTicket,
							c.PK_ip_accret,
							c.PK_ip_amort
							from PoolMappingsEnriched as c) as c
					on b.PoolId = c.PoolId
					and b.CurrentTicket = c.CurrentTicket
					and b.CurrentUnwindTicket = c.CurrentUnwindTicket) as d
		on a.PoolId = d.PoolId
		and a.CurrentTicket = d.CurrentTicket
		and a.CurrentUnwindTicket = d.CurrentUnwindTicket
),


SwapWeights as	--create a table of the sum of the total current face for all assets that are mapped to a particular swap/hypo hedge on T
				--this table will be used to divide the individual tickets current face by the sum of the all the tickets current face
(
	select
	Mappings.PoolId,
	sum(bndhold.CurrentFace) as TotalCurrentFace
	from PoolMappingsEnrichedFinal as Mappings
	inner join bndhold as bndhold
		on Mappings.CurrentTicket = bndhold.Ticket
	where bndhold.ProcessDate = @T_InTraderDate
	group by
	Mappings.PoolId
),

TData as
(
	select distinct
	b.PK_Xref_HedgeMapping,
	b.SwapTradeId,
	b.HypoTradeId,
	b.HedgeId,
	a.CurrentTicket,
	a.CurrentUnwindTicket,
	c.PK_ip_CUSD_holdings,
	c.Portfolio,
	c.SecurityId,
	c.SecurityType,
	c.Maturity,
	c.EstimatedMaturity,
	c.CallDate,
	c.SecurityRate,
	c.CurrentFace,
	c.BookValue,
	c.FairValue,
	c.BookYield,
	c.TaxEquivalentYield,
	d.PK_ip_CUSD_accrual,		
	d.DailyAccrual,
	d.LastInterestPaidDate,
	d.NextInterestPaidDate,	
	k.PK_CalypsoHedgeTrades,
	e.SwapMTM,
	e.SwapAccrued,
	e.HypoMTM,
	e.HypoAccrued,
	f.ToDate,
	g.CodeValue,
	h.TotalCurrentFace,
	a.PK_ip_amort,
	a.Unamortized,
	a.PK_ip_accret,
	a.Unaccreted,
	c.[Delay],
	f.ConstantPrepaymentRate,
	c.PurchasePrice
	from PoolMappingsEnrichedFinal as a
	left join MinSwapTradeData as b
		on a.PoolId = b.PoolId
	left join bndhold as c
		on a.CurrentTicket = c.Ticket
	left join bndAccru as d
		on a.CurrentTicket = d.Ticket
	left join THedgesSummedByPool as e
		on a.PoolId = e.PoolId
	left join ToDates as f
		on a.CurrentTicket = f.Ticket
	left join codes as g
		on c.InterestPaymentSchedule =g.Code
	left join SwapWeights as h
		on a.PoolId = h.PoolId
	left join MinSwapHedgeData as k
		on a.PoolId = k.PoolId
	where c.ProcessDate = @T_InTraderDate
	and d.ProcessDate = @T_InTraderDate

),

T1Data as
(
	select distinct
	b.PK_Xref_HedgeMapping,
	b.HedgeId,
	a.CurrentTicket,
	a.CurrentUnwindTicket,
	c.BookValue,
	c.FairValue,
	d.SwapMTM,
	d.SwapAccrued,
	d.HypoMTM,
	d.HypoAccrued
	from T1PoolMappings as a
	inner join T1MinSwapTradeData as b
		on a.PoolId = b.PoolId
	left join		(select
					c.Ticket,
					c.BookValue,
					c.FairValue
					from bndhold as c
					where c.ProcessDate = @T1_InTrader) as c
		on a.JoiningTicket = c.Ticket
	left join T1HedgesSummedByPool as d
		on a.PoolId = d.PoolId

)


	INSERT INTO ##AdjustedValues (
	AsOfDate,
	JobId,
	FK_ip_CUSD_accrual,
	FK_ip_CUSD_holdings,
	FK_ip_amort,
	FK_ip_accret,
	FK_Xref_HedgeMapping,
	FK_CalypsoHedgeTrades,
	SwapTradeId,
	HypoTradeId,
	HedgeId,
	Ticket,
	Portfolio,
	SecurityId,
	SecurityType,
	SecurityRate,
	CurrentFace,
	BookValue,
	FairValue,
	FairValueHedged,
	BookYield,		
	DailyAccrual,
	LastInterestPaidDate,
	NextInterestPaidDate,
	TaxEquivalentYield,
	ToDate,
	CouponFrequency,
	SwapWeight,
	TaxRate,	
	BookValueHedged,									
	UnrealizedPLHedged,	
	ShareholderEquityHedged,
	DeferredTaxHedged,
	InterestIncome,
	InterestIncomeHedged,
	HedgeIneffectiveness,
	IsAdjustedRecord,
	HasUnwoundSwap,
	[Delay],--added 08/27/2020
	ConstantPrepaymentRate,--added 08/27/2020
	MaturityDate,--added 08/27/2020
	PurchasePrice)--added 12/16/2020


	select
	@T_AsOfDate as AsOfDate,
	@JobId as JobId,
	T.PK_ip_CUSD_accrual as FK_ip_CUSD_accrual,
	T.PK_ip_CUSD_holdings as FK_ip_CUSD_holdings,
	T.PK_ip_amort as FK_ip_amort,
	T.PK_ip_accret as FK_ip_accret,
	T.PK_Xref_HedgeMapping as FK_Xref_HedgeMapping,
	T.PK_CalypsoHedgeTrades as FK_CalypsoHedgeTrades,
	T.SwapTradeId,
	T.HypoTradeId,
	T.HedgeId,
	T.CurrentTicket as Ticket,
	T.Portfolio,
	T.SecurityId,
	T.SecurityType,
	T.SecurityRate,
	T.CurrentFace,
	ISNULL(T.BookValue,0) as BookValue,
	ISNULL(T.FairValue,0) as FairValue,
	ISNULL(T.FairValue,0) as FairValueHedged,
	ISNULL(T.BookYield,0) as BookYield,
	ISNULL(T.DailyAccrual,0) as DailyAccrual,
	T.LastInterestPaidDate,
	T.NextInterestPaidDate,
	T.TaxEquivalentYield,
	CASE WHEN T.ToDate IS NOT NULL Then ToDate WHEN T.CallDate IS NOT NULL and T.CallDate > CAST(GETDATE() as DATE) Then T.CallDate WHEN EstimatedMaturity IS NOT NULL and T.EstimatedMaturity > CAST(GETDATE() as DATE) Then T.EstimatedMaturity Else T.Maturity end as ToDate,
	T.CodeValue as CouponFrequency,
	(T.CurrentFace / T.TotalCurrentFace) as SwapWeight,
	CASE When T.TaxEquivalentYield = 0 Then 1 Else (1-(T.BookYield/T.TaxEquivalentYield)) End as TaxRate,
	((ISNULL(T.BookValue,0) + ISNULL(TTotal.TotalUnamortized,0) - ISNULL(TTotal.TotalUnaccreted,0)) + (ISNULL(T.HypoMTM,0) * (T.CurrentFace / T.TotalCurrentFace))) as BookValueHedged,
	(ISNULL(T.FairValue, 0) - (ISNULL(T.BookValue, 0) + ISNULL(TTotal.TotalUnamortized,0) - ISNULL(TTotal.TotalUnaccreted,0) + (ISNULL(T.HypoMTM, 0) * (T.CurrentFace / T.TotalCurrentFace)))) as UnrealizedPLHedged,
	((ISNULL(T.FairValue, 0) - (ISNULL(T.BookValue, 0) + (ISNULL(T.HypoMTM, 0) * (T.CurrentFace / T.TotalCurrentFace)))) * @300EquityRate) as ShareholderEquityHedged,
	((ISNULL(T.FairValue, 0) - (ISNULL(T.BookValue, 0) + (ISNULL(T.HypoMTM, 0) * (T.CurrentFace / T.TotalCurrentFace)))) * @300TaxRate) as DeferredTaxHedged,
	(ISNULL(T.DailyAccrual, 0) + (ISNULL(T.BookValue, 0) - ISNULL(T1.BookValue, 0))) as InterestIncome,
	((ISNULL(T.DailyAccrual, 0) + (ISNULL(T.BookValue, 0) - ISNULL(T1.BookValue, 0))) + (((ISNULL(T.HypoMTM, T1.HypoMTM) - ISNULL(T1.HypoMTM, T.HypoMTM)) + (ISNULL(T.SwapMTM, T1.SwapMTM) - ISNULL(T1.SwapMTM, T.SwapMTM)) + (ISNULL(T.SwapAccrued, T1.SwapAccrued) - ISNULL(T1.SwapAccrued, T.SwapAccrued))) * (T.CurrentFace / T.TotalCurrentFace))) as InterestIncomeHedged,
	((ISNULL(T.SwapMTM, 0) + ISNULL(T.HypoMTM, 0) + ISNULL(T.SwapAccrued, 0))*(T.CurrentFace / T.TotalCurrentFace)) as HedgeIneffectiveness,
	@IsAdjustedRecord as IsAdjustedRecord,
	CASE When T.CurrentUnwindTicket IS NULL Then @IsNotUnwound Else @IsUnwound END as HasUnwoundSwap,
	T.[Delay],
	T.ConstantPrepaymentRate,
	T.Maturity as MaturityDate,
	T.PurchasePrice
	from TData as T
	LEFT JOIN T1Data as T1
	on T.PK_Xref_HedgeMapping = T1.PK_Xref_HedgeMapping
	AND T.CurrentTicket = T1.CurrentTicket
	AND T.CurrentUnwindTicket = T1.CurrentUnwindTicket
	INNER JOIN (SELECT CurrentTicket,
	SUM(Unamortized) as TotalUnamortized,
	SUM(Unaccreted) as TotalUnaccreted
	FROM TData
	GROUP BY CurrentTicket) TTotal
	on T.CurrentTicket = TTotal.CurrentTicket

		
			EXECUTE dbo.spUpdateBatchStatusId @JobId, 11 --adj vals minus yields inserted into adj vals temp table

			EXECUTE dbo.spUpdateBatchStatusId @JobId, 12 --adj yields processs starting


		END




END
GO

/*-----------------------------------------------------------------------------
  2 of 3 — ALTER VIEW      dbo.vw_curr_InTraderOps1       ->  ORIGINAL (pre-fix)
-----------------------------------------------------------------------------*/





ALTER view [dbo].[vw_curr_InTraderOps1] as
/***********************************************************
View Description:Will show the most current days records for the InTradersOps1 report
Used By: Hedge Accounting Batch

Created by: Spencer Gansluckner
Created when:  7/11/2019

Modifications:
Date			By						Reason/What changed
--------		-------------			-------------------
07/11/2019		Spencer Gansluckner		Creation
10/28/2019		Spencer Gansluckner		Added 2 new fields: BookValueAdjHedge & BookValueAdjUnwind per jira item HA-511
05/24/2024		Subham Maiti			Added valstotal change for multiple unwind
07/02/2024      Sushma Kusumba          Added IsSettled Flag as 'Y' for CUSD holdings to exclude Intrader intraday records 
*************************************************************/
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
and hold.IsSettled = 'Y'           --Added flag filter to exclude Intrader Intraday records
GO

/*-----------------------------------------------------------------------------
  3 of 3 — ALTER VIEW      dbo.vw_hist_InTraderOps1       ->  ORIGINAL (pre-fix)
-----------------------------------------------------------------------------*/


ALTER view [dbo].[vw_hist_InTraderOps1] as
/***********************************************************
View Description:Will show the most current days records for the InTradersOps1 report
Used By: Hedge Accounting Batch

Created by: Spencer Gansluckner
Created when:  7/11/2019

Modifications:
Date			By						Reason/What changed
--------		-------------			-------------------
07/11/2019		Spencer Gansluckner		Creation
10/28/2019		Spencer Gansluckner		Added 2 new fields: BookValueAdjHedge & BookValueAdjUnwind per jira item HA-511
05/24/2024		Subham Maiti			Added valstotal change for multiple unwind
07/02/2024      Sushma Kusumba          Added IsSettled Flag as 'Y' for CUSD holdings to exclude Intrader intraday records 
*************************************************************/
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
GO
