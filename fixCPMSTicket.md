# CPMS Ticket Fix Documentation

## Ticket Overview

**Ticket IDs:** 867002638, 867002639, 867002640, 867002641
**CUSIP:** 36179WZB7
**Effective Date:** 2026-01-08
**Required Changes:**
- Change pledge status from CFRP → UNPLEDGED
- Remove invalid safekeeper (RCF)
- Log changes in audit table for compliance

## Database Schema Reference

### Key Tables Involved

1. **tblHolding** - Holdings records
   - `HeldBlk` (int, IDENTITY) - Unique held block identifier
   - `Cusip` (char(9)) - Security CUSIP
   - `SfkpAcctID` (int) - Safekeeper account ID
   - `Amt` (money) - Amount held

2. **tblPldgDtl** - Pledge details
   - `XferID` (int) - Transfer ID (0 for transferless pledges)
   - `HeldBlk` (int) - Reference to tblHolding
   - `SfkpPldgCdID` (int) - Reference to tblSfkpPldgCd
   - `PldgDt` (datetime) - Pledge date
   - `Amt` (money) - Pledged amount
   - `Pending` (bit) - Whether pledge is pending (0 = committed)

3. **tblSfkpPldgCd** - Safekeeper pledge codes
   - `SfkpPldgCdID` (int, IDENTITY) - Unique identifier
   - `SfkpAcctID` (int) - Safekeeper account reference
   - `PldgCd` (varchar) - Pledge code (e.g., 'CFRP', 'UNPLEDGED')
   - `SfkpPldgCd` (varchar(10)) - Combined safekeeper + pledge code
   - `Active` (bit) - Whether this pledge code is active

4. **tblSfkpAcct** - Safekeeper accounts
   - `SfkpAcctID` (int, IDENTITY) - Unique identifier
   - `SfkpID` (char(3)) - Safekeeper ID (e.g., 'RCF')
   - `LEID` (char(3)) - Legal entity ID
   - `SfkpAcct` (varchar(10)) - Safekeeper account number
   - `UnPldgCd` (varchar(10)) - Unpledged code
   - `Active` (bit) - Whether account is active

5. **SAuditLog** - Audit trail
   - `IID` (int, IDENTITY) - Unique identifier
   - `RowKey` (varchar(50)) - Key identifying the row changed
   - `UserName` (varchar(20)) - User making the change
   - `TableName` (varchar(50)) - Table being modified
   - `FieldName` (varchar(100)) - Field being modified
   - `OldValue` (varchar(255)) - Previous value
   - `NewValue` (varchar(255)) - New value
   - `ChangeType` (varchar(12)) - Type of change (UPDATE, INSERT, DELETE)
   - `RunDate` (datetime) - When change was made

## SQL Fix Pattern

### Step-by-Step Approach

```sql
-- ============================================================================
-- CPMS Pledge Status Fix for Tickets: 867002638, 867002639, 867002640, 867002641
-- CUSIP: 36179WZB7
-- Date: 2026-01-08
-- ============================================================================

-- Set variables
DECLARE @Cusip char(9) = '36179WZB7'
DECLARE @EffDt datetime = '2026-01-08'
DECLARE @OldPldgCd varchar(20) = 'CFRP'
DECLARE @NewPldgCd varchar(20) = 'UNPLEDGED'
DECLARE @InvalidSfkpID char(3) = 'RCF'

BEGIN TRAN

-- ============================================================================
-- STEP 1: Identify affected HeldBlk records
-- ============================================================================
SELECT
    H.HeldBlk,
    H.Cusip,
    H.SfkpAcctID,
    SA.SfkpID,
    SA.LEID,
    H.Amt as HoldingAmt,
    P.PldgDtlID,
    P.SfkpPldgCdID,
    SPC.PldgCd,
    P.PldgDt,
    P.Amt as PledgedAmt
INTO #AffectedRecords
FROM tblHolding H
    INNER JOIN tblSfkpAcct SA ON SA.SfkpAcctID = H.SfkpAcctID
    LEFT JOIN tblPldgDtl P ON P.HeldBlk = H.HeldBlk AND P.Pending = 0
    LEFT JOIN tblSfkpPldgCd SPC ON SPC.SfkpPldgCdID = P.SfkpPldgCdID
WHERE
    H.Cusip = @Cusip
    AND (SPC.PldgCd = @OldPldgCd OR SA.SfkpID = @InvalidSfkpID)

-- Review what will be changed
SELECT * FROM #AffectedRecords

-- ============================================================================
-- STEP 2: Get the correct SfkpPldgCdID for UNPLEDGED status
-- ============================================================================
DECLARE @NewSfkpPldgCdID int

-- Find the correct UNPLEDGED pledge code for each affected record
-- This may vary by SfkpAcctID and LEID
-- Example for a specific case:
SELECT TOP 1 @NewSfkpPldgCdID = SPC.SfkpPldgCdID
FROM #AffectedRecords AR
    INNER JOIN tblSfkpPldgCd SPC ON
        SPC.SfkpAcctID = AR.SfkpAcctID AND
        SPC.PldgCd = @NewPldgCd
WHERE SPC.Active = 1

-- ============================================================================
-- STEP 3: Update pledge status from CFRP to UNPLEDGED
-- ============================================================================
-- Create cursor to handle each record individually for proper audit logging
DECLARE @HeldBlk int, @OldSfkpPldgCdID int, @PldgDtlID int

DECLARE pledge_cursor CURSOR FOR
    SELECT HeldBlk, SfkpPldgCdID, PldgDtlID
    FROM #AffectedRecords
    WHERE PldgCd = @OldPldgCd

OPEN pledge_cursor

FETCH NEXT FROM pledge_cursor INTO @HeldBlk, @OldSfkpPldgCdID, @PldgDtlID

WHILE @@FETCH_STATUS = 0
BEGIN
    -- Update the pledge detail
    UPDATE tblPldgDtl
    SET SfkpPldgCdID = @NewSfkpPldgCdID
    WHERE PldgDtlID = @PldgDtlID

    -- Log the change in audit table
    EXEC SAuditLog_ISP
        @RowKey = @PldgDtlID,
        @UserName = SYSTEM_USER,
        @TableName = 'tblPldgDtl',
        @FieldName = 'SfkpPldgCdID',
        @OldValue = @OldPldgCd,
        @NewValue = @NewPldgCd,
        @ChangeType = 'UPDATE'

    -- Update unpledged horizon table for this HeldBlk
    EXEC procUnPldgHzn @HeldBlk = @HeldBlk

    FETCH NEXT FROM pledge_cursor INTO @HeldBlk, @OldSfkpPldgCdID, @PldgDtlID
END

CLOSE pledge_cursor
DEALLOCATE pledge_cursor

-- ============================================================================
-- STEP 4: Handle invalid safekeeper (RCF)
-- ============================================================================
-- Option 1: Deactivate invalid safekeeper accounts
UPDATE tblSfkpAcct
SET Active = 0
WHERE SfkpID = @InvalidSfkpID
    AND Active = 1

-- Log the safekeeper deactivation
EXEC SAuditLog_ISP
    @RowKey = @InvalidSfkpID,
    @UserName = SYSTEM_USER,
    @TableName = 'tblSfkpAcct',
    @FieldName = 'Active',
    @OldValue = '1',
    @NewValue = '0',
    @ChangeType = 'UPDATE'

-- Option 2: Deactivate specific pledge codes for invalid safekeeper
UPDATE tblSfkpPldgCd
SET Active = 0
WHERE SfkpAcctID IN (
    SELECT SfkpAcctID
    FROM tblSfkpAcct
    WHERE SfkpID = @InvalidSfkpID
)
AND Active = 1

-- ============================================================================
-- STEP 5: Verification queries
-- ============================================================================
-- Verify the changes
SELECT
    H.HeldBlk,
    H.Cusip,
    SA.SfkpID,
    SPC.PldgCd,
    P.PldgDt,
    P.Amt
FROM tblHolding H
    INNER JOIN tblSfkpAcct SA ON SA.SfkpAcctID = H.SfkpAcctID
    LEFT JOIN tblPldgDtl P ON P.HeldBlk = H.HeldBlk AND P.Pending = 0
    LEFT JOIN tblSfkpPldgCd SPC ON SPC.SfkpPldgCdID = P.SfkpPldgCdID
WHERE H.Cusip = @Cusip

-- Check audit log
SELECT *
FROM SAuditLog
WHERE RunDate >= @EffDt
    AND (TableName = 'tblPldgDtl' OR TableName = 'tblSfkpAcct')
ORDER BY RunDate DESC

-- ============================================================================
-- STEP 6: Commit or Rollback
-- ============================================================================
-- Review all results above before committing
-- COMMIT TRAN
-- or
-- ROLLBACK TRAN

-- Cleanup
DROP TABLE #AffectedRecords
```

## Post-Fix Actions

### 1. Re-sync LCR Reporting
After the database fix is complete:
- Trigger ETL or refresh for CUSIP 36179WZB7 and date 2026-01-08
- Ensure downstream reporting systems pick up the changes

### 2. Validation
- Confirm Web CPMS now matches Legacy CPMS (UNPLEDGED status)
- Verify LCR reports reflect the corrected pledge status
- Check that collateral charges are recalculated correctly

### 3. Prevention Measures
- **Add validation rules** for safekeeper codes to block or auto-correct invalid ones
- **Improve reconciliation alerts** between Web and Legacy CPMS
- **Document valid safekeeper codes** and maintain a reference list
- **Implement pre-commit validation** to prevent invalid safekeepers from being entered

## Important Notes

1. **Always run in a transaction** - Use BEGIN TRAN and verify results before COMMIT
2. **Test in lower environment first** - Run the fix in DEV/IT before PROD
3. **Backup before changes** - Ensure database backup is current
4. **Document ticket IDs** - The ticket numbers (867002638, etc.) may need to be linked to HeldBlk IDs through application logs
5. **Coordinate with ETL team** - LCR reporting sync must happen after database fix
6. **Monitor downstream systems** - Check reports and dependent systems after fix

## Stored Procedures Referenced

- **SAuditLog_ISP** - Inserts audit log entries
  - Parameters: @RowKey, @UserName, @TableName, @FieldName, @OldValue, @NewValue, @ChangeType

- **procUnPldgHzn** - Updates unpledged horizon calculation table
  - Can be called with @HeldBlk, @Cusip, or @XferID parameter

## Related Procedures

Other procedures that may be relevant:
- `UpdateXferPldgList` - Updates pledge amounts for transfers
- `procGetHeldBlk` - Gets HeldBlk ID for a Cusip/Safekeeper/LE combination
- Various pledge management procedures that call `procUnPldgHzn` after modifications
