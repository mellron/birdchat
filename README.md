# Why did tickets get reversed?

**Audience:** Business partners (plain English, 8th‑grade level)

This note explains, in simple terms, how our system could put the **right amounts on the wrong tickets**, and what we changed to stop it from ever happening again.

---

## The short story

We had **two lists**:

* List A: ticket numbers (like: 4897, 4900)
* List B: amounts (like: \$62,000, \$398,000)

The system split both lists apart and then **matched items by position** (1st with 1st, 2nd with 2nd). But the database sometimes **changed the order** of one list before matching. When that happened, the ticket–amount pairs got **flipped**.

---

## A simple example

Imagine two stacks of index cards:

* Stack A (tickets): \[4897] \[4900]
* Stack B (amounts): \[\$62,000] \[\$398,000]

We plan to match card 1 to card 1, and card 2 to card 2. But if someone quietly **shuffles** one stack before we match them, we can end up with:

* 4897 → \$398,000 (wrong)
* 4900 → \$62,000 (wrong)

That’s what happened.

---

## Why could the order change?

Databases are great at speed, so they sometimes **reorder data** to run faster. Unless we **tell** it exactly how to order the rows, the database is allowed to pick any order it wants. That can be different from one run to the next, or different between servers.

In our old code, we split the ticket list and the amount list **separately**, and then matched them by a row number the database gave each side. If one list came back in a different order, the pairs no longer lined up.

> Key point: **No guaranteed order** = **possible mismatches**.

---

## How we fixed it

We now add an **Ordinal** (position number) to every item as we split it. Think of it as writing the index on each card:

* Ticket list becomes: (1, 4897), (2, 4900)
* Amount list becomes: (1, \$62,000), (2, \$398,000)

Then we match **by Ordinal** (1↔1, 2↔2). Even if the database reorders the rows later, the Ordinal travels with each item, so the correct pairs are preserved.

We also keep an **ORDER BY Ordinal** when inserting into the final table, so the output appears in the same sequence as the original list.

---

## Extra safety checks we added

* **Count check:** if the number of tickets doesn’t equal the number of amounts, we stop and show an error instead of guessing.
* **Format check:** we try to convert tickets to numbers and amounts to currency; if any item is invalid, we stop.

These checks help us fail **safe** rather than mis-assigning money.

---

## What this means for you

* The pairing is now **deterministic** (predictable and repeatable).
* The fix is **low risk**: we didn’t change business logic—only how we match items.
* You should no longer see the “reversed ticket” issue.

---

## Quick Q\&A

**Q: Why didn’t we just tell the database to keep the order?**
A: We do now. But more importantly, we give each item an **Ordinal** so even if the database reorders things for speed, the correct pairs stay together.

**Q: Could this happen again?**
A: With the Ordinal approach and the new checks, this specific flip should not happen.

**Q: Did this change slow anything down?**
A: No. The new approach is actually **faster** in most cases and easier for the database to optimize.

---

## One‑line takeaway

We stopped relying on “whatever order the database feels like,” and started matching each ticket and amount by a shared **position number**. That keeps the right dollars on the right tickets—every time.
