# Incident Overview: INC30522392

**Generated:** 2026-05-19 17:14:22 UTC

---

## Incident Summary

| Field | Value |
|-------|-------|
| **Incident ID** | INC30522392 |
| **Title** | CPMS issue |
| **Service** | CPMS |
| **Severity** | P4 |
| **Status** | In Progress |
| **Started** | 2026-05-19 10:03:09 UTC |
| **Reported By** | Kurt Nelson |
| **Resolved** | None |
| **Duration** | None |

---

## Description

CPMS / Intrader reconciliation difference discovered on 5/18/2026.

Issue: A $16,200,000 difference exists between CPMS Web and Intrader for NMO securities.

Key Details:
- CUSIP: 3133889F9 (FHLB STOCK - SAN FRANCISCO)
- Ticket: 867004812
- Amount: $16,200,000.00
- Category: NMO (Non-Marketable Obligations)
- Impact: NMO securities are excluded from LCR reporting, so immediate urgency is lower

The movement occurred on 05/18/26 and was picked up in Intrader but not reflected in CPMS web version. The two systems should be in sync.

---

## Timeline

05/15/2026 - Position movement in Intrader: 16,200,000.00 DEL from FHL location for ticket 867104401

05/18/2026 - Reconciliation performed, difference identified between CPMS and Intrader

05/19/2026 07:00 - Email notification sent by Corinne Yerigan O'Neil to Diana Yang and Parshwa Shah
  - Reported $16.2M difference in NMO category
  - CPMS_NMO showing $1,743,334,600.00
  - Intrader_NMO showing $1,727,134,600.00
  - Difference: $16,200,000.00
  
05/19/2026 10:03 - Incident INC30522392 opened by Kurt Nelson

Intrader Position Details:
- Entity: 300, Portfolio: 100FHSTK
- Original Face: $25,650,000.00
- Current Face: $25,650,000.00
- Position locations: FHL (-$16,200,000), HSF ($41,850,000)
- Latest movement: 05/18/26 DEL from FHL location

---

## Technical Details

### Affected Systems
- **Primary System:** CPMS (Collateral Portfolio Management System) Web
- **Secondary System:** Intrader
- **Issue Type:** Data Synchronization / Reconciliation

### Impact Assessment
- **Financial Impact:** $16,200,000 discrepancy
- **Security Type:** CUSIP 3133889F9 (FHLB Stock - San Francisco)
- **Ticket Number:** 867004812
- **Category:** NMO (Non-Marketable Obligations)
- **Business Impact:** LOW - NMO securities are excluded from LCR reporting

### Data Analysis

**CPMS Values:**
- NMO Total: $1,743,334,600.00

**Intrader Values:**
- NMO Total: $1,727,134,600.00

**Discrepancy:**
- Amount: $16,200,000.00
- Direction: CPMS showing higher value than Intrader

**Position Details (CUSIP 3133889F9):**
- Original Face: $25,650,000.00
- Current Face: $25,650,000.00
- Fair Value: $25,650,000.00
- Maturity: 12/31/2050

**Intrader Position Locations:**
- FHL: -$16,200,000.00
- HSF: $41,850,000.00
- Net Position: $25,650,000.00

---

## Root Cause Analysis



---

## Resolution



---

## Follow-up Actions



---

## Related Incidents



### Historical Context - Similar CPMS Issues

**INC9659470** (Sep 2025) - CPMS issue
- Root Cause: Process Failure - Citrix servers were down
- Resolution: Worked with Citrix server admin to bring servers back up

**INC8202881** (Aug 2025) - CPMS Pledging data is incorrect
- Root Cause: Process Failure
- Resolution: Swapped ticket allocations on CUSIP to match correct amounts

**INC8173092** (Aug 2025) - CPMS authentication issue
- Root Cause: Configuration Settings
- Resolution: Change CHG0855094 completed to resolve ForgeRock authentication

---

## Contact Information

**Reported By:** Corinne M Yerigan O'Neil, CFA
- Title: Vice President | Finance Director — Collateral Optimization/Derivatives Middle Office
- Email: corinne.oneil@usbank.com
- Phone: O: 612-303-4152 | M: 612-867-6953

**Notified:**
- Diana N Yang
- Parshwa Shah

**CC:**
- Manos Pytikakis
- Dennis Plotkin

---

## Investigation Checklist

- [ ] Verify position movement in Intrader system
- [ ] Check CPMS sync job logs for failures
- [ ] Review data feed between Intrader and CPMS
- [ ] Confirm FHL location movement was processed correctly
- [ ] Check for similar discrepancies in other securities
- [ ] Verify reconciliation process is functioning correctly
- [ ] Contact CPMS support team if sync issue identified
- [ ] Manual data correction if needed
- [ ] Test reconciliation after fix
- [ ] Document root cause and prevention measures

---

## Attachments Referenced

1. **CPMS_Intrader_Difference_2026-05-18.md** - Detailed reconciliation report with position data
2. image001.png - Reconciliation Summary showing $16.2M difference
3. image002.png - Position Detail for CUSIP 3133889F9
4. image003.png - Intrader Position Detail and Movement History

---

## Notes

This incident involves a reconciliation discrepancy between CPMS Web and Intrader systems. The position movement occurred on 05/15/26 in Intrader but was not reflected in CPMS, discovered during the 05/18/26 reconciliation. 

The issue is classified as lower urgency because NMO securities are excluded from LCR (Liquidity Coverage Ratio) reporting, reducing immediate regulatory impact. However, data integrity between systems should be maintained for accurate financial reporting.

---

*Document generated by Incident Assistant v4*
