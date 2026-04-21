# TPP-10568 — Acceptance Criteria

**Status:** Draft — pending final review by Parshwa Shah and Diana
**Last updated:** 2026-04-21
**Parent spike:** [TPP-10568.md](./TPP-10568.md)

---

## Purpose

This document captures the acceptance criteria (AC) for automating Treasury trade submission to the Fixed Income Clearing Corporation (FICC) Real-Time Trade Matching (RTTM) system, replacing manual website entry.

The AC are grouped into two categories:

1. **Spike-level AC** — what this spike (TPP-10568) must deliver to be considered complete
2. **Solution-level AC** — the functional and non-functional requirements for the downstream implementation stories (TPP-10569 through TPP-10575)

---

## 1. Spike-Level Acceptance Criteria (TPP-10568)

These are the original three acceptance criteria from the Jira story:

| # | Criterion | Status |
|---|---|---|
| 1.1 | Future-state automated flow leveraging Fixed Income Clearing Corporation (FICC) defined at a high level | **Done** — see [highlevelflow.md](./highlevelflow.md) and the Future State Flow section of [TPP-10568.md](./TPP-10568.md) |
| 1.2 | Document how to automate current trade entry process on Fixed Income Clearing Corporation (FICC) Real-Time Trade Matching (RTTM) website | **Done** — see FICC Interactive Messaging (IM) Message Formats and Existing Infrastructure sections of [TPP-10568.md](./TPP-10568.md) |
| 1.3 | Backlog created for offshore team | **Done** — TPP-10569 through TPP-10575 written. Two follow-ons pending: TPP-10576 (Intrader → CPMS feed, pending Brian Goetter call) and a Delivery Versus Payment (DVP) entry screen story (pending Option A/B decision) |

---

## 2. Solution-Level Acceptance Criteria

### 2.1 Scope

**In scope for Track 1 (regulatory deadline Q3 2026):**

- Cash Treasury buy and sell trades submitted via the Real-Time Trade Matching (RTTM) Buy/Sell tab
- Repo and reverse-repo trades submitted via the RTTM Repo/Reverse tab
- Source systems: Bloomberg Trade Order Management System (TOMS) and Intrader for Money Center Trading and Investment Portfolio (IP) user groups
- Outbound Message Type 515 (MT515) construction and submission over Message Queue (MQ) to FICC
- Inbound Message Type 509 (MT509) trade status processing into the Collateral Pledging Management System (CPMS)

**Out of scope for this work (tracked separately):**

- Delivery Versus Payment (DVP) repo originated by the Funding group (Sheila) — no source system exists; deferred pending Option A/B decision from Parshwa Shah
- Track 2 back-end collateral messaging from Bank of New York Mellon (BNY Mellon) — no regulatory deadline
- Modifications to any BNY Mellon system (AccessEdge, Broker Dealer Clearance (BDC), Nexen) — prohibited by design constraint
- Integration with Sheila's legacy Microsoft Access tracking system — prohibited by design constraint

### 2.2 Architectural Direction

- **AC 2.2.1** — The solution shall be **assistive**, not a full replacement of RTTM. A new CPMS screen shall mirror the RTTM Buy/Sell and Repo/Reverse tabs, pre-populated with Bloomberg TOMS data, and shall submit to FICC via MT515 over MQ.
  > Endorsed by the business line on 2026-04-21: "use another system like CPMS and duplicate this form and have all the information behind it. And have the Bloomberg information already there... then you would send it through the messaging system." Diana concurred.
- **AC 2.2.2** — The solution shall not attempt to upload files to RTTM. RTTM does not support file import.
- **AC 2.2.3** — The solution shall follow the CPMS-centric architecture: CPMS → Swift Messaging Conversion Application Programming Interface (API) → MQ API → FICC.

### 2.3 Data Source

- **AC 2.3.1** — The solution shall pull Treasury trade data from Bloomberg TOMS via the Intrader pipeline. The Bloomberg export produces a spreadsheet-compatible format whose field values are directly usable (confirmed 2026-04-21 demo).
- **AC 2.3.2** — Prices received from Bloomberg shall be consumed in **decimal format** (not tick format). RTTM rejects tick format (e.g., `100-01`).
- **AC 2.3.3** — Bloomberg sits outside the US Bank firewall. The solution shall rely on an export-to-landing-zone mechanism inside the firewall; direct firewall traversal to Bloomberg is out of scope.
- **AC 2.3.4** — For Delivery Versus Payment (DVP) repo originated by the Funding group, no automated data source exists. That path is deferred and shall not gate delivery of the Money Center Trading / Investment Portfolio path.

### 2.4 MT515 Message Construction and Split Logic

- **AC 2.4.1** — The solution shall split any Delivery Versus Payment (DVP) trade whose par amount exceeds **$50,000,000** (50 million) into multiple MT515 messages, each with par less than or equal to $50MM.
  > This is a Federal Reserve Bank (FED) delivery constraint for Treasury securities, confirmed by both Sheila and Edward Pinto at Depository Trust & Clearing Corporation (DTCC). It is not a user interface limit.
- **AC 2.4.2** — The solution shall apply the tri-party $30,000,000,000 (30 billion) per-message cap and the General Collateral Finance (GCF) $9,990,000,000 (9.99 billion) per-message cap to the appropriate MT515 styles.
- **AC 2.4.3** — Each split MT515 message shall be assigned a **unique Trade Cross Reference (Xref) number**. Split messages shall not share the parent trade's reference.
  > FICC rule: Xref must be unique per member per day. Reuse is allowed on subsequent business days.
- **AC 2.4.4** — The Xref generation scheme shall derive from the Bloomberg ticket number with a disambiguating suffix (e.g., `<ticket>-1`, `<ticket>-2`, ...). Bloomberg emits a single ticket number per trade regardless of size, so the suffix must be generated system-side.
- **AC 2.4.5** — When splitting, the solution shall distribute par evenly across messages and **absorb any rounding remainder in the final split message**. The counterparty is expected to follow the same convention; matching is done on par and settlement amount per split, not on ticket identity.
- **AC 2.4.6** — The Xref value is internal to FICC and shall **not** be propagated downstream to Broker Dealer Clearance (BDC) or BNY Mellon operations.

### 2.5 MT515 Field Population

The solution shall populate the MT515 fields required by the RTTM Buy/Sell and Repo/Reverse screens. Required fields per tab:

**Buy/Sell (cash Treasury buys and sells):**

| Field | Source |
|---|---|
| Member Identifier (ID) | Static — `9286` (US Bank National Association) |
| Product | Always `DVP` for cash buy/sell |
| Committee on Uniform Securities Identification Procedures (CUSIP) | Bloomberg export |
| Trade Date | Bloomberg export |
| Settlement Date | Bloomberg export |
| Pricing Method | User selection — Price, Yield, or Discount (no default established) |
| Transaction Type | Bloomberg export — Buy or Sell |
| Par | Bloomberg export (per-split after 2.4.1 is applied) |
| Price | Bloomberg export, in decimal format |
| Settlement Amount | Bloomberg export — **must be supplied; FICC does not derive this from price** |
| Contra Identifier (ID) | Counterparty lookup — see AC 2.6 |
| Trade Cross Reference (Xref) | Generated per AC 2.4.3 / 2.4.4 |

**Repo / Reverse Repo:**

| Field | Source |
|---|---|
| Member Identifier (ID) | Static — `9286` |
| Product | Delivery Versus Payment (DVP), General Collateral Finance (GCF), or Centrally Cleared Institutional Triparty (CCIT) — user-selected (CCIT usage to be confirmed) |
| Committee on Uniform Securities Identification Procedures (CUSIP) | Bloomberg export |
| Trade Date | Bloomberg export |
| Start Date | Bloomberg export |
| Settlement Date | Bloomberg export |
| Transaction Type | Repo or Reverse |
| Par | Bloomberg export (per-split) |
| Start Money | Bloomberg export |
| Repo Rate (%) | Bloomberg export |
| Contra Identifier (ID) | Counterparty lookup — see AC 2.6 |
| Trade Cross Reference (Xref) | Generated per AC 2.4.3 / 2.4.4 |

### 2.6 Counterparty Reference Data

- **AC 2.6.1** — The solution shall maintain a reference table mapping trading counterparties (as identified by Bloomberg) to their FICC firm identifier (Contra ID). Tracked in TPP-10570.

### 2.7 User Interface Behavior

- **AC 2.7.1** — The CPMS trade submission screen shall provide RTTM-parity functionality, including an equivalent of RTTM's "copy prior entry" feature so that repeated field values (e.g., settlement date, counterparty) are carried forward between entries.
- **AC 2.7.2** — The user shall be able to validate a trade before submission. Validation shall be a read-only call to FICC and shall incur no cost. (FICC charges $0.25 for pre-match modifications; validate is free.)
- **AC 2.7.3** — The user shall be able to modify or delete a trade after submission but before FICC match. Modifications after match are prohibited and shall be blocked by the user interface.
- **AC 2.7.4** — Trade status from FICC (MT509) shall be displayed on the CPMS status screen, including the pending-match and matched states.
- **AC 2.7.5** — The user interface shall support free-text entry wherever Bloomberg pre-population is unavailable, to avoid blocking trade submission when source data is incomplete.

### 2.8 Volume and Performance

- **AC 2.8.1** — The solution shall support projected daily volumes of 10 to 100+ trades per day, up from the current 1–2 manual trades per day.
  > Volume projection from Parshwa Shah, 2026-04-20: "in future, they are going to get into volumes like they might get like 10 or hundreds of trades in a day."

### 2.9 Non-Functional Constraints

- **AC 2.9.1** — The solution shall be operational in production by the end of Q3 2026 (September 2026). FICC blackout periods begin 2026-11-01 and no production deployment may occur after that date.
- **AC 2.9.2** — FICC Message Queue (MQ) channel onboarding requires approximately 20–30 business days from Page 1 submission to conformance testing readiness. The MQ Page 1 form shall be submitted as early as possible.
- **AC 2.9.3** — Pre-production conformance testing shall be completed in the FICC Pre-production/Staging Environment (PSE) using the Excel scenario sheet provided by DTCC. PSE uses a separate Uniform Resource Locator (URL) but shares login credentials with production.
- **AC 2.9.4** — The solution shall not modify, extend, or integrate with any BNY Mellon system.
- **AC 2.9.5** — The solution shall not integrate with Sheila's Microsoft Access tracking system.

### 2.10 Audit and Rollback

- **AC 2.10.1** — Every MT515 sent and every MT509 received shall be logged with timestamp, user, trade reference, and full message payload for audit.
- **AC 2.10.2** — The existing manual RTTM website process shall remain available as a fallback during the transition period. Users shall retain access and training to submit manually if the automated path fails.

---

## 3. Open Items Blocking Final AC Sign-Off

| Item | Owner | Blocks |
|---|---|---|
| Intrader export mechanism and field list | Brian Goetter (Money Center Trading) | AC 2.3.1, AC 2.5 field mapping |
| Pricing Method default (Price / Yield / Discount) | Brian Goetter | AC 2.5 Buy/Sell table |
| Centrally Cleared Institutional Triparty (CCIT) product use | Business line | AC 2.5 Repo table |
| US Bancorp Investments (USBI) Phase 3 channel reuse question | Edward Pinto (DTCC) | AC 2.9.2 |
| Swift Messaging Conversion API inventory — what is already built | Jose | TPP-10571 scope |
| CPMS UI technology stack | John | TPP-10575 implementation choice |
| Delivery Versus Payment (DVP) repo source system — Option A vs Option B | Parshwa Shah | Out-of-scope boundary in section 2.1 |

---

## 4. Revision History

| Date | Change |
|---|---|
| 2026-04-21 | Initial draft. Incorporates Parshwa call (2026-04-20), Sheila transcript re-read (2026-04-20), and business line RTTM demo meeting (2026-04-21). |
