-- ============================================================================
-- CPMS Ticket Fix Script - Investigation and Correction
-- Ticket IDs: 867002638, 867002639, 867002640, 867002641
-- CUSIP: 36179WZB7
-- Effective Date: 2026-01-08
-- Issue: Change pledge status from CFRP → UNPLEDGED, Remove invalid safekeeper RCF
-- ============================================================================
-- Author: CPMS Support Team
-- Date: 2026-01-09
-- ============================================================================

SET NOCOUNT ON
GO

DECLARE @Cusip char(9) = '36179WZB7'
DECLARE @EffDt datetime = '2026-01-08'
DECLARE @OldPldgCd varchar(20) = 'CFRP'
DECLARE @NewPldgCd varchar(20) = 'UNPLEDGED'
DECLARE @InvalidSfkpID char(3) = 'RCF'

PRINT '============================================================================'
PRINT 'INVESTIGATION PHASE - Identifying Records to Update'
PRINT '============================================================================'
PRINT ''

-- ============================================================================
-- STEP 1: Find all holdings for this CUSIP
-- ============================================================================
PRINT '--- STEP 1: All Holdings for CUSIP ' + @Cusip + ' ---'
PRINT ''

SELECT
    H.HeldBlk,
    H.Cusip,
    H.SfkpAcctID,
    H.Amt as HoldingAmount,
    H.USB,
    SA.SfkpID,
    SA.SfkpAcct,
    SA.LEID,
    SA.UnPldgCd,
    SA.Active as SfkpAcct_Active
FROM tblHolding H
    INNER JOIN tblSfkpAcct SA ON SA.SfkpAcctID = H.SfkpAcctID
WHERE H.Cusip = @Cusip
ORDER BY H.HeldBlk

PRINT ''
PRINT '--- Holdings Count: ---'
SELECT COUNT(*) as TotalHoldings
FROM tblHolding
WHERE Cusip = @Cusip

PRINT ''
PRINT ''

-- ============================================================================
-- STEP 2: Find current pledge status for this CUSIP
-- ============================================================================
PRINT '--- STEP 2: Current Pledge Details for CUSIP ' + @Cusip + ' ---'
PRINT ''

SELECT
    P.PldgDtlID,
    P.XferID,
    P.HeldBlk,
    H.Cusip,
    P.SfkpPldgCdID,
    SPC.PldgCd,
    SPC.SfkpPldgCd,
    SPC.Active as PldgCd_Active,
    P.PldgDt,
    P.Amt as PledgedAmount,
    P.Pending,
    SA.SfkpID,
    SA.SfkpAcct,
    SA.LEID
FROM tblPldgDtl P
    INNER JOIN tblHolding H ON H.HeldBlk = P.HeldBlk
    INNER JOIN tblSfkpPldgCd SPC ON SPC.SfkpPldgCdID = P.SfkpPldgCdID
    INNER JOIN tblSfkpAcct SA ON SA.SfkpAcctID = SPC.SfkpAcctID
WHERE H.Cusip = @Cusip
    AND P.Pending = 0  -- Only committed pledges
ORDER BY P.PldgDt DESC, P.PldgDtlID

PRINT ''
PRINT '--- Pledge Details Count: ---'
SELECT COUNT(*) as TotalPledges
FROM tblPldgDtl P
    INNER JOIN tblHolding H ON H.HeldBlk = P.HeldBlk
WHERE H.Cusip = @Cusip
    AND P.Pending = 0

PRINT ''
PRINT ''

-- ============================================================================
-- STEP 3: Identify records with CFRP pledge code (to be changed)
-- ============================================================================
PRINT '--- STEP 3: Records with CFRP Pledge Code (TO BE UPDATED) ---'
PRINT ''

SELECT
    P.PldgDtlID,
    P.HeldBlk,
    H.Cusip,
    P.SfkpPldgCdID,
    SPC.PldgCd as CurrentPldgCd,
    SPC.SfkpPldgCd,
    P.PldgDt,
    P.Amt as PledgedAmount,
    SA.SfkpID,
    SA.LEID,
    SA.SfkpAcct
FROM tblPldgDtl P
    INNER JOIN tblHolding H ON H.HeldBlk = P.HeldBlk
    INNER JOIN tblSfkpPldgCd SPC ON SPC.SfkpPldgCdID = P.SfkpPldgCdID
    INNER JOIN tblSfkpAcct SA ON SA.SfkpAcctID = SPC.SfkpAcctID
WHERE H.Cusip = @Cusip
    AND SPC.PldgCd = @OldPldgCd
    AND P.Pending = 0

PRINT ''
PRINT '--- CFRP Records Count: ---'
SELECT COUNT(*) as RecordsToUpdate
FROM tblPldgDtl P
    INNER JOIN tblHolding H ON H.HeldBlk = P.HeldBlk
    INNER JOIN tblSfkpPldgCd SPC ON SPC.SfkpPldgCdID = P.SfkpPldgCdID
WHERE H.Cusip = @Cusip
    AND SPC.PldgCd = @OldPldgCd
    AND P.Pending = 0

PRINT ''
PRINT ''

-- ============================================================================
-- STEP 4: Check for invalid safekeeper (RCF)
-- ============================================================================
PRINT '--- STEP 4: Holdings with Invalid Safekeeper RCF ---'
PRINT ''

SELECT
    H.HeldBlk,
    H.Cusip,
    SA.SfkpID as InvalidSfkpID,
    SA.SfkpAcct,
    SA.LEID,
    SA.Active as IsActive,
    H.Amt as HoldingAmount
FROM tblHolding H
    INNER JOIN tblSfkpAcct SA ON SA.SfkpAcctID = H.SfkpAcctID
WHERE H.Cusip = @Cusip
    AND SA.SfkpID = @InvalidSfkpID

PRINT ''
PRINT '--- Invalid Safekeeper Count: ---'
SELECT COUNT(*) as InvalidSfkpRecords
FROM tblHolding H
    INNER JOIN tblSfkpAcct SA ON SA.SfkpAcctID = H.SfkpAcctID
WHERE H.Cusip = @Cusip
    AND SA.SfkpID = @InvalidSfkpID

PRINT ''
PRINT ''

-- ============================================================================
-- STEP 5: Find available UNPLEDGED pledge codes for each safekeeper account
-- ============================================================================
PRINT '--- STEP 5: Available UNPLEDGED Codes by Safekeeper Account ---'
PRINT ''

SELECT DISTINCT
    SA.SfkpAcctID,
    SA.SfkpID,
    SA.LEID,
    SA.SfkpAcct,
    SPC.SfkpPldgCdID as UnpledgedCodeID,
    SPC.PldgCd,
    SPC.SfkpPldgCd,
    SPC.Active as IsActive
FROM tblSfkpAcct SA
    INNER JOIN tblSfkpPldgCd SPC ON SPC.SfkpAcctID = SA.SfkpAcctID
WHERE SA.SfkpAcctID IN (
    SELECT DISTINCT H.SfkpAcctID
    FROM tblHolding H
    WHERE H.Cusip = @Cusip
)
AND SPC.PldgCd = @NewPldgCd
ORDER BY SA.SfkpID, SA.LEID

PRINT ''
PRINT ''

-- ============================================================================
-- STEP 6: Create comprehensive mapping for the fix
-- ============================================================================
PRINT '--- STEP 6: Detailed Mapping for Fix (Current vs. Target State) ---'
PRINT ''

SELECT
    P.PldgDtlID,
    P.HeldBlk,
    H.Cusip,
    SA.SfkpID,
    SA.LEID,
    SA.SfkpAcct,
    -- Current state
    P.SfkpPldgCdID as Current_SfkpPldgCdID,
    SPC_Current.PldgCd as Current_PldgCd,
    SPC_Current.SfkpPldgCd as Current_SfkpPldgCd,
    -- Target state
    SPC_Target.SfkpPldgCdID as Target_SfkpPldgCdID,
    SPC_Target.PldgCd as Target_PldgCd,
    SPC_Target.SfkpPldgCd as Target_SfkpPldgCd,
    -- Amounts
    P.Amt as PledgedAmount,
    P.PldgDt,
    P.Pending
FROM tblPldgDtl P
    INNER JOIN tblHolding H ON H.HeldBlk = P.HeldBlk
    INNER JOIN tblSfkpPldgCd SPC_Current ON SPC_Current.SfkpPldgCdID = P.SfkpPldgCdID
    INNER JOIN tblSfkpAcct SA ON SA.SfkpAcctID = SPC_Current.SfkpAcctID
    LEFT JOIN tblSfkpPldgCd SPC_Target ON
        SPC_Target.SfkpAcctID = SA.SfkpAcctID AND
        SPC_Target.PldgCd = @NewPldgCd AND
        SPC_Target.Active = 1
WHERE H.Cusip = @Cusip
    AND SPC_Current.PldgCd = @OldPldgCd
    AND P.Pending = 0
ORDER BY P.PldgDtlID

PRINT ''
PRINT ''

-- ============================================================================
-- STEP 7: Verify there are no conflicts or issues
-- ============================================================================
PRINT '--- STEP 7: Pre-Update Validation Checks ---'
PRINT ''

-- Check if any target pledge codes are missing
PRINT 'Missing UNPLEDGED codes check (should return 0):'
SELECT COUNT(*) as MissingUnpledgedCodes
FROM tblPldgDtl P
    INNER JOIN tblHolding H ON H.HeldBlk = P.HeldBlk
    INNER JOIN tblSfkpPldgCd SPC_Current ON SPC_Current.SfkpPldgCdID = P.SfkpPldgCdID
    INNER JOIN tblSfkpAcct SA ON SA.SfkpAcctID = SPC_Current.SfkpAcctID
WHERE H.Cusip = @Cusip
    AND SPC_Current.PldgCd = @OldPldgCd
    AND P.Pending = 0
    AND NOT EXISTS (
        SELECT 1
        FROM tblSfkpPldgCd SPC_Target
        WHERE SPC_Target.SfkpAcctID = SA.SfkpAcctID
            AND SPC_Target.PldgCd = @NewPldgCd
            AND SPC_Target.Active = 1
    )

PRINT ''

-- Check for pending pledges that might interfere
PRINT 'Pending pledges for this CUSIP (should review):'
SELECT COUNT(*) as PendingPledges
FROM tblPldgDtl P
    INNER JOIN tblHolding H ON H.HeldBlk = P.HeldBlk
WHERE H.Cusip = @Cusip
    AND P.Pending = 1

PRINT ''
PRINT ''

-- ============================================================================
-- PAUSE FOR REVIEW
-- ============================================================================
PRINT '============================================================================'
PRINT 'INVESTIGATION COMPLETE'
PRINT '============================================================================'
PRINT ''
PRINT 'Please review the results above before proceeding with the fix.'
PRINT 'Verify:'
PRINT '  1. The correct records have been identified'
PRINT '  2. Target UNPLEDGED codes exist for all affected accounts'
PRINT '  3. No unexpected conflicts or pending pledges'
PRINT ''
PRINT 'If everything looks correct, proceed to the FIX PHASE below.'
PRINT ''
PRINT '============================================================================'
PRINT ''
PRINT ''
PRINT 'Press any key to continue to FIX PHASE, or Ctrl+C to cancel...'
PRINT ''
PRINT '============================================================================'
PRINT ''
PRINT ''

-- Uncomment the lines below to enable the fix after review
/*

-- ============================================================================
-- FIX PHASE - Apply the corrections
-- ============================================================================

BEGIN TRAN

    PRINT '============================================================================'
    PRINT 'FIX PHASE - Applying Updates'
    PRINT '============================================================================'
    PRINT ''

    -- Create temp table to track what we're changing
    SELECT
        P.PldgDtlID,
        P.HeldBlk,
        H.Cusip,
        SA.SfkpID,
        SA.LEID,
        P.SfkpPldgCdID as Old_SfkpPldgCdID,
        SPC_Current.PldgCd as Old_PldgCd,
        SPC_Target.SfkpPldgCdID as New_SfkpPldgCdID,
        SPC_Target.PldgCd as New_PldgCd,
        P.Amt,
        0 as Updated,
        0 as AuditLogged
    INTO #ChangesToApply
    FROM tblPldgDtl P
        INNER JOIN tblHolding H ON H.HeldBlk = P.HeldBlk
        INNER JOIN tblSfkpPldgCd SPC_Current ON SPC_Current.SfkpPldgCdID = P.SfkpPldgCdID
        INNER JOIN tblSfkpAcct SA ON SA.SfkpAcctID = SPC_Current.SfkpAcctID
        INNER JOIN tblSfkpPldgCd SPC_Target ON
            SPC_Target.SfkpAcctID = SA.SfkpAcctID AND
            SPC_Target.PldgCd = @NewPldgCd AND
            SPC_Target.Active = 1
    WHERE H.Cusip = @Cusip
        AND SPC_Current.PldgCd = @OldPldgCd
        AND P.Pending = 0

    PRINT '--- Records to Update: ---'
    SELECT * FROM #ChangesToApply
    PRINT ''

    -- Process each record
    DECLARE @PldgDtlID int, @HeldBlk int, @OldSfkpPldgCdID int, @NewSfkpPldgCdID int
    DECLARE @CurrentSfkpID char(3), @CurrentLEID char(3)
    DECLARE @RowCount int = 0
    DECLARE @ErrorCount int = 0

    DECLARE update_cursor CURSOR FOR
        SELECT PldgDtlID, HeldBlk, Old_SfkpPldgCdID, New_SfkpPldgCdID, SfkpID, LEID
        FROM #ChangesToApply

    OPEN update_cursor

    FETCH NEXT FROM update_cursor
    INTO @PldgDtlID, @HeldBlk, @OldSfkpPldgCdID, @NewSfkpPldgCdID, @CurrentSfkpID, @CurrentLEID

    WHILE @@FETCH_STATUS = 0
    BEGIN
        BEGIN TRY
            -- Update the pledge detail record
            UPDATE tblPldgDtl
            SET SfkpPldgCdID = @NewSfkpPldgCdID
            WHERE PldgDtlID = @PldgDtlID

            IF @@ROWCOUNT > 0
            BEGIN
                -- Mark as updated in temp table
                UPDATE #ChangesToApply
                SET Updated = 1
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

                -- Mark as audit logged
                UPDATE #ChangesToApply
                SET AuditLogged = 1
                WHERE PldgDtlID = @PldgDtlID

                -- Update unpledged horizon table for this HeldBlk
                EXEC procUnPldgHzn @HeldBlk = @HeldBlk

                SET @RowCount = @RowCount + 1

                PRINT 'Updated PldgDtlID: ' + CAST(@PldgDtlID as varchar) +
                      ' (HeldBlk: ' + CAST(@HeldBlk as varchar) +
                      ', ' + @CurrentSfkpID + '/' + @CurrentLEID + ')'
            END
        END TRY
        BEGIN CATCH
            SET @ErrorCount = @ErrorCount + 1
            PRINT 'ERROR updating PldgDtlID: ' + CAST(@PldgDtlID as varchar) +
                  ' - ' + ERROR_MESSAGE()
        END CATCH

        FETCH NEXT FROM update_cursor
        INTO @PldgDtlID, @HeldBlk, @OldSfkpPldgCdID, @NewSfkpPldgCdID, @CurrentSfkpID, @CurrentLEID
    END

    CLOSE update_cursor
    DEALLOCATE update_cursor

    PRINT ''
    PRINT '--- Update Summary: ---'
    PRINT 'Records Updated: ' + CAST(@RowCount as varchar)
    PRINT 'Errors: ' + CAST(@ErrorCount as varchar)
    PRINT ''

    -- Handle invalid safekeeper
    PRINT '--- Deactivating Invalid Safekeeper Accounts (RCF): ---'

    UPDATE SA
    SET Active = 0
    FROM tblSfkpAcct SA
        INNER JOIN tblHolding H ON H.SfkpAcctID = SA.SfkpAcctID
    WHERE H.Cusip = @Cusip
        AND SA.SfkpID = @InvalidSfkpID
        AND SA.Active = 1

    IF @@ROWCOUNT > 0
    BEGIN
        PRINT 'Deactivated ' + CAST(@@ROWCOUNT as varchar) + ' RCF safekeeper account(s)'

        -- Log the deactivation
        EXEC SAuditLog_ISP
            @RowKey = @InvalidSfkpID,
            @UserName = SYSTEM_USER,
            @TableName = 'tblSfkpAcct',
            @FieldName = 'Active',
            @OldValue = '1',
            @NewValue = '0',
            @ChangeType = 'UPDATE'
    END
    ELSE
    BEGIN
        PRINT 'No active RCF safekeeper accounts found to deactivate'
    END

    PRINT ''
    PRINT ''

    -- Verification
    PRINT '--- POST-UPDATE VERIFICATION: ---'
    PRINT ''
    PRINT 'Current pledge status for CUSIP ' + @Cusip + ':'
    SELECT
        P.PldgDtlID,
        P.HeldBlk,
        SPC.PldgCd,
        P.Amt,
        SA.SfkpID,
        SA.LEID
    FROM tblPldgDtl P
        INNER JOIN tblHolding H ON H.HeldBlk = P.HeldBlk
        INNER JOIN tblSfkpPldgCd SPC ON SPC.SfkpPldgCdID = P.SfkpPldgCdID
        INNER JOIN tblSfkpAcct SA ON SA.SfkpAcctID = SPC.SfkpAcctID
    WHERE H.Cusip = @Cusip
        AND P.Pending = 0

    PRINT ''
    PRINT 'Recent audit log entries:'
    SELECT TOP 20 *
    FROM SAuditLog
    WHERE RunDate >= @EffDt
        AND (TableName = 'tblPldgDtl' OR TableName = 'tblSfkpAcct')
    ORDER BY RunDate DESC

    PRINT ''
    PRINT ''
    PRINT '============================================================================'
    PRINT 'FIX COMPLETE'
    PRINT '============================================================================'
    PRINT ''

    IF @ErrorCount = 0
    BEGIN
        PRINT 'All updates completed successfully.'
        PRINT ''
        PRINT 'Review the results above. If everything looks correct:'
        PRINT '  - Uncomment COMMIT TRAN below to save changes'
        PRINT '  - Comment out ROLLBACK TRAN'
        PRINT ''
        PRINT 'Next steps:'
        PRINT '  1. Trigger ETL/refresh for CUSIP ' + @Cusip + ' and date ' + CONVERT(varchar, @EffDt, 120)
        PRINT '  2. Verify LCR reports reflect the changes'
        PRINT '  3. Confirm Web CPMS matches Legacy CPMS'
        PRINT ''
    END
    ELSE
    BEGIN
        PRINT 'WARNING: ' + CAST(@ErrorCount as varchar) + ' error(s) occurred during update.'
        PRINT 'Review errors above and consider rolling back.'
        PRINT ''
    END

    -- Cleanup
    DROP TABLE #ChangesToApply

    -- Decision point
    PRINT '============================================================================'
    PRINT 'TRANSACTION DECISION'
    PRINT '============================================================================'
    PRINT ''

    -- ROLLBACK TRAN  -- Uncomment to discard changes (default for safety)
    -- COMMIT TRAN    -- Uncomment to save changes (only after verification)

    PRINT 'Transaction is still open. Review all output above.'
    PRINT 'Then uncomment either ROLLBACK TRAN or COMMIT TRAN and re-run.'
    PRINT ''

*/

GO
