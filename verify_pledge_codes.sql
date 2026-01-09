-- ============================================================================
-- Verify Pledge Codes in Database
-- ============================================================================
-- This script helps identify the correct pledge code values to use in the fix
-- ============================================================================

SET NOCOUNT ON
GO

DECLARE @Cusip char(9) = '36179WZB7'
DECLARE @InvalidSfkpID char(3) = 'RCF'

PRINT '============================================================================'
PRINT 'PLEDGE CODE VERIFICATION'
PRINT '============================================================================'
PRINT ''

-- ============================================================================
-- 1. Show all unique pledge codes in the system
-- ============================================================================
PRINT '--- All Pledge Codes in tblSfkpPldgCd: ---'
PRINT ''

SELECT DISTINCT
    PldgCd,
    COUNT(*) as UsageCount,
    SUM(CASE WHEN Active = 1 THEN 1 ELSE 0 END) as ActiveCount,
    SUM(CASE WHEN Active = 0 THEN 1 ELSE 0 END) as InactiveCount
FROM tblSfkpPldgCd
GROUP BY PldgCd
ORDER BY PldgCd

PRINT ''
PRINT ''

-- ============================================================================
-- 2. Show pledge codes currently used for this CUSIP
-- ============================================================================
PRINT '--- Pledge Codes Currently Used for CUSIP ' + @Cusip + ': ---'
PRINT ''

SELECT DISTINCT
    SPC.PldgCd,
    SPC.SfkpPldgCd,
    COUNT(DISTINCT P.PldgDtlID) as PledgeCount,
    SUM(P.Amt) as TotalAmount,
    SA.SfkpID,
    SA.LEID
FROM tblHolding H
    INNER JOIN tblPldgDtl P ON P.HeldBlk = H.HeldBlk
    INNER JOIN tblSfkpPldgCd SPC ON SPC.SfkpPldgCdID = P.SfkpPldgCdID
    INNER JOIN tblSfkpAcct SA ON SA.SfkpAcctID = SPC.SfkpAcctID
WHERE H.Cusip = @Cusip
    AND P.Pending = 0
GROUP BY SPC.PldgCd, SPC.SfkpPldgCd, SA.SfkpID, SA.LEID
ORDER BY SPC.PldgCd, SA.SfkpID

PRINT ''
PRINT ''

-- ============================================================================
-- 3. Search for pledge codes that might mean "unpledged"
-- ============================================================================
PRINT '--- Pledge Codes that might represent UNPLEDGED status: ---'
PRINT ''

SELECT DISTINCT
    PldgCd,
    COUNT(*) as TotalRecords,
    SUM(CASE WHEN Active = 1 THEN 1 ELSE 0 END) as ActiveRecords
FROM tblSfkpPldgCd
WHERE PldgCd LIKE '%UNPLEDG%'
    OR PldgCd LIKE '%UNPLDG%'
    OR PldgCd LIKE '%UN%'
    OR PldgCd LIKE '%NONE%'
    OR PldgCd LIKE '%FREE%'
    OR PldgCd = 'U'
    OR PldgCd = 'N'
    OR PldgCd = ''
GROUP BY PldgCd
ORDER BY PldgCd

PRINT ''
PRINT ''

-- ============================================================================
-- 4. Show pledge codes used in TicketDtl for these specific tickets
-- ============================================================================
PRINT '--- Pledge Codes for Tickets 867002638, 867002639, 867002640, 867002641: ---'
PRINT ''

DECLARE @Ticket1 char(9) = '867002638'
DECLARE @Ticket2 char(9) = '867002639'
DECLARE @Ticket3 char(9) = '867002640'
DECLARE @Ticket4 char(9) = '867002641'

SELECT
    TH.Ticket,
    SPC.PldgCd,
    SPC.SfkpPldgCd,
    SPC.Active,
    COUNT(*) as RecordCount,
    SUM(TD.Amt) as TotalAmount,
    SA.SfkpID,
    SA.LEID
FROM TicketHolding TH
    INNER JOIN tblSfkpAcct SA ON SA.SfkpAcctID = TH.SfkpAcctID
    INNER JOIN TicketDtl TD ON TD.TicketHeldBlkId = TH.TicketHeldBlk
    INNER JOIN tblSfkpPldgCd SPC ON SPC.SfkpPldgCdId = TD.SfkpPldgCdId
WHERE TH.Ticket IN (@Ticket1, @Ticket2, @Ticket3, @Ticket4)
    AND TD.Pending = 0
GROUP BY TH.Ticket, SPC.PldgCd, SPC.SfkpPldgCd, SPC.Active, SA.SfkpID, SA.LEID
ORDER BY TH.Ticket, SPC.PldgCd

PRINT ''
PRINT ''

-- ============================================================================
-- 5. Show UnPldgCd from tblSfkpAcct (the unpledged code per safekeeper)
-- ============================================================================
PRINT '--- Unpledged Codes from tblSfkpAcct (UnPldgCd field): ---'
PRINT ''

SELECT DISTINCT
    SA.SfkpID,
    SA.LEID,
    SA.UnPldgCd,
    SA.Active,
    COUNT(*) as AccountCount
FROM tblSfkpAcct SA
WHERE SA.UnPldgCd IS NOT NULL AND SA.UnPldgCd <> ''
GROUP BY SA.SfkpID, SA.LEID, SA.UnPldgCd, SA.Active
ORDER BY SA.SfkpID, SA.LEID

PRINT ''
PRINT ''

-- ============================================================================
-- 6. Show safekeepers and their unpledged codes for this CUSIP
-- ============================================================================
PRINT '--- Safekeepers for CUSIP ' + @Cusip + ' and their Unpledged Codes: ---'
PRINT ''

SELECT DISTINCT
    SA.SfkpAcctID,
    SA.SfkpID,
    SA.LEID,
    SA.SfkpAcct,
    SA.UnPldgCd as UnpledgedCodeFromAccount,
    SA.Active as Account_Active
FROM tblHolding H
    INNER JOIN tblSfkpAcct SA ON SA.SfkpAcctID = H.SfkpAcctID
WHERE H.Cusip = @Cusip
ORDER BY SA.SfkpID, SA.LEID

PRINT ''
PRINT ''

-- ============================================================================
-- 7. Find available UNPLEDGED pledge codes for safekeepers holding this CUSIP
-- ============================================================================
PRINT '--- Available Pledge Codes matching UnPldgCd for this CUSIP: ---'
PRINT ''

SELECT
    SA.SfkpID,
    SA.LEID,
    SA.UnPldgCd,
    SPC.SfkpPldgCdID,
    SPC.PldgCd,
    SPC.SfkpPldgCd,
    SPC.Active,
    'Use this SfkpPldgCdID for unpledging' as Recommendation
FROM tblHolding H
    INNER JOIN tblSfkpAcct SA ON SA.SfkpAcctID = H.SfkpAcctID
    LEFT JOIN tblSfkpPldgCd SPC ON
        SPC.SfkpAcctID = SA.SfkpAcctID AND
        SPC.PldgCd = SA.UnPldgCd
WHERE H.Cusip = @Cusip
ORDER BY SA.SfkpID, SA.LEID

PRINT ''
PRINT ''

-- ============================================================================
-- 8. Check if 'UNPLEDGED' literal exists in the database
-- ============================================================================
PRINT '--- Does literal UNPLEDGED exist as a pledge code? ---'
PRINT ''

IF EXISTS (SELECT 1 FROM tblSfkpPldgCd WHERE PldgCd = 'UNPLEDGED')
BEGIN
    PRINT 'YES - UNPLEDGED pledge code exists'
    PRINT ''
    SELECT
        SfkpPldgCdID,
        SfkpAcctID,
        PldgCd,
        SfkpPldgCd,
        Active
    FROM tblSfkpPldgCd
    WHERE PldgCd = 'UNPLEDGED'
END
ELSE
BEGIN
    PRINT 'NO - UNPLEDGED pledge code does NOT exist'
    PRINT ''
    PRINT 'The correct unpledged code may be different.'
    PRINT 'Check the UnPldgCd field in tblSfkpAcct above.'
    PRINT 'Common alternatives: U, UN, NONE, or empty string'
END

PRINT ''
PRINT ''

-- ============================================================================
-- 9. Specific check: Do the tickets have access to an unpledged code?
-- ============================================================================
PRINT '--- Can the ticket safekeepers use an UNPLEDGED code? ---'
PRINT ''

SELECT
    TH.Ticket,
    SA.SfkpID,
    SA.LEID,
    SA.UnPldgCd as Account_UnPldgCd,
    CASE
        WHEN EXISTS (
            SELECT 1 FROM tblSfkpPldgCd SPC2
            WHERE SPC2.SfkpAcctID = SA.SfkpAcctID
                AND SPC2.PldgCd = SA.UnPldgCd
                AND SPC2.Active = 1
        ) THEN 'YES - Can use: ' + SA.UnPldgCd
        ELSE 'NO - Missing unpledged code'
    END as CanUnpledge,
    (SELECT TOP 1 SfkpPldgCdID
     FROM tblSfkpPldgCd SPC2
     WHERE SPC2.SfkpAcctID = SA.SfkpAcctID
         AND SPC2.PldgCd = SA.UnPldgCd
         AND SPC2.Active = 1) as Target_SfkpPldgCdID
FROM TicketHolding TH
    INNER JOIN tblSfkpAcct SA ON SA.SfkpAcctID = TH.SfkpAcctID
WHERE TH.Ticket IN (@Ticket1, @Ticket2, @Ticket3, @Ticket4)
ORDER BY TH.Ticket

PRINT ''
PRINT ''

PRINT '============================================================================'
PRINT 'SUMMARY'
PRINT '============================================================================'
PRINT ''
PRINT 'Based on the results above, determine:'
PRINT '  1. What is the actual pledge code value for "unpledged" status?'
PRINT '     (Check the UnPldgCd field from tblSfkpAcct)'
PRINT ''
PRINT '  2. Update the fix scripts to use the correct value:'
PRINT '     DECLARE @NewPldgCd varchar(20) = ''<correct_value>'''
PRINT ''
PRINT '  3. Common values to look for:'
PRINT '     - UNPLEDGED (literal string)'
PRINT '     - U'
PRINT '     - UN'
PRINT '     - The value in SA.UnPldgCd column'
PRINT '     - Empty string or NULL'
PRINT ''
PRINT '============================================================================'

GO
