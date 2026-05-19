# INC30522392 — Investigation Status

**Last updated:** 2026-05-19 (revised after view inspection)
**Severity:** P4
**Status:** Root cause identified — view-level fix required
**Direction:** Single-line change to `dbo.vwPledgeTicketDtl`, then re-run recon to confirm

---

## TL;DR

Recon on 5/18 showed CPMS_NMO $16.2M higher than Intrader_NMO for CUSIP **3133889F9** (FHLB Stock – San Francisco), ticket **867004812**. The underlying data is correct:

- `dbo.TicketHolding` for ticket 867004812 has both location rows: FHL `-$16,200,000` and HSF `+$41,850,000`, net = $25,650,000 ✓
- CPMS Legacy reads this directly → shows correct net
- CPMS Web reads through `dbo.vwPledgeTicketDtl` → **drops the FHL row** due to a `TicketDtlAmt > 0` filter → shows only $41,850,000

This is a **latent view bug** that's invisible until a ticket first has a negative location holding. The 5/15 DEL booked the contra leg at FHL, and that's when the over-reporting started.

---

## Root cause

In `dbo.vwPledgeTicketDtl`, the `Unpledged_Used_Pct` CTE computes `TicketDtlAmt` from `TicketHolding.Amt` (which can legitimately be negative for contra/DEL location legs). The `All_Tickets` CTE then filters:

```sql
-- vwPledgeTicketDtl, All_Tickets CTE (lines 109 and 119 of view body)
WHERE [Percentage] > 0  AND TicketDtlAmt > 0
```

`TicketDtlAmt > 0` silently drops negative location holdings:
- FHL row: `TicketDtlAmt = -16,200,000` → filtered out
- HSF row: `TicketDtlAmt = +41,850,000` → included

The view then returns only the HSF row, marked as 100% of position. Both the CPMS Web Holdings search and downstream recon totals that use this view (via `dbo.GetCollateralAvailabilitySummary`) inherit the over-statement.

---

## Smoking-gun evidence (`testresults.txt`, Query 4)

```
Source                   LocationId  Amt
-----------------------  ----------  ------------
vwPledgeTicketDtl        HSF         41,850,000.00     ← FHL row missing
TicketHolding (FHL/HSF)  FHL        -16,200,000.00
TicketHolding (FHL/HSF)  HSF         41,850,000.00
```

`TicketHolding` is correct. The view drops the FHL row.

---

## Timeline

| When (CT) | Event |
|---|---|
| 2026-05-15 | Position movement in Intrader: `-$16,200,000` DEL from FHL, ticket 867104401, as-of/settle 5/15 |
| 2026-05-18 | Intrader sends 5/18 holdings + SKHoldLoc files (both contain the FHL line — verified) |
| 2026-05-19 02:30:03 | SSIS load runs successfully; FHL row `-$16,200,000` inserted into `dbo.TicketHolding` for ProcessDate 5/18 |
| 2026-05-19 07:00 | Corinne O'Neil reports $16.2M difference. Difference is real because the Web/recon view filters out the FHL row |
| 2026-05-19 10:03 | INC30522392 opened by Kurt Nelson |

---

## Why CPMS Legacy is correct but CPMS Web is wrong

| App | Reads from | FHL row visible? | Result |
|---|---|---|---|
| CPMS Legacy (WinForms) | `tblHolding` / `TicketHolding` directly | Yes | Net $25,650,000 ✓ |
| CPMS Web | `dbo.vwPledgeTicketDtl` (via `dbo.GetCollateralAvailabilitySummary`) | No (filtered) | $41,850,000 ✗ |

Both apps share the same database. The discrepancy is in the Web's view layer, not in any sync between systems.

---

## Earlier hypothesis (DISCARDED)

The initial investigation theorized a **recon-snapshot-timing artifact** — that recon ran before the 02:30 SSIS load landed the FHL row. That hypothesis is **wrong**:
- The FHL row WAS in `TicketHolding` by 02:30 (confirmed)
- The view drops it anyway because of the `TicketDtlAmt > 0` filter
- An overnight rerun changes nothing

---

## Fix options

### Option 2 (recommended): minimal view change

In `dbo.vwPledgeTicketDtl`, change line 119 of view body (the `Unpledged` branch of `All_Tickets` CTE):

```sql
-- Before
WHERE [Percentage] > 0  AND TicketDtlAmt > 0
-- After
WHERE [Percentage] > 0  AND TicketDtlAmt <> 0
```

Preserves the original intent (drop empty/zero rows) while allowing negative location amounts through. Smallest possible diff; least risk to other view consumers.

### Option 1: drop the filter entirely on the Unpledged branch

Removes `AND TicketDtlAmt > 0` from line 119. Slightly broader; would include zero-amount rows too.

### Option 3 (not recommended): leave view alone, fix recon source

Change the recon to read `TicketHolding` directly instead of `vwPledgeTicketDtl`. Fixes the recon but leaves the Web UI displaying the wrong number — would not satisfy stakeholders.

---

## Recommended close-out

1. **Audit for other affected tickets.** Run:
   ```sql
   SELECT th.Ticket, sa.SfkpId, th.Amt, th.ProcessDate
   FROM dbo.TicketHolding th
   JOIN dbo.tblSfkpAcct sa ON sa.SfkpAcctID = th.SfkpAcctID
   WHERE th.Amt < 0
   ORDER BY th.ProcessDate DESC, th.Ticket, sa.SfkpId;
   ```
   Any other ticket with `Amt < 0` is also being hidden from the Web/recon.

2. **Confirm with CPMS application team** that negative location amounts are intentional (contra positions from DEL movements at specific safekeepers) and not data corruption.

3. **Apply view fix in dev**, retest:
   - Web UI search by Ticket 867004812 should show both FHL and HSF rows (or appropriate net)
   - Recon should show $0 difference for 5/18

4. **Promote via change control**, then re-run 5/18 recon to confirm.

5. **Document the filter pattern** in the CPMS view-design guidelines so future views don't reintroduce the same assumption.

---

## What this is NOT

- **Not** a missing Intrader source file (both 5/18 files are intact and contain the FHL row)
- **Not** an SSIS load failure (`c_sql_trs_d_cpms_loadholdings` ran successfully)
- **Not** a NULL-SfkpAcctID MERGE failure (all 21 SK codes resolved OK)
- **Not** a recon-snapshot-timing artifact (initial hypothesis — discarded)
- **Not** a Legacy → Web sync gap (both apps share the same database)

---

## Artifacts in this directory

| File | Purpose |
|---|---|
| `INC30522392_overview.md` | Original Incident Assistant generated overview |
| `CPMS_Intrader_Difference_2026-05-18.md` | Corinne's 5/19 email reproduction + image transcripts |
| `itsendsys.ip_CUSD_holdings.txt` | Intrader holdings flat file for ProcessDate 5/18 |
| `skholdloc.txt` | Intrader SKHoldLoc flat file for ProcessDate 5/18 — contains the FHL row |
| `PXL_20260519_211235578.jpg` | CPMS Web search screenshot showing only HSF $41,850,000 |
| `testresults.txt` | SQL results — view definition, dependency list, side-by-side comparison |
| `INC30522392_status.md` | This file — current investigation status |

---

## Related references

- Web SP entry point: `cpmsdatabase.sql:5592` — `dbo.GetCollateralAvailabilitySummary`
- View body (filter at lines 109 and 119): see `testresults.txt` Query 1
- Runbook for unrelated NULL-SfkpAcctID failures: `cpms_legacy/Incident/IncidentRunbook.md`
- CPMS schema reference + direct-fix precedent (`fix_tickets_36179WZB7.sql` pattern): `cpms_legacy/fixCPMSTicket.md`
