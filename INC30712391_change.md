# INC30712391 — Emergency Change form (reference)
HAT (Hedge Accounting Tool) — Corporate Treasury. Deploy `INC30712391_DEPLOY.sql` (3 SQL objects).

## Header (already set on the form)
- **Planned start:** 07-29-2026 22:30:00 (US/Eastern)
- **Planned end:** 07-29-2026 23:55:00 (US/Eastern)
- **High Risk Appl CI Affected:** Yes
- **Has Verbal Approval Been Provided?:** Yes
- **Verbal Approver:** Glenn Thompson

## Environments
- **Production:** `VMCKSA69901M08X,4900` — database `HedgeAcctg` (target of this change)
- **UAT:** `VMCKSA69901M08U,49001` — database `HedgeAcctg` (where the fix was validated)

---

## Short Description
INC30712391 — Deploy HAT SQL fix for understated hedge book value (SwapWeight fan-out) affecting 100AUST IPOPS and RC-B/HC-B Call Reports

## Description
**1. Why (immediate + impact):** HAT understates the hedge-adjusted book value (`BookValueHedged`) for hedged U.S. Treasury lots in portfolio 100AUST. When a new hedge is placed on a security that still carries prior-unwind accretion, HAT stores two rows per lot, halving `SwapWeight` (1/18 vs 1/9), so only half the hedge is absorbed. This mis-states the RC-B/HC-B **Call Report** (regulatory reporting) figure on **every daily production run**; it is present on every business day back to before 6/1/2026 and spans the 6/30 quarter-end, and each additional run extends the mis-stated period — hence immediate correction. **No GL/financial exposure** (the GL is fed directly from Calypso; confirmed by the Controller); this is internal/regulatory reporting accuracy.

**2. Items changed / impacted:** 3 SQL objects in the HAT production database (HedgeAcctg): `ALTER PROC dbo.spInsertValsToAdjValTemp`, `ALTER VIEW dbo.vw_curr_InTraderOps1`, `ALTER VIEW dbo.vw_hist_InTraderOps1`. Application: **HAT (Hedge Accounting Tool)**, Corporate Treasury. Downstream reports affected: IPOPS and the RC-B/HC-B Call Report schedules (Power BI). Business lines: Corporate Treasury / Investment Portfolio and Call Report preparers. (Add the HAT DB CI to the Affected CI tab.)

## Justification
Stops the ongoing daily understatement of a regulatory Call Report figure and corrects the internal hedge-accounting reports. It is a prerequisite to remediating the affected historical periods. The change is a root-cause fix that corrects all affected pools/CUSIPs at once, and it has been validated end-to-end in UAT (restored from production) with business-line sign-off on the corrected Call Reports.

## Testing Results (dropdown)
Successful

## Testing Comments
Deployed and validated in **UAT (`VMCKSA69901M08U,49001`, database `HedgeAcctg`)**, restored from production. Confirmed stored `SwapWeight` corrected to 1/9 and `BookValueHedged` whole; the RC-B/HC-B U.S. Treasury line moved by exactly the expected hedge amount and tied out penny-accurate to the recomputed value. Business line (Call Report preparer) signed off that RCB and HCB are correct.

## Implementation plan
Executed by the Corporate Treasury implementer against the **HAT production server `VMCKSA69901M08X,4900`, database `HedgeAcctg`**. Run `INC30712391_DEPLOY.sql` — three `ALTER` statements in order: (1) `spInsertValsToAdjValTemp`, (2) `vw_curr_InTraderOps1`, (3) `vw_hist_InTraderOps1`. SQL objects only — no schema, table, or data changes in this step. Estimated < 5 minutes. Historical data reprocessing and report refresh are handled separately under the emergency ID.

## Validation plan
On **production (`VMCKSA69901M08X,4900`, database `HedgeAcctg`)** after deploy, run `INC30712391_scan_other_dates.sql` against the next processed AsOfDate — success = **zero `UNDERSTATED` pools** (each hedge pool's distinct-lot `SwapWeight` sums to 1.0). Confirm all three objects altered cleanly (updated `modify_date`, no errors). Validation performed by the Corporate Treasury implementer; business confirmation of RCB/HCB from the Call Report preparer.

## Backout Complexity (dropdown)
Low

## Backout comments
On **production (`VMCKSA69901M08X,4900`, database `HedgeAcctg`)**, execute `INC30712391_rollback.sql` — `ALTER`s the three objects back to their pre-change definitions. Confirm with `INC30712391_rollback_verify.sql` (all three must report `REVERTED (ok)`). SQL objects only, ~2 minutes, fully reversible. Any data re-runs are handled under the emergency ID.

---
## Referenced scripts (in the incident folder and BirdChat repo)
- `INC30712391_DEPLOY.sql` — the change (3 ALTERs)
- `INC30712391_rollback.sql` + `INC30712391_rollback_verify.sql` — back-out + confirmation
- `INC30712391_scan_other_dates.sql` — post-deploy validation (no UNDERSTATED)
- `INC30712391_rebuild_job1794.sql` / `INC30712391_rerun_CallRpt_job1794.sql` — data remediation (under emergency ID)
- `INC30712391_emergency_change_justification.md` — full justification
