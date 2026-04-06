# TPP-10568 — High-Level Future State Flow
# Automate Treasury Trade Submission to FICC RTTM

## Track 1 — Front-End Trade Submission (Regulatory Deadline: Q3 2026)

```mermaid
sequenceDiagram
    autonumber

    participant BNY as BNY Mellon<br/>AccessEdge
    participant Vin as Vin / Sheila<br/>(Operations)
    participant CPMS as Collateral Pledging<br/>Management System (CPMS)
    participant Sheila as Sheila<br/>(Front Office)
    participant SwiftAPI as Swift Messaging<br/>Conversion API
    participant MQAPI as MQ API /<br/>MQ Infrastructure
    participant FICC as FICC GSD<br/>(MQ Channel)

    rect rgb(60, 100, 160)
        Note over BNY,CPMS: Phase 1 — Load DVP Trade Data into CPMS (TPP-10574)
        Vin->>BNY: Download DVP trade data (existing AccessEdge export)
        BNY-->>Vin: Spreadsheet / file of DVP trades
        Vin->>CPMS: Bulk upload DVP trades
        CPMS-->>Vin: Import result — trades loaded, errors flagged
    end

    rect rgb(60, 140, 100)
        Note over Sheila,CPMS: Phase 2 — Review and Approve Trades for FICC Submission (TPP-10575)
        Sheila->>CPMS: Open FICC submission queue screen
        CPMS-->>Sheila: Display pending trades (security, par, counterparty, dates, rate)
        Sheila->>CPMS: Select trades and click Submit
        CPMS->>CPMS: Validate all MT515 mandatory fields<br/>Resolve Counterparty FICC Firm ID (TPP-10570)
    end

    rect rgb(140, 80, 80)
        Note over CPMS,FICC: Phase 3 — Build and Send MT515 Trade Input Message to FICC (TPP-10571, TPP-10573)
        CPMS->>SwiftAPI: Request — build MT515 message for trade
        SwiftAPI->>SwiftAPI: Construct MT515 (DVP style)<br/>ISO 15022 SWIFT-format text string
        SwiftAPI-->>CPMS: MT515 text string
        CPMS->>MQAPI: Send MT515 to FICC
        MQAPI->>FICC: Route via FICC GSD MQ channel
        CPMS->>CPMS: Update trade status — Submitted to FICC
    end

    rect rgb(120, 80, 140)
        Note over FICC,Sheila: Phase 4 — Receive MT509 Trade Status Response from FICC (TPP-10572, TPP-10575)
        FICC-->>MQAPI: MT509 Trade Status (Accepted / Rejected / Compared)
        MQAPI-->>SwiftAPI: Route inbound MT509
        SwiftAPI-->>CPMS: Parsed status — trade reference, status, reason code if rejected
        CPMS->>CPMS: Update trade record with FICC status
        Sheila->>CPMS: View status screen — see Accepted / Compared / Rejected per trade
    end
```

---

## Track 1 — Money Center Trading / Investment Portfolio Path

> **Note:** The data source for this path is still to be determined (TBD). The Swift API → MQ → FICC leg is identical to Sheila's path. The open question is how trade data gets from Intrader into CPMS.

```mermaid
sequenceDiagram
    autonumber

    participant TOMS as Bloomberg Trade Order<br/>Management System (TOMS)
    participant Intrader as Intrader
    participant Source as Data Source<br/>(TBD — Intrader feed or CPMS import)
    participant CPMS as Collateral Pledging<br/>Management System (CPMS)
    participant SwiftAPI as Swift Messaging<br/>Conversion API
    participant MQAPI as MQ API /<br/>MQ Infrastructure
    participant FICC as FICC GSD<br/>(MQ Channel)

    rect rgb(60, 100, 160)
        Note over TOMS,Source: Phase 1 — Trade Data Source (TBD — TPP-10569 will clarify)
        TOMS->>Intrader: Book trade (buy / sell / repo)
        Intrader-->>Source: Trade data available
        Source->>CPMS: Feed trade into CPMS pending queue
        Note over Source,CPMS: How this step works depends on<br/>Intrader export capability — TBD
    end

    rect rgb(140, 80, 80)
        Note over CPMS,FICC: Phase 2 — Build and Send MT515 (same as Sheila's path)
        CPMS->>SwiftAPI: Request — build MT515 message
        SwiftAPI-->>CPMS: MT515 text string
        CPMS->>MQAPI: Send MT515 to FICC
        MQAPI->>FICC: Route via FICC GSD MQ channel
    end

    rect rgb(120, 80, 140)
        Note over FICC,CPMS: Phase 3 — Receive MT509 Response (same as Sheila's path)
        FICC-->>MQAPI: MT509 Trade Status
        MQAPI-->>SwiftAPI: Route inbound MT509
        SwiftAPI-->>CPMS: Update trade status
    end
```

---

## Track 2 — Back-End Collateral Messaging (No Regulatory Deadline)

> This track automates the BNY Mellon collateral encumbrance update into CPMS after a trade settles. No hard deadline but reduces manual back-office work for Eric's team.

```mermaid
sequenceDiagram
    autonumber

    participant FICC as FICC GSD
    participant BNY as BNY Mellon<br/>(AccessEdge / BDC)
    participant MQAPI as MQ API /<br/>MQ Infrastructure
    participant SwiftAPI as Swift Messaging<br/>Conversion API
    participant CPMS as Collateral Pledging<br/>Management System (CPMS)
    participant Eric as Back Office<br/>(Eric's Team)

    rect rgb(60, 140, 100)
        Note over FICC,BNY: Existing automated leg — US Bank does not touch this
        FICC->>BNY: Communicate settled trade
    end

    rect rgb(140, 80, 80)
        Note over BNY,CPMS: Inbound Collateral Messaging — New Build
        BNY->>MQAPI: MT558 Tri-Party Collateral Status<br/>(QCIP encumbrance details)
        MQAPI->>SwiftAPI: Route inbound MT558
        SwiftAPI->>CPMS: Unpack message — update QCIP encumbrance status
        CPMS-->>Eric: Encumbrance reflected — no manual update needed
    end
```

---

## Summary — Story to Flow Mapping

| Story | Phase | Depends On | Can Start |
|---|---|---|---|
| TPP-10569 — MT515 field mapping | Underpins all phases | None | Now |
| TPP-10573 — FICC MQ channel | Track 1 Phases 3 and 4 | None | Now — in parallel with TPP-10569 |
| TPP-10570 — Counterparty FICC Firm ID lookup | Track 1 Phase 2 | TPP-10569 | After TPP-10569 |
| TPP-10574 — BNY DVP download → CPMS upload | Track 1 Phase 1 | TPP-10569 | After TPP-10569 |
| TPP-10571 — MT515 message builder | Track 1 Phase 3 | TPP-10569, TPP-10570 | After TPP-10569 and TPP-10570 |
| TPP-10572 — MT509 response handler | Track 1 Phase 4 | TPP-10571, TPP-10573 | After TPP-10571 and TPP-10573 |
| TPP-10575 — CPMS submission and status UI | Track 1 Phases 2 and 4 | TPP-10569, TPP-10571, TPP-10572, TPP-10574 | Last — after all above |
