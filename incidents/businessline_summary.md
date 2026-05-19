# INC30522392 — Business Summary

**What happened:** The daily check between CPMS and Intrader showed a $16,200,000 difference on FHLB San Francisco stock (CUSIP 3133889F9, ticket 867004812).

**Bottom line:** The numbers in our database are correct. The CPMS Web screen is showing the wrong total because of a small bug in how it filters the data before displaying it. CPMS Legacy shows the right number. A single small change to one database view will fix it.

---

## What's going on, in plain language

Think of a bank account that has two parts:
- One pocket holds **+$41.85 million** (location HSF)
- Another pocket holds **-$16.20 million** (location FHL — this happened because of a recent transfer out)
- The **real total is $25.65 million** (adding both pockets together)

Both pockets are correctly recorded in our database. CPMS Legacy reads both pockets and shows the right total of $25.65 million. Intrader also shows $25.65 million. They agree.

CPMS Web is supposed to show the same thing — but it has a rule that says: *"Ignore any pocket with a negative number."* So it only sees the $41.85 million pocket and reports that as the full position. That's $16.2 million too high.

This rule has been in CPMS Web for a long time, but nobody noticed because we never had a negative pocket before. Ticket 867004812 is the first time it happened, which is why this is showing up now.

---

## What needs to happen

We need to change the rule in one CPMS database view (a piece of code that pulls data together for the Web screen). The fix is one line. We have two safe options:

### Option 1 — Remove the rule completely

Take out the rule that filters out negative amounts. CPMS Web would then show every pocket, including negative ones. This is the simplest fix.

- **Pros:** Easiest to explain. Shows users exactly what's in the database.
- **Cons:** Users will see zero-dollar rows too (pockets that exist but hold nothing). Most of the time these are not interesting and could clutter the screen.

### Option 2 — Tighten the rule so it only hides empty pockets *(recommended)*

Change the rule from "hide negative pockets" to "hide pockets that are exactly zero." Negative pockets show up, empty ones stay hidden.

- **Pros:** Fixes the bug without adding clutter. Keeps the original spirit of the rule (don't show empty rows) but stops it from incorrectly hiding real negative positions.
- **Cons:** Slightly more nuanced change to explain to QA.

---

## What we recommend

**Option 2.** It's the smallest, safest change that solves the actual problem. After the change is made:

1. CPMS Web will show the same numbers as CPMS Legacy and Intrader.
2. The daily reconciliation will match.
3. Any other tickets that have negative pockets (we'll search for them) will also start displaying correctly.

---

## What does NOT need to happen

- **No emergency data fix.** The database itself is correct.
- **No file resends from Intrader.** The files we received from Intrader on 5/18 were complete and correct.
- **No SSIS or load job re-runs.** Those all ran successfully.
- **No urgent action overnight.** Since FHLB stock is classified as NMO (Non-Marketable Obligations), it is excluded from LCR (Liquidity Coverage Ratio) regulatory reporting. The error has no impact on what we report to regulators.

---

## Expected timing

1. Apply the one-line fix in the development environment.
2. Test that CPMS Web now shows the correct $25.65 million for ticket 867004812.
3. Search for any other tickets with negative pockets that may have been hidden by the same rule.
4. Promote the fix through standard change control.
5. Re-run the 5/18 reconciliation to confirm it now matches.

---

## Who needs to know

- **Diana Yang, Parshwa Shah** — being kept current on technical findings
- **Corinne O'Neil** — original reporter; will be notified once the fix is in and the reconciliation matches
- **Manos Pytikakis, Dennis Plotkin** — copied on the original report
