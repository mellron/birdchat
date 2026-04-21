# TPP-10568 — Spike Current State

**Last Updated**: 2026-04-16  
**Status**: In Progress — 4 discovery conversations remaining before spike can close

---

## Acceptance Criteria Progress

| Deliverable | Status |
|---|---|
| Future-state automated flow defined at a high level | **Done** — sequence diagram and architecture documented in TPP-10568.md |
| Document how to automate current RTTM trade entry | **Done for FICC side** — message formats (MT515/MT509), MQ onboarding process, and architecture all documented. Intrader data source still TBD pending Brian call. |
| Backlog created for offshore team | **Partially done** — TPP-10569 through TPP-10575 written. TPP-10576 (Intrader → CPMS feed) cannot be written until Brian call. DVP entry screen story cannot be written until Option A/B decision. |

---

## What Has Been Discovered

### FICC Side — Complete

- **Message formats confirmed**: MT515 DVP style for DVP repos and cash Buy/Sell; MT515 GCF style for GCF repos. Full lifecycle flows in GSD200 Appendix B (page 108+).
- **MQ onboarding is greenfield** — no existing FICC channel. Three-step process: MQ Page 1 (US Bank submits) → MQ Page 2 (FICC returns with queue names) → Data Delivery Form (US Bank completes with queue names + MRO subscriptions).
- **Conformance Testing** in FICC's PSE (Pre-production/Staging Environment) — Excel-based scenarios by account type. US Bank signs off before Production go-live.
- **FICC contact established**: Edward Pinto, Integration Technical Analyst II — epinto@dtcc.com, +1 212-855-1664.
- **US Bank Member ID**: 9286 — US Bank National Association.

### Architecture — Complete

- **CPMS-centric architecture** confirmed (Kurt, 2026-04-03): CPMS → Swift Messaging Conversion API → MQ API → FICC.
- **MQ infrastructure exists** — BNY Mellon channels live. FICC channel is new onboarding.
- **Swift Messaging Conversion API partially built** in Java — two BNY Mellon message types done. Not extended for FICC yet.
- **FICC uses SWIFT-format (ISO 15022) messages over its own proprietary MQ network** — not the SWIFT network.

### Trade Source — Partially Complete

- **Money Center Trading and Investment Portfolio (IP)**: Bloomberg TOMS → Intrader is the confirmed source system. How data gets from Intrader into CPMS is still unknown — pending Brian call.
- **DVP / Funding (Sheila)**: No source system exists. Sheila uses Microsoft Access only. Source system decision required before this track can be built.
- **BNY Mellon AccessEdge download** is post-trade collateral tracking (Track 2) — confirmed NOT a source for FICC trade submission.

### Decisions Made

- A **new CPMS user interface will be built** for the submission queue and FICC status screen.
- **No BNY Mellon screen modifications** — all BNY interaction uses existing download/export as-is.
- **Sheila's Microsoft Access system** must not be integrated — unsupported, not a path forward.
- **Priority order confirmed** (Sheila, 2026-04-06): Money Center Trading and Investment Portfolio first; DVP repo deferred.

---

## What Still Needs to Be Discovered

These four conversations are the remaining blockers. The spike cannot close and the backlog cannot be finalized until they are complete.

---

### 1. Brian — Money Center Trading (Call Being Scheduled)

**Why this is the highest priority**: Money Center Trading / Investment Portfolio is the priority Track 1 path. Without this, the two most critical offshore stories (TPP-10569 and TPP-10575) cannot be fully specced.

**Questions to answer:**

| Question | Why It Matters |
|---|---|
| What data can Intrader export? What fields are available? | Gates TPP-10569 (field mapping) — can't map MT515 fields without knowing what Intrader provides |
| Can Intrader push data directly to CPMS, or does it require an intermediate step (file drop, API call, scheduled pull)? | Determines whether TPP-10576 (Intrader → CPMS feed) needs to be written as a new story, and how complex it is |
| What is the exact field name in Intrader for: trade reference number, trade date, settlement date, CUSIP, par amount, price, counterparty, transaction type (buy/sell/repo/reverse)? | Populates the source column in TPP-10569 field mapping table |
| Do trades flow automatically from Bloomberg TOMS into Intrader, or is there a manual step? | Affects how real-time the submission queue will be |
| What are current and projected trade volumes for Money Center? | Infrastructure sizing — queue design, throughput requirements |

**Stories gated on this call**: TPP-10569 (Path A), TPP-10575 (queue screen columns), TPP-10576 (potential new story)

---

### 2. Parshwa Shah — DVP Source System Decision + IP Contact

**Two separate asks, one conversation.**

#### DVP Source System Decision

A management decision is required on how to handle Sheila's DVP repo group, which has no source system:

| Option | Description | Impact |
|---|---|---|
| **Option A** | Build a new CPMS data entry screen for Sheila to manually enter DVP repo trades | A new story needs to be written (does not exist yet). TPP-10575 scope expands to include Sheila. |
| **Option B** | Defer DVP repo automation until after Bloomberg TOMS path is complete | Stories remain as currently scoped. DVP entry is out of scope for this sprint. |

Until this decision is made, any DVP-specific work cannot be started and the backlog is incomplete.

#### Investment Portfolio Contact

Parshwa was asked to provide the contact name for the Investment Portfolio group under Jeff. This person needs to be consulted to confirm IP has the same data flow as Money Center (Bloomberg TOMS → Intrader) and has no special requirements.

**Stories gated on this conversation**: DVP entry screen story (new, if Option A), TPP-10575 scope, TPP-10569 Path B

---

### 3. Glenn — Swift Messaging Conversion API Current State

TPP-10571 asks the offshore team to *extend* the existing Swift Messaging Conversion API to support MT515. Before that story can be properly scoped, we need to know what they're walking into.

**Questions to answer:**

| Question | Why It Matters |
|---|---|
| Which BNY Mellon message types are already implemented? | Tells the offshore team what patterns already exist that they can follow for MT515 |
| What framework or structure does the API use to build SWIFT-format messages? Is there a shared message-building base class, or does each message type build its own structure independently? | Determines whether MT515 can be added with modest effort or requires a new implementation pattern |
| Where is the API codebase? What is the repo / project name? | Offshore team needs access to it |
| What is the current deployment and testing approach for the API? | Affects how conformance testing against FICC's PSE environment will work |
| What BNY Mellon message types are still remaining to be built? | Confirms MT515 is truly the next logical addition |

**Story gated on this conversation**: TPP-10571 (MT515 message builder)

---

### 4. John (Tech Lead) — CPMS UI Technology Stack

TPP-10575 (the submission queue and status screen) cannot be properly scoped until the technology stack is confirmed. Building in the wrong framework would require a full rewrite.

**Questions to answer:**

| Question | Why It Matters |
|---|---|
| What is the CPMS front-end technology stack? (Expected: ASP.NET WebForms — confirm) | Offshore team must build in the same framework as the rest of CPMS |
| Is there an existing CPMS screen that can serve as a reference or template for the new submission queue screen? | Speeds up development and ensures consistency |
| Does USBI Phase 3 already have a FICC-connected CPMS screen we could use as a reference architecture? Who owns that code? | Could significantly inform TPP-10575 and TPP-10573 design |
| Does the existing MQ API have a routing configuration that supports adding new channels, or does adding the FICC channel require code changes? | Scopes TPP-10573 more accurately |

**Story gated on this conversation**: TPP-10575 (CPMS UI)

---

## Items That Do NOT Need to Block the Spike

These are open in the todo but can be answered within individual stories during refinement — they don't need to hold up spike closeout.

| Item | Why It Can Wait |
|---|---|
| Trade volumes for Sheila's DVP group and IP | Useful for sizing but doesn't change what needs to be built |
| Audit trail, rollback, and security specifics | Important but can be defined within TPP-10572 and TPP-10573 during refinement |
| Role-based access and UI interaction details (bulk vs. single approval, hold/reject flow) | Can be confirmed with Parshwa during TPP-10575 refinement |
| CCIT product question | Likely not applicable to US Bank; can be confirmed during FICC conformance testing setup |
| Track 2 details (BNY Swift message format, landing zone) | No regulatory deadline — Track 2 can be scoped separately after Track 1 stories are in progress |
| Blackout period cutoff specifics | November 1, 2026 is documented; exact details don't change story scope |

---

## Current Story Inventory

| Story | Description | Status |
|---|---|---|
| TPP-10569 | MT515 Mandatory Field Data Mapping and Gap Analysis | Written — Path A (Intrader) incomplete pending Brian call |
| TPP-10570 | Build Counterparty FICC Firm ID Reference Table | Written — ready for offshore |
| TPP-10571 | Extend Swift Messaging Conversion API to Build MT515 Messages | Written — open questions pending Glenn conversation |
| TPP-10572 | Handle MT509 Trade Status Responses from FICC | Written — ready for offshore |
| TPP-10573 | Establish FICC MQ Channel in Existing MQ Infrastructure | Written — ready; MQ Page 1 submission is the first action |
| TPP-10574 | BNY Mellon DVP Download to CPMS — Post-Trade Collateral Tracking | Written — Track 2, independent, ready |
| TPP-10575 | Build CPMS FICC Trade Submission and Status UI | Written — needs Intrader field list (Brian) and tech stack (John) before fully specced |
| TPP-10576 *(potential)* | Intrader → CPMS Trade Feed | **Not written yet** — depends entirely on what Brian says about Intrader export capability |
| *(unnamed, potential)* | CPMS DVP Repo Manual Entry Screen for Sheila | **Not written yet** — only needed if Parshwa chooses Option A |
