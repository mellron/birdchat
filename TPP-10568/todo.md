# TPP-10568 — To Do / Information Needed

## From Kurt — Meeting 2026-04-03 (Completed)

- [x] Message Queue (MQ) layouts from Fixed Income Clearing Corporation (FICC) — field definitions and structure → **GSD200 (MT515 input, MT509/MT518 output), GSD149 (netting output)**
- [x] Message Queue (MQ) forms from Fixed Income Clearing Corporation (FICC) — submission templates → **GSD200 and GSD149 PDFs in Kurt_info/**
- [ ] What MQ connection details does FICC require? (host, queue manager, channel, queue name) → **MQ production infrastructure exists; BNY Mellon channels are live. FICC channel status unknown — need to contact ficcintegration@dtcc.com**
- [ ] Are we already certified / registered with FICC for automated MQ submission, or is that a separate onboarding step? → **Unknown — contact FICC Integration (ficcintegration@dtcc.com) to confirm. Sheila may have a prior FICC contact.**
- [ ] Has any MQ testing with FICC been done previously, or is this greenfield? → **Unknown for FICC specifically. BNY Mellon MQ is established. FICC channel may be greenfield.**

---

## Technical Discovery Needed

- [x] Does US Bank have existing Message Queue (MQ) infrastructure that could connect to FICC, or does new infrastructure need to be built? → **MQ production infrastructure exists. BNY Mellon channels live. FICC channel TBD.**
- [ ] Which MT515 message style applies to which trade type?
  - [ ] DVP (Delivery Versus Payment) trades → MT515 DVP style?
  - [ ] Repo trades → MT515 DVP or GCF (General Collateral Finance) style?
  - [ ] CCIT (Centrally Cleared Institutional Triparty) — does US Bank use this product?
- [ ] Where exactly does trade data need to originate from for automation? (still open)
  - [ ] Money Center Trading / Investment Portfolio (IP): Bloomberg Trade Order Management System (TOMS) → Intrader → [CPMS? or direct?] → FICC
  - [ ] Delivery Versus Payment (DVP) / Funding (Sheila): BNY Mellon AccessEdge download → CPMS → FICC (CPMS-centric preferred) vs. some other path
- [ ] What is the Intrader export capability? Can it publish to a Message Queue (MQ) or feed the Swift API?
- [ ] What data fields does the CPMS bulk upload feed contain — does it provide all fields needed to populate an MT515 message?
- [ ] Review US Bancorp Investments (USBI) Phase 3 connection to FICC as reference architecture — who owns that and can we get documentation?
- [ ] Confirm current status of the Swift Messaging Conversion Application Programming Interface (API) build — which BNY Mellon message types are complete? What is remaining for FICC (MT515)?
- [ ] Does the existing MQ Application Programming Interface (API) support the FICC channel, or does a new channel configuration need to be added?

---

## Business / Process Questions

- [ ] Confirm current and projected trade volumes for each user group:
  - [ ] Funding / Delivery Versus Payment (DVP) — Sheila's team
  - [ ] Money Center Trading
  - [ ] Investment Portfolio (IP) — Jeff's group
- [x] Clarify Delivery Versus Payment / Funding path → **Decided (2026-04-06)**: Bank of New York Mellon existing download → Collateral Pledging Management System (CPMS) bulk upload → new Collateral Pledging Management System (CPMS) user interface → Fixed Income Clearing Corporation (FICC) submission. Management overrode Sheila's preference.
- [x] Can we modify Bank of New York Mellon screens? → **No** — US Bank cannot add or change any Bank of New York Mellon screens or systems. All Bank of New York Mellon interaction must use existing download/export as-is.
- [x] Will a user interface be built? → **Yes** — new Collateral Pledging Management System (CPMS) screens for trade submission queue and Fixed Income Clearing Corporation (FICC) status.
- [ ] Confirm blackout period details — November 1, 2026 cutoff means go-live must be by Q3 2026 (September)
- [ ] Does Sheila have a current Fixed Income Clearing Corporation (FICC) contact? (for Message Queue onboarding coordination)

---

## User Interface — Still Needed Before Stories Can Be Fully Specced (TPP-10575)

- [ ] What fields does Sheila need to see on the trade submission queue screen?
  - At minimum: security (Committee on Uniform Securities Identification Procedures number), par amount, counterparty, trade date, settlement date, repo rate (for repos), transaction type
  - Confirm with Sheila — are there additional fields she needs to make an approval decision?
- [ ] Does she approve one trade at a time, or in bulk (select multiple → approve all)?
- [ ] Who else has access to the new Collateral Pledging Management System (CPMS) screens?
  - Sheila's Funding / Delivery Versus Payment group — confirmed
  - Money Center Trading — same screen or different flow since they originate in Intrader?
  - Investment Portfolio — same question as Money Center
  - Back office (Eric's team) — view-only access to status?
- [ ] Does Money Center / Investment Portfolio use the same submission screen as Sheila, or do their Intrader-originated trades flow through automatically without a manual approval step?
- [ ] What is the Collateral Pledging Management System (CPMS) user interface technology stack? (likely ASP.NET WebForms based on existing system — confirm before building)
- [ ] For the Bank of New York Mellon Delivery Versus Payment download (TPP-10574): does Vin trigger the download manually, or should it be automated/scheduled?
- [ ] What happens if Sheila wants to reject / hold a trade rather than approve it — is there a "do not submit" option on the screen?
- [ ] Are there role-based permissions needed — e.g., only certain users can approve, others can only view?

---

## Track 2 — Collateral Messaging

- [ ] Confirm with Glenn's team current status of Swift messaging conversion Application Programming Interface (API) build
- [ ] Identify landing zone for BNY Mellon Swift / Message Queue (MQ) messages at US Bank — does one exist or does it need to be created?
- [ ] Get Society for Worldwide Interbank Financial Telecommunication (Swift) message format details from BNY Mellon (what fields come back identifying Qualified Collateral Instruments/Pledged (QCIPs)?)
- [ ] Confirm how updated encumbrance data flows from the Swift conversion API into Collateral Pledging Management System (CPMS)

---

## Compliance / Security

- [ ] Define audit trail requirements for automated trade submissions
- [ ] Define rollback / manual fallback procedure if automation fails
- [ ] Confirm security requirements for MQ connection to FICC (certificates, credentials, network access)

---

## Spike Deliverables (Acceptance Criteria)

- [ ] Future-state automated flow defined at a high level — *in progress*
- [ ] Document how to automate current trade entry process on FICC Real-Time Trade Matching (RTTM) website — *in progress*
- [ ] Backlog created for offshore team (subtasks TPP-10569 through TPP-10573) — *pending above information*
