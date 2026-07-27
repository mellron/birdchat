/*=============================================================================
  INC30712391 — DEPLOYMENT SCRIPT  (Option C)
  Portfolio 100AUST hedge Book Value discrepancy — HAT (Hedge Accounting Tool)
  Prepared by: detolle (Doug Tolley), 2026-07-25

  WHAT THIS DEPLOYS (3 objects, in order):
    1. ALTER PROCEDURE dbo.spInsertValsToAdjValTemp   -- root fix: SwapWeight de-dup
    2. ALTER VIEW      dbo.vw_curr_InTraderOps1        -- collapse fan-out to 1 row/lot
    3. ALTER VIEW      dbo.vw_hist_InTraderOps1        -- collapse fan-out to 1 row/lot (read by Power BI)

  WHY:
    A new hedge on a lot that still carries prior-unwind amortization made HAT store
    TWO rows per lot. That doubled TotalCurrentFace in the SwapWeights CTE (SwapWeight
    1/18 instead of 1/9), so BookValueHedged absorbed only HALF the hedge — BookValue
    Adjustment understated by $358,835.58 on 9 lots of CUSIP 91282CAV3. Object #1 fixes
    the calculation. Objects #2/#3 collapse the two rows to one per lot so the Power BI
    IP Ops reports (which read vw_hist_InTraderOps1 and SUM in Power BI) cannot double
    the hedge — no Power BI change required.

  NOT IN THIS SCRIPT (by design):
    - vw_*_InTraderOps2 changes  -> not used by the reports; nothing reads those views.
    - Power BI report changes     -> not needed with Option C.
    - MRO / Call Reports          -> auto-corrected by #1 (they already de-dup).

  DATA REMEDIATION (separate step, run AFTER this deploys, only if historical
    restatement is wanted): reprocess the affected AsOfDates (7/22/2026 onward) via
    the CorrectionRun path so HedgeAccountingValues rebuilds with the corrected calc.
    Go-forward nightly runs are correct automatically after #1.

  ROLLBACK:
    Re-deploy the pre-change definitions of the same three objects from source
    control (dbo.spInsertValsToAdjValTemp, dbo.vw_curr_InTraderOps1,
    dbo.vw_hist_InTraderOps1). No data is modified by this script.

  POST-DEPLOY VALIDATION:
    See the commented query at the bottom (and INC30712391_report_replicas.sql).
=============================================================================*/


/*=============================================================================
  1 of 3 — ALTER PROCEDURE dbo.spInsertValsToAdjValTemp
  INC30712391: SwapWeights CTE now counts each lot's CurrentFace ONCE
  (SELECT DISTINCT PoolId, CurrentTicket) so SwapWeight = 1/9, not 1/18.
  Companion for the report doubling = the vw_*_InTraderOps1 de-dup in #2/#3
  (Option C). Deploy all three together.
=============================================================================*/
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


-- NOTE (INC30712391): This CTE is where the fan-out originates. When a lot has
-- more than one unwind record, the b->c join below re-expands to ONE ROW PER
-- PK_ip_accret / PK_ip_amort. That is intentional for the multiple-unwind
-- feature (each row carries its own FK for the report), but it means any
-- downstream aggregate over this set will double-count the lot unless it first
-- reduces to distinct lots. See the SwapWeights fix below.
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


-- =====================  INC30712391 FIX (detolle, 2026-07-24)  =====================
-- WHAT WAS WRONG:
--   The original source of this CTE was "from PoolMappingsEnrichedFinal as Mappings".
--   PoolMappingsEnrichedFinal has one row PER unwind record, so for a lot with 2
--   unwind records SUM(bndhold.CurrentFace) added that lot's CurrentFace TWICE.
--   TotalCurrentFace came out doubled -> SwapWeight halved (1/18 vs 1/9) ->
--   BookValueHedged (line ~751) and every (CurrentFace/TotalCurrentFace)-weighted
--   column picked up only half of HypoMTM. That is the $358,835.58 understatement.
--
-- WHAT CHANGED:
--   Source the sum from a DISTINCT set of (PoolId, CurrentTicket) so each lot's
--   CurrentFace is counted exactly once, regardless of how many unwind records it
--   has. TotalCurrentFace and SwapWeight are then correct.
--
-- COMPANION (Option C): the report doubling of BookValueAdjHedge is handled by the
--   vw_curr_InTraderOps1 / vw_hist_InTraderOps1 de-dup (deployed in this same script,
--   objects 2 & 3) — one row per lot. No Power BI change needed.
-- ==================================================================================
SwapWeights as	--create a table of the sum of the total current face for all assets that are mapped to a particular swap/hypo hedge on T
				--this table will be used to divide the individual tickets current face by the sum of the all the tickets current face
(
	select
	Mappings.PoolId,
	sum(bndhold.CurrentFace) as TotalCurrentFace
	from (select distinct		-- INC30712391 FIX: de-duplicate the fanned-out rows so each lot is counted once
			PoolId,
			CurrentTicket
			from PoolMappingsEnrichedFinal) as Mappings
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
	-- INC30712391: SwapWeight is now correct (1/9, not 1/18) because the SwapWeights
	-- CTE above no longer double-counts CurrentFace across fanned-out unwind rows.
	(T.CurrentFace / T.TotalCurrentFace) as SwapWeight,
	CASE When T.TaxEquivalentYield = 0 Then 1 Else (1-(T.BookYield/T.TaxEquivalentYield)) End as TaxRate,
	-- INC30712391: BookValueHedged now absorbs the FULL HypoMTM allocation for the lot
	-- (HypoMTM * correct SwapWeight) instead of only half. This is the value that was
	-- understated by $358,835.58 across the 9 affected lots. No change to the formula
	-- itself — it is corrected purely by the upstream SwapWeights fix.
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


/*=============================================================================
  2 of 3 — ALTER VIEW dbo.vw_curr_InTraderOps1
  INC30712391: collapse the multiple-unwind fan-out to ONE ROW PER TICKET so
  downstream Sum-based roll-ups (Power BI IP Ops 1 & 2) can't double the hedge.
  Take per-lot values ONCE (MAX — identical across the fan-out rows), SUM the
  per-record BookValueAdjUnwind. Base body unchanged inside the derived table.
=============================================================================*/
ALTER view [dbo].[vw_curr_InTraderOps1] as
SELECT
      Detail.AsOfDate
    , Detail.Group_IT
    , Detail.Intent_IT
    , Detail.Security_IT
    , Detail.Ticket_IT
    , MAX(Detail.BookValue_IT)        AS BookValue_IT
    , MAX(Detail.BookValueHedged)     AS BookValueHedged
    , MAX(Detail.BookValueAdjustment) AS BookValueAdjustment
    , MAX(Detail.BookValueAdjHedge)   AS BookValueAdjHedge      -- fan-out: take ONCE (identical per row)
    , SUM(Detail.BookValueAdjUnwind)  AS BookValueAdjUnwind     -- fan-out: SUM the per-record pieces
    , MAX(Detail.FairValue_IT)        AS FairValue_IT
    , MAX(Detail.UnrealizedPL_IT)     AS UnrealizedPL_IT
    , MAX(Detail.UnrealizedPLHedged)  AS UnrealizedPLHedged
FROM (
    -- ===== unchanged base body of dbo.vw_curr_InTraderOps1 =====
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
    and hold.IsSettled = 'Y'           --Added flag filter to exclude Intraday records
    -- ===== end base body =====
) AS Detail
GROUP BY
      Detail.AsOfDate
    , Detail.Group_IT
    , Detail.Intent_IT
    , Detail.Security_IT
    , Detail.Ticket_IT
GO


/*=============================================================================
  3 of 3 — ALTER VIEW dbo.vw_hist_InTraderOps1
  INC30712391: same fan-out collapse as #2, on the historical view.
  THIS is the view the Power BI IP Ops reports read (with a rolling-180-day
  date filter), so this is the one that removes the report doubling.
=============================================================================*/
ALTER view [dbo].[vw_hist_InTraderOps1] as
SELECT
      Detail.AsOfDate
    , Detail.Group_IT
    , Detail.Intent_IT
    , Detail.Security_IT
    , Detail.Ticket_IT
    , MAX(Detail.BookValue_IT)        AS BookValue_IT
    , MAX(Detail.BookValueHedged)     AS BookValueHedged
    , MAX(Detail.BookValueAdjustment) AS BookValueAdjustment
    , MAX(Detail.BookValueAdjHedge)   AS BookValueAdjHedge      -- fan-out: take ONCE (identical per row)
    , SUM(Detail.BookValueAdjUnwind)  AS BookValueAdjUnwind     -- fan-out: SUM the per-record pieces
    , MAX(Detail.FairValue_IT)        AS FairValue_IT
    , MAX(Detail.UnrealizedPL_IT)     AS UnrealizedPL_IT
    , MAX(Detail.UnrealizedPLHedged)  AS UnrealizedPLHedged
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


/*=============================================================================
  POST-DEPLOY VALIDATION (optional; read-only; edit the date if needed)
  Run after re-processing 7/22/2026 (or against any date that has fixed data).
  Expect: 9 rows, BookValueAdjHedge = -79,741.23 (once), and
          BookValueAdjHedge + BookValueAdjUnwind = BookValueAdjustment (~ -3,612,888.76).
=============================================================================*/
-- SELECT Ticket_IT, BookValueAdjustment, BookValueAdjHedge, BookValueAdjUnwind,
--        BookValueAdjHedge + BookValueAdjUnwind AS HedgePlusUnwind
-- FROM   dbo.vw_hist_InTraderOps1
-- WHERE  AsOfDate = '2026-07-22' AND Group_IT = '100AUST' AND Security_IT = '91282CAV3'
-- ORDER  BY Ticket_IT;
