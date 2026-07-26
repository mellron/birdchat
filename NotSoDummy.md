# NotSoDummy.md — the problem in financial terms

*One level up from `Dummy.md`. Written for a Treasury / accounting / finance reader who knows
fair-value hedge accounting but isn't in the SQL. No pizza this time — real terms and real
dollars.*

---

## The 30-second version

A pool of hedged lots had its **hedge Mark-to-Market allocated across twice as many "shares" as
actually existed**, so each lot absorbed only **half** of the hedge it was entitled to. The
security-level **Book Value Adjustment (BVA)** came in at **−$358,835.58** when the correct
figure from Calypso was **−$717,671.10** — an **understatement of exactly $358,835.58 (half)**.

The **General Ledger was never wrong** — the full amount posted to the books. This is an
**internal hedge-reporting/reconciliation defect**, not a financial-statement exposure.

---

## The terms you need (quick refresher)

| Term | What it means here |
|---|---|
| **Lot** | One purchase tranche of a security in the portfolio. Security **91282CAV3** in portfolio **100AUST** is held as **9 lots**. |
| **Current Face** | The par/face amount of a lot. Used to weight how the hedge is spread across lots. |
| **Swap Weight** | A lot's **share of the pool** = `lot Current Face ÷ total Current Face of the pool`. With 9 equal lots each should be **1/9 = 0.1111**. |
| **Hypothetical MTM** | The mark-to-market of the hypothetical derivative from Calypso — the total dollar hedge to be allocated across the lots. Here: **−$717,671.10**. |
| **Book Value Hedged** | Book Value **+** each lot's allocated slice of the hedge. |
| **Book Value Adjustment (BVA)** | `Book Value Hedged − Book Value`. It has **two components**: a **Hedge** piece (`BookValueAdjHedge`) and an **Unwind** piece (`BookValueAdjUnwind`). |

---

## What actually got duplicated

Nine of these lots each carried **two unwind accretion records** — leftover amortization tails
from a **prior hedge unwind** on the same lot. In the hedge-accounting data, the system stores
**one row per unwind accretion record**, so each lot was written as **two identical rows** that
differ only in the unwind amount:

```
              stored rows      Current Face counted
 Reality:      9 lots               9 × face
 System saw:   9 × 2 = 18 rows      18 × face   ← doubled
```

This is the **fan-out**. Nothing about the position doubled — only the **row count** did,
because the position was fanned out one row per unwind accretion record.

---

## How the duplication turned into a dollar error

The allocation routine computes each lot's Swap Weight as
`lot Current Face ÷ TotalCurrentFace`. It built `TotalCurrentFace` by **summing Current Face over
the stored rows** — and there were **18** of them, not 9. So:

| | Correct | What HAT computed |
|---|---|---|
| Rows in the pool | 9 | 18 (fanned out) |
| Total Current Face | 9 × face | **18 × face (2×)** |
| Swap Weight per lot | 1/9 = **0.1111** | 1/18 = **0.0556** |
| Hedge each lot absorbs | full slice | **half slice** |
| Security BVA (hedge) | **−$717,671.10** | **−$358,835.58** |

Because the denominator doubled, every Swap Weight halved, so `Book Value Hedged` only picked up
**half** the hedge. The security's Book Value Adjustment came in **exactly half** — short by
**$358,835.58**.

---

## Why the summary report still looked right (the part that hid it)

The portfolio summary report (IP Ops 2 / Power BI) rebuilds the hedge total by **summing
`BookValueAdjHedge` across the rows**. But each lot was present as **two rows**, each holding the
**halved** hedge value. So the report computed:

```
   half + half  =  whole   ✔ (looks correct)
```

The **two errors cancelled on the hedge column** — the halved per-row value multiplied by the
doubled row count landed back on the right number. That's why the hedge figure looked fine and it
went unnoticed. It only surfaced when a **different total** — one that doesn't get that lucky
cancellation — failed to tie out between IPOPS2 and IPOPS3.

---

## What tied out vs. what didn't

- ✅ **General Ledger** — received the **full −$717,671.10**. Confirmed correct by the Controller
  (via Diana Yang). No financial exposure.
- ✅ **Summary hedge column (IP Ops 2)** — looked right by coincidence (the half-×-double
  cancellation above).
- ❌ **The stored per-lot values** — every affected lot understated its hedge by half.
- ❌ **IPOPS2 vs IPOPS3 reconciliation** — the internal reports don't tie out, which is what
  exposed the defect.

---

## The fix (in financial terms)

Two coordinated changes — you need **both**:

1. **Allocation routine (`spInsertValsToAdjValTemp`).** Compute `TotalCurrentFace` from the
   **distinct lots**, not the fanned-out rows. Swap Weight returns to **1/9 = 0.1111**, each lot
   absorbs its **full** hedge slice, and the stored BVA is correct at **−$717,671.10**.

2. **Reporting views (`vw_curr_/vw_hist_InTraderOps1`).** De-duplicate the fan-out so each lot
   presents as **one row** — take the hedge component **once** (`MAX`) and **sum only the unwind
   pieces**.
   *Why both:* once step 1 makes each row hold the **full** hedge, the summary report that
   **sums** across the two rows would now show **whole + whole = double**. Step 2 removes the
   double-count so the report still ties.

Net: the ledger stays correct (as it always was), the stored per-lot values are correct, and the
internal reports reconcile.

---

## Scope & materiality

- **Trigger:** a **new hedge landing on a lot that still carries prior unwind accretion records**
  (the fan-out condition). Rare, but not unique to this one security.
- **Confirmed impact:** the **9 lots of 91282CAV3 in 100AUST**, security BVA understated by
  **$358,835.58** internally.
- **Blast-radius check:** the regression script scans the whole portfolio for any other
  fan-out lot with a live hedge (Section B) so we can confirm the full population before deploy.
- **Financial-statement exposure:** **none** — GL was always whole. Classified as an internal
  hedge-reporting / reconciliation defect.

---

*TL;DR: A prior-unwind fan-out doubled the Current Face denominator, halving every Swap Weight, so
each lot booked half its hedge — BVA −$358,835.58 vs. the correct −$717,671.10. The summary report
hid it because summing two half-rows returned the right total. The GL was always correct. Fix the
allocation to weight on distinct lots, and de-dup the reporting view so it stops double-counting.*
