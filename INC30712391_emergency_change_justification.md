# Emergency Change Justification — INC30712391
**Application:** HAT (Hedge Accounting Tool) — Corporate Treasury
**Change:** Deploy `INC30712391_DEPLOY.sql` (3 SQL objects, ALTER) to Production
**Related incident:** INC30712391

## Summary
A calculation defect in HAT understates the hedge-adjusted book value (`BookValueHedged`)
for hedged U.S. Treasury lots in portfolio **100AUST**. The understatement flows into the
internal IP Ops (IPOPS) reports and the **RC-B / HC-B Call Report** schedules produced by
HAT. This change corrects the root-cause calculation and the two reporting views that read it.

## Why this is an emergency
- The defect **actively mis-states a regulatory Call Report figure on every daily production
  run**, and has done so continuously — confirmed present on **every business day back to at
  least 6/1/2026**, i.e. it **predates** the hedge that first surfaced it and **spans the 6/30
  quarter-end** used for the Q2 FFIEC Call Report.
- Each additional daily run **extends the mis-stated period**. Deploying the fix **stops the
  ongoing mis-statement go-forward** and is a **prerequisite** to remediating the affected
  historical dates.
- The correction has already been **validated end-to-end in UAT against production-restored
  data, with business-line (Call Report preparer) sign-off** on RCB and HCB.
- Expedited handling is warranted to halt the continuing daily understatement of a regulatory
  report and to enable the historical remediation/restatement assessment.

## Problem & root cause
When a new hedge is placed on a security that still carries prior-unwind accretion, HAT stores
**two rows per lot** (a fan-out on the unwind-accretion key). The `SwapWeights` CTE in
`spInsertValsToAdjValTemp` then sums each lot's face **twice**, so `SwapWeight` is halved
(e.g. 1/18 instead of 1/9). As a result `BookValueHedged` absorbs only **half** the hedge —
the hedge-basis adjustment is understated.

## Scope & impact
- **Portfolio 100AUST**, ~**11 hedge pools across 4 U.S. Treasuries** (91282CAV3, 91282CBP5,
  91282CDL2, 91282CDP3), on every business day.
- **Present since before 6/1/2026** (start date under confirmation via a back-scan); the 7/21
  hedge that surfaced the issue added 2 of the 11 pools — the other 9 were already affected.
- **No GL / financial exposure:** the General Ledger is fed directly from Calypso (the full
  hedge value), independently confirmed by the Controller (via Diana Yang, 2026-07-24). This is
  an internal- and regulatory-**reporting-accuracy** defect, not a financial mis-statement.
- Historical data correction and any restatement of affected periods (incl. the 6/30
  quarter-end) are being assessed and handled **separately** (see Data Remediation).

## Change description (3 objects, ALTER — `INC30712391_DEPLOY.sql`)
1. `ALTER PROCEDURE dbo.spInsertValsToAdjValTemp` — root fix: count each lot's face once
   (SwapWeights CTE de-duplicates the fan-out), so `SwapWeight`/`BookValueHedged` are correct.
2. `ALTER VIEW dbo.vw_curr_InTraderOps1` — collapse the fan-out to one row per lot.
3. `ALTER VIEW dbo.vw_hist_InTraderOps1` — same (this view is read by the Power BI reports).

Corrects all affected pools/CUSIPs at once (root-cause fix, not per-hedge). No Power BI change
required. MRO and the Call Report procs auto-correct (they already de-duplicate).

## Testing / validation
- Deployed to UAT (restored from production); rebuilt the affected data and re-ran the Call
  Report procs. Verified stored `SwapWeight` corrected to 1/9 and `BookValueHedged` whole.
- Confirmed penny-accurate at the report layer: the affected RC-B / HC-B U.S. Treasury line
  moved by exactly the expected hedge amount, matching the recomputed correct value.
- **Business line (Call Report preparer) signed off** that RCB and HCB are now correct.

## Risk assessment — LOW
- 3 stored-object `ALTER`s; no schema/table changes; no data change in this step.
- Validated end-to-end in UAT against production-restored data with business sign-off.
- Fully reversible via the back-out script below.

## Back-out plan
- Execute **`INC30712391_rollback.sql`** — reverts all 3 objects to their pre-change
  definitions via `ALTER`.
- Confirm with **`INC30712391_rollback_verify.sql`** — all 3 objects must report
  `REVERTED (ok)`.
- SQL objects only; any data re-runs handled under the emergency ID.

## Post-implementation verification
- Run **`INC30712391_scan_other_dates.sql`** after the next production batch: the newly
  processed date(s) must show **no `UNDERSTATED` pools** (distinct-lot `SwapWeight` sums to
  1.0), confirming the fix is effective go-forward.

## Data remediation (separate, under emergency ID — not part of this code change)
Reprocess the affected historical AsOfDates so stored `HedgeAccountingValues` and the
`CallReport_RCB/HCB` tables are rebuilt with the corrected calculation, then refresh the
affected Power BI datasets (IPOPS, RCB, HCB — refreshed individually). Scope/period and any
restatement to be confirmed from the back-scan and the controller assessment.
