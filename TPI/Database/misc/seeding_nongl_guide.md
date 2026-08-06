# Seeding NonBankGL test data in UAT (for the Workday GL SSIS package)

How to get NonBankGL transactions into UAT that survive the whole TPI chain and
land in `OGLTransactions`, so `TPIGLUpload_Workday.dtsx` has real records to push
to Workday.

Companion script: [`Seed_NonBankGL_UAT.sql`](Seed_NonBankGL_UAT.sql) — this guide
is the narrative; the script is the thing you run.

**Scope:** UAT only. The script writes data and is not safe to run in production.

---

## The chain, and what each hop demands

```
Non_Bank_GL.dbo.tblDueFromAcctg                 seed here
        │                                        needs: TranID, numeric Bank/Account/Center,
        │                                               DR_CR_Ind, EffectiveDate = midnight
        ▼
   vMoneyTransfer_tblDueFromAcctg                unfiltered pass-through view
        │                                        (no Posted filter, no date filter)
        ▼
   GL Upload screen · "Available For Upload"     needs: ApproverDate set, Account <> '0000000',
        │                                               EffectiveDate <= posting date
        ▼  [Proceed]
   TPI.dbo.tblPrepareAcctg                       grouped + summed; TranCode derived HERE
        │
        ▼  [Complete Upload]
   TPI.dbo.tblMainData                           usp_MoveData_tblMainData
        │
        ▼  approve, then mark Send_A000
   TPI.dbo.tblMainData (Send_A000 = 1)
        │
        ▼  EXEC GetGLData
   TPI.dbo.OGLTransactions                       needs: TranCode in ('01','02')
        │                                               AND a LGLTraceNumber row
        ▼
   EXEC GetExtractRecordsWorkdayAPIGL            categories resolved from
        │                                        GLAccountCategoryMapping
        ▼
   TPIGLUpload_Workday.dtsx  →  Workday REST API
```

Every hop is a filter. A row that fails any one of them disappears without an
error message anywhere.

---

## Three traps that produce zero rows and no error

### 1. The posting date must be midnight, and you must reach GL Upload the right way

`GetGLData` only pulls current-day entries:

```sql
WHERE TranCode in ('01','02') AND Send_A000 = 1
```

TPI derives that TranCode in C# (`vNonBankGL_DuefromAcctgDto.TranCode`) with an
**exact** DateTime comparison, `EffectiveDate.Equals(PostingDate)`:

| Condition | TranCode | Reaches Workday? |
|---|---|---|
| `EffectiveDate` == posting date | `01` debit / `02` credit | yes |
| anything else (past dated) | `21` / `22` | **no** |

So two things have to line up:

- The seed writes `EffectiveDate` at **midnight** (the script does this).
- You must open GL Upload via **GL Main → pick the posting date → "Create GL"**.
  That button passes the selected date, which is always midnight.

  Typing `/GLUpload` directly is the failure mode: with no id the controller
  defaults the posting date to `DateTime.Now` **including the time of day**, which
  can never equal a midnight `EffectiveDate`. Every row silently becomes `21`/`22`,
  the screen still shows counts, the upload still "succeeds", and `GetGLData`
  returns nothing.

### 2. `LGLTraceNumber` must have exactly one row

`GetGLData` inner-joins it:

```sql
FROM tblMainData JOIN LGLTraceNumber t on tblMainData.ApplicationName = t.ApplicationName
```

| Rows for `'NonBankGL Daily Acctg'` | Result |
|---|---|
| 0 | zero transactions, no error |
| 1 | correct |
| 2+ | **every transaction duplicated** |

Preflight 0a in the script checks this and prints the INSERT if it's missing.

### 3. Give every pair a distinct amount

All NonBankGL rows share the single trace number from `LGLTraceNumber`. The
category carry-over partitions by `(Trace_Number, Transaction_Amount)`, so with one
trace number the pairing is effectively **by amount alone**. Two different pairs
with the same amount land in one partition and cross-contaminate each other's
categories. The script assigns a distinct amount per pair and section 2 has a
query that flags any collision.

---

## What the seed data looks like, and why

Each seeded transaction is a balanced pair sharing one `TranID`:

| Leg | Account | In `GLAccountCategoryMapping`? | Purpose |
|---|---|---|---|
| Debit | pulled live from the mapping table | **yes** | carries a real Spend/Revenue category |
| Credit | `@OffsetAccount` | **no** | starts blank, must *inherit* the category |

That is the case your window function exists to handle. If both legs were mapped,
the carry-over logic would never be exercised and the test would prove nothing.
The script refuses to run if `@OffsetAccount` turns out to be mapped.

Accounts are selected from `GLAccountCategoryMapping` filtered to **7 characters,
all numeric, with a non-blank Spend or Revenue category** — because the extract
matches on `SUBSTRING(Account_Number, 8, 7)`, so only 7-character numeric mappings
can ever match.

---

## Procedure

### Step 0 — Preflight

Run section 0 of the script. All four checks must pass:

| Check | Must show |
|---|---|
| 0a `LGLTraceNumber` | exactly 1 row for `NonBankGL Daily Acctg` |
| 0b usable mappings | at least 3 (7-digit numeric with a category) |
| 0c TPI working tables | `tblMainData` = 0 rows, or finish the run in flight first |
| 0d feed table | tells you what's already sitting there |

If 0b returns fewer than 3, stop — that is its own finding. It would mean no real
transaction could resolve a category either, and the accounts are probably stored
padded (14 chars) rather than as the 7 the extract looks for.

You need the **DPGTTTPIUpload** role for GL Main / GL Upload / Release, and
**DPGTTTPIApprover** or **DPGTTTPIUploadApprover** to approve.

### Step 1 — Seed

Run section 1. Adjust at the top if you want:

```sql
DECLARE @PostingDate     DATE = CAST(GETDATE() AS DATE);  -- the date you'll pick on GL Main
DECLARE @ApprovedPairs   INT  = 4;   -- -> "Available For Upload"
DECLARE @UnapprovedPairs INT  = 2;   -- -> "Not Approved"
```

`@PostingDate` must match the date you select on GL Main. Pick a **weekday** — the
dropdown only offers the last 3 weekdays.

### Step 2 — Verify the seed

Run section 2. With the defaults you should see:

| Bucket | Screen count (distinct TranID) | Rows |
|---|---|---|
| Not Approved | 2 | 4 |
| Available For Upload | 4 | 8 |

The screen counts distinct `TranID` and each pair shares one, so the count is half
the row count. The balance check must show `OutOfBalance = 0` for every TranID, and
the amount-collision query must return **no rows**.

### Step 3 — Load it into TPI through the screens

1. **GL Main** → select your posting date in the dropdown.
2. Click **Create GL** → the GL Upload screen. NonBankGL should now show your
   numbers in *Not Approved* and *Available For Upload*.
3. Tick **Check to Select** on the NonBankGL row → **Proceed**.
   Only the *Available For Upload* rows are pulled; *Not Approved* rows stay behind.

Now check the earliest place trap 1 shows up — **before** going any further:

```sql
SELECT TranCode, COUNT(*) AS Rows, SUM(TranAmount) AS Amount
FROM TPI.dbo.tblPrepareAcctg
WHERE ApplicationName = 'NonBankGL Daily Acctg'
GROUP BY TranCode;
```

`01`/`02` means you're good. **`21`/`22` means stop** — you came in with a
time-of-day posting date. Clear the run (section 4) and re-enter via GL Main.

4. **GL Main → Complete Upload** → moves the rows into `tblMainData`.
5. **Change Upload Data** → approve the entries, then mark **Send to A000** on each.
   An entry must be approved before it can be marked — the service rejects it
   otherwise.

To skip the clicking on subsequent iterations, use section 3 of the script (sets
`Approved` and `Send_A000` directly). Do the real screens at least once first —
the shortcut proves your package, not the application.

### Step 4 — Confirm what the package will consume

```sql
USE TPI;
EXEC dbo.GetGLData;
SELECT * FROM dbo.OGLTransactions;          -- should hold your rows
EXEC dbo.GetExtractRecordsWorkdayAPIGL;     -- what the SSIS package reads
```

In the final result set, check that **both** legs of each pair carry a non-blank
`SpendCategoryID` / `RevenueCategoryID`. The credit leg (offset account) proving
non-blank is the whole point — it means the carry-over worked.

Then run the package.

---

## Troubleshooting

| Symptom | Cause | Fix |
|---|---|---|
| Screen shows 0 everywhere | `tblDueFromAcctg` empty, or seeded rows have `Account = '0000000'` / a future `EffectiveDate` (both land in *Future Dated*) | re-run section 2; check the bucket rules |
| Rows exist but counts show 0 | `TranID` is NULL — the counts are `COUNT(DISTINCT TranID)` | set a TranID on every row |
| `tblPrepareAcctg` shows TranCode `21`/`22` | entered GL Upload with a time-of-day posting date | trap 1 — re-enter via GL Main → Create GL |
| Proceed throws | non-numeric `Bank`, `Account` or `Center` — the mapper runs `decimal.Parse` on all three | make them numeric strings |
| Proceed throws NullReferenceException | `DR_CR_Ind` is NULL — the TranCode getter calls `.Equals("D")` on it | set `'D'` or `'C'` |
| Complete Upload says "already been run" | `tblMainData` still holds a previous run | finish or clear it (section 4) |
| Rounding message on Proceed | debits ≠ credits for the application | seed balanced pairs; note `getconfigvalue` reads `tblAppConfig` with `Environment = 'Development'` **hardcoded**, so `Round_Diff_8` / `Round_Diff_non8` must exist under that environment name even in UAT |
| `GetGLData` returns nothing | TranCode not `01`/`02`, `Send_A000` not 1, or no `LGLTraceNumber` row | traps 1 and 2 |
| Every transaction appears twice | two `LGLTraceNumber` rows for the application | trap 2 |
| Categories blank on both legs | debit account isn't in `GLAccountCategoryMapping`, or the mapping isn't 7-char numeric | preflight 0b |
| Categories blank on the credit leg only | the carry-over didn't fire — check the amounts match exactly between the two legs | trap 3 |
| Two pairs swapped categories | two pairs share an amount | trap 3 — distinct amounts |

---

## Re-running and cleanup

Section 4 removes the seed:

```sql
USE [Non_Bank_GL];
DELETE FROM dbo.tblDueFromAcctg WHERE UserID = 'TSTSEED';
```

Everything the script inserts is tagged `UserID = 'TSTSEED'` / `BatchNumber = '999'`,
so cleanup never touches real rows. The TPI-side statements
(`tblPrepareAcctg`, `tblMainData`) are left commented out with SELECTs above them —
those tables hold other source systems' entries too, so look before deleting.

One thing the seed deliberately does **not** use: `dbo.SendGLAccounting`, the proc
that normally moves rows from `tblAccounting` into `tblDueFromAcctg`. It is wrapped
in `IF (SELECT COUNT(*) FROM tblDueFromAcctg WHERE ApproverDate IS NOT NULL) = 0`,
so it silently does nothing whenever approved rows are already waiting — and when
it does run it deletes all of `tblDueFromAcctg` and empties `tblAccounting`. Seeding
the target table directly avoids both surprises. (Its sibling `SendAccounting` does
`insert into tblDueFromAcctg select * from tblAccounting` across tables with
different column counts, so that statement cannot succeed as written — treat it as
dead legacy.)

---

## Object reference

| Object | Where | Role |
|---|---|---|
| `tblDueFromAcctg` | `Non_Bank_GL` | the feed table you seed |
| `vMoneyTransfer_tblDueFromAcctg` | `Non_Bank_GL` | unfiltered view TPI reads |
| `SendGLAccounting` | `Non_Bank_GL` | normal upstream loader (not used here) |
| `tblPrepareAcctg`, `tblMainData` | `TPI` | staging then working set |
| `LGLTraceNumber` | `TPI` | trace number per application — inner joined |
| `GLAccountCategoryMapping` | `TPI` | Workday Spend/Revenue categories |
| `GetGLData` | `TPI` | `tblMainData` → `OGLTransactions` |
| `GetExtractRecordsWorkdayAPIGL` | `TPI` | what the SSIS package selects |
| `TPIGLUpload_Workday.dtsx` | `TPI/SSIS/` | the package under test |

Local copies of the `Non_Bank_GL` objects are in
`../../../non_bank_gl/database/dbo/`; the TPI objects are in `../dbo/`.
