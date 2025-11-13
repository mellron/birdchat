# TPP-9378 Investigation Summary
## Investigate Collateral Charges Calculations for Negative Balances (Legacy CPMS)

**Date**: 2025-11-12
**Investigator**: Doug Tolley
**Sprint**: 2025 TPP OPI Sprint 18
**Story Points**: 5

---

## Objective

Determine whether collateral charges calculations are impacted by negative balances, similar to the issue found in FDIC calculations (TPP-9134). Identify any required changes based on SSIS packages for Daily and Monthly processing.

---

## Background - Related FDIC Issue (TPP-9134)

The investigation stems from **TPP-9134**, which identified a problem with FDIC calculation logic:
- **Issue**: Negative account balances were incorrectly reducing FDIC coverage for other customers in pooled accounts
- **Root Cause**: Logic was calculating "up to 250,000" instead of "between 0 and 250,000"
- **Impact**: Negative balances in one account affected calculations for all accounts in the pool

**Key Question**: Does similar logic exist in collateral charges calculations?

---

## System Components Analyzed

### 1. SSIS Package
**File**: `SSIS/CPMSExportCollateralCharges.dtsx`

**Key Operations**:
- Executes stored procedure: `procGetCollateralCharges`
- Inserts results into table: `tblCollateralChargesMRO`
- Exports data to MRO file for downstream processing

### 2. Export Stored Procedure
**Procedure**: `procGetCollateralCharges`
**Location**: `cpmsdatabase.sql:14458-14515`

**Purpose**: Extracts collateral charges data for export (does NOT perform calculations)

**Key Columns Exported**:
- `CollateralBalance` = `A.PldgAmt` from `tblCollChrgByAcct`
- `CollateralCharge` = `A.Amt` from `tblCollChrgByAcct`

**Note**: This procedure simply reads and formats data - the actual calculations happen elsewhere.

### 3. Calculation Stored Procedure (CRITICAL)
**Procedure**: `procCreateCollChrgAcctDaily`
**Location**: `cpmsdatabase.sql:12881-13550` (approximate)

**Purpose**: Performs the actual collateral charges calculations and populates `tblCollChrgByAcct`

---

## Critical Finding: INCONSISTENT HANDLING OF NEGATIVE BALANCES

### Evidence of Issue

The stored procedure `procCreateCollChrgAcctDaily` has **inconsistent handling** of negative balances across different calculation steps:

#### CORRECTLY FILTERED (Negative Balances Excluded)

1. **Line 13140-13145**: Calculation of `SumMEBalByPldgCd`
   ```sql
   (Select Sum(CASE WHEN Month_End_Bal > 0.0 THEN Month_End_Bal ELSE 0.0 END )
       FROM tblCollChrgAllocByAcctHistory C2
       Where C1.PldgCd=C2.PldgCd
       and C1.AsOfDate=C2.AsOfDate
       GROUP by C2.PldgCd, C2.AsOfDate) as SumMEBalByPldgCd
   ```
   **Result**: Only positive balances are summed

2. **Line 13150**: First percentage calculation
   ```sql
   Update TAcctHistory set CollChrgPct=CASE
       WHEN Month_End_Bal>0.0 Then Month_End_Bal/SumMEBalByPldgCd
       else 0.0
   END
   ```
   **Result**: Negative balances get 0% allocation

3. **Line 13209**: Population of `TDailyChrg` table
   ```sql
   ,CASE WHEN C1.Month_End_Bal > 0.0 THEN C1.Month_End_Bal ELSE 0.0 END as Month_End_Bal
   ```
   **Result**: Negative balances set to 0.0

#### POTENTIALLY PROBLEMATIC (Negative Balances NOT Filtered)

1. **Line 13138**: Population of `TAcctHistory.Month_End_Bal`
   ```sql
   ,C1.Month_End_Bal  -- Copied directly from source, NO FILTERING
   ```
   **Problem**: Can include negative values

2. **Line 13385**: Calculation of `MaxBalance`
   ```sql
   "Balance" = MAX(H1.Month_End_Bal)  -- Uses UNFILTERED values
   ```
   **Problem**: If all balances are negative, MAX returns "least negative" (still negative)

3. **Line 13401**: Calculation of `MaxBalanceTotal`
   ```sql
   "Total" = SUM(MaxBalance)  -- Sums potentially negative MaxBalance values
   ```
   **Problem**: Negative MaxBalance values reduce the total for the entire pool

4. **Lines 13407-13409**: Final percentage calculation with caps
   ```sql
   CollChrgPct=CASE
       When ISNULL(MaxBalanceTotal, 0.0) = 0.0 Then 0.0
       when MaxBalance/MaxBalanceTotal >= 100 then 99.99999999
       when MaxBalance/MaxBalanceTotal <= -100 then -99.99999999
       else MaxBalance/MaxBalanceTotal
   END
   ```
   **Problem**: While caps prevent extreme values, negative MaxBalance values still affect MaxBalanceTotal

---

## How the Issue Manifests

### Scenario: Pooled Accounts with Negative Balance

**Example Pool**:
- Account A: $100,000 (positive)
- Account B: $50,000 (positive)
- Account C: -$20,000 (negative)

### Current Behavior (UNFILTERED MaxBalance calculation):

1. **MaxBalance values**:
   - Account A: $100,000
   - Account B: $50,000
   - Account C: -$20,000

2. **MaxBalanceTotal** = $100,000 + $50,000 + (-$20,000) = **$130,000**

3. **Percentage Allocations**:
   - Account A: $100,000 / $130,000 = 76.92%
   - Account B: $50,000 / $130,000 = 38.46%
   - Account C: -$20,000 / $130,000 = -15.38%

### Expected Behavior (IF negative balances should be excluded):

1. **MaxBalance values** (filtered):
   - Account A: $100,000
   - Account B: $50,000
   - Account C: $0 (negative filtered to zero)

2. **MaxBalanceTotal** = $100,000 + $50,000 + $0 = **$150,000**

3. **Percentage Allocations**:
   - Account A: $100,000 / $150,000 = 66.67%
   - Account B: $50,000 / $150,000 = 33.33%
   - Account C: $0 / $150,000 = 0%

### Impact

- Accounts with **positive balances get OVER-ALLOCATED** charges (76.92% vs 66.67%)
- Accounts with **negative balances get NEGATIVE** charge allocations
- Similar to TPP-9134 FDIC issue: negative balances affect all accounts in the pool

---

## Key Code Sections to Review

### 1. TAcctHistory Population (Lines 13122-13148)
- **File**: `cpmsdatabase.sql`
- **Issue**: Month_End_Bal copied without filtering negative values

### 2. MaxBalance Calculation (Lines 13383-13391)
- **File**: `cpmsdatabase.sql`
- **Issue**: Uses unfiltered Month_End_Bal from TAcctHistory

### 3. MaxBalanceTotal Calculation (Lines 13398-13402)
- **File**: `cpmsdatabase.sql`
- **Issue**: Sums MaxBalance values that may include negatives

### 4. CollChrgPct Calculation (Lines 13404-13410)
- **File**: `cpmsdatabase.sql`
- **Issue**: Uses MaxBalance/MaxBalanceTotal which may include negative values

---

## Comments in Code Suggesting Negative Balance Handling

**Lines 13115-13119**:
```sql
/*************************************************************************************
*   Redo tblCollChrgAllocByAcctHistory to remove accounts
*   with negative balances, since we do not assign charges to those accounts
*   and to set each daily balance to the high-water mark within that interval
*************************************************************************************/
```

**Analysis**: The comment explicitly states that accounts with negative balances should NOT be assigned charges. However, the MaxBalance calculation does NOT implement this filtering.

---

## Historical Context from Code Comments

**Relevant modifications** related to negative balance handling:

- **09/01/2017 - TJH**: Changed CollChrgPct case statement to set to 99.99999999 when MaxBalance/MaxBalanceTotal > 100 and -99.99999999 when MaxBalance/MaxBalanceTotal < -100
- **09/08/2017 - TJH**: Update to CollChrgPct case statement to handle values equal to 100 or -100

**Implication**: These changes acknowledge that negative percentages CAN occur, suggesting negative balances ARE making it into the calculation.

---

## Questions for Further Investigation

1. **Business Logic Clarification**:
   - Should negative balances be completely excluded from MaxBalance calculations?
   - Should negative balance accounts receive 0% allocation or negative allocation?
   - Is there a legitimate business case for negative allocations?

2. **Data Analysis**:
   - Are there currently accounts with negative balances in `tblCollChrgAllocByAcctHistory`?
   - What percentage of pools contain accounts with negative balances?
   - What is the typical magnitude of negative balances when they occur?

3. **Impact Assessment**:
   - How many accounts/customers are affected by this issue?
   - What is the dollar impact of the over/under allocation?
   - Are there regulatory or compliance implications?

4. **Comparison with FDIC Fix**:
   - What was the exact fix applied for TPP-9134?
   - Can a similar approach be applied to collateral charges?
   - Are there other calculation routines with similar issues?

---

## Related Database Objects

### Tables
- `tblCollChrgByAcct` - Final collateral charges by account (output)
- `tblCollChrgAllocByAcctHistory` - Historical allocation data (input)
- `tblCollateralChargesMRO` - Data staged for MRO export
- `TAcctHistory` - Temp table used in calculations
- `TDailyChrg` - Temp table for daily charges
- `TDailyPldgMkt` - Temp table for daily pledge market values

### Stored Procedures
- `procCreateCollChrgAcctDaily` - Main calculation procedure
- `procGetCollateralCharges` - Export procedure
- `procUpdateCollChrgAcctPct` - Updates collateral charge percentages
- `procSaveAcctHistory` - Saves account history

---

## Recommended Next Steps

### Immediate Actions

1. **Confirm Issue Exists**:
   - Query `tblCollChrgAllocByAcctHistory` for records with `Month_End_Bal < 0`
   - Check if these negative balances are flowing through to MaxBalance calculations
   - Review recent MRO export files for accounts with negative charges

2. **Quantify Impact**:
   - Count affected accounts and pools
   - Calculate dollar amount of over/under allocated charges
   - Identify customers with largest discrepancies

3. **Stakeholder Consultation**:
   - Confirm business requirements with Collateral team
   - Review with MRO to understand downstream impact
   - Consult with Tom Stenson (commented on ticket asking for guidance)

### Design Phase (TPP-9379)

If issue is confirmed, design solution similar to FDIC fix:

**Option 1**: Filter negative balances in MaxBalance calculation
```sql
-- Line 13385 - Change from:
"Balance" = MAX(H1.Month_End_Bal)
-- To:
"Balance" = MAX(CASE WHEN H1.Month_End_Bal > 0.0 THEN H1.Month_End_Bal ELSE 0.0 END)
```

**Option 2**: Exclude negative balance accounts entirely from calculations
```sql
-- Add WHERE clause to filter out negative balances
WHERE Month_End_Bal > 0.0
```

### Development Phase (TPP-9380)

- Implement approved design changes
- Update both Daily and Monthly processes if needed
- Ensure consistent handling across all calculation steps

### Testing Phase (TPP-9381)

- Create test cases with:
  - All positive balances (baseline)
  - Mix of positive and negative balances
  - All negative balances for a pool
  - Zero balances
- Compare old vs new calculation results
- Validate MRO export file format unchanged

---

## Additional Notes

- The SSIS package `CPMSMrgTblMonthlyProcess.dtsx` may also need investigation for monthly processing
- Consider reviewing other calculation routines for similar patterns
- Historical modifications (2017) suggest awareness of negative values but no root cause fix

---

## References

- **JIRA Ticket**: TPP-9378
- **Related Ticket**: TPP-9134 (FDIC Calculation Issue)
- **Collaborators**: Tatiana Glistvain (tmkaras)
- **Requestor**: Parshwa Shah (b118809)

---

## Investigation Status

- [x] Located SSIS packages
- [x] Identified stored procedures
- [x] Analyzed calculation logic
- [x] Documented potential issue with negative balances
- [ ] Confirmed issue with actual data
- [ ] Quantified impact
- [ ] Designed solution
- [ ] Obtained stakeholder approval

---

**End of Investigation Summary**
