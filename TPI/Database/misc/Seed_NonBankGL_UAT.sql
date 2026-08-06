/*
===================================================================================
Script Name: Seed_NonBankGL_UAT.sql
Purpose:     Seed NonBankGL test transactions in UAT that (a) show up on the TPI
             GL Upload screen and (b) survive all the way into OGLTransactions,
             so TPIGLUpload_Workday.dtsx has records to push to Workday.

Environment: UAT only. All six databases live on the same SQL instance, so the
             three-part names below (TPI.dbo..., Non_Bank_GL.dbo...) resolve.
             DO NOT RUN IN PROD.

WRITES DATA. Sections 1 and 3 insert/update; section 4 deletes. Sections 0 and 2
are read-only. Run them in order, checking the output of each before moving on.

The chain being seeded:

    Non_Bank_GL.dbo.tblDueFromAcctg          <- section 1 inserts here
      -> vMoneyTransfer_tblDueFromAcctg      (unfiltered pass-through view)
      -> GL Upload screen "Available For Upload"
      -> [Proceed]        -> TPI.dbo.tblPrepareAcctg
      -> [Complete Upload]-> TPI.dbo.tblMainData
      -> approve + mark Send_A000            (UI, or the shortcut in section 3)
      -> GetGLData        -> TPI.dbo.OGLTransactions
      -> GetExtractRecordsWorkdayAPIGL       -> your SSIS package

-----------------------------------------------------------------------------------
THREE THINGS THAT WILL SILENTLY GIVE YOU ZERO ROWS AT THE END
-----------------------------------------------------------------------------------
1. TranCode must come out '01'/'02'. GetGLData filters
   "WHERE TranCode in ('01','02') AND Send_A000 = 1" - past-dated entries ('21'/'22')
   never reach OGLTransactions. TPI derives the code in C# with
   EffectiveDate.Equals(PostingDate) - an EXACT DateTime match. So:
     - seed EffectiveDate at MIDNIGHT of the posting date (this script does), and
     - open GL Upload from the GL Main date dropdown, NOT by typing /GLUpload
       directly. The bare URL defaults the posting date to DateTime.Now *including
       the time of day*, which can never equal a midnight EffectiveDate, so every
       row silently becomes '21'/'22' and nothing reaches Workday.

2. GetGLData INNER JOINs LGLTraceNumber on ApplicationName. With no row for
   'NonBankGL Daily Acctg' you get zero transactions and no error. With two rows
   you get every transaction duplicated. Section 0 checks for exactly one.

3. All NonBankGL rows share that one Trace_Number, and the Workday category fill
   partitions by (Trace_Number, Transaction_Amount). Two different pairs with the
   SAME amount therefore land in one partition and cross-contaminate categories.
   This script gives every pair a distinct amount on purpose.
===================================================================================
*/


/*
===================================================================================
  SECTION 0 - PREFLIGHT (read-only). Everything here must pass first.
===================================================================================
*/
USE [TPI];
GO
SET NOCOUNT ON;

DECLARE @AppName VARCHAR(40) = 'NonBankGL Daily Acctg';   -- set by the DTO, do not change

/* 0a. Trace number: must be exactly one row, or GetGLData drops or duplicates. */
SELECT
    Check_Name  = '0a. LGLTraceNumber rows for ' + @AppName,
    RowsFound   = COUNT(*),
    Verdict     = CASE COUNT(*) WHEN 1 THEN 'OK'
                                WHEN 0 THEN 'FAIL - GetGLData will return nothing'
                                ELSE 'FAIL - transactions will be duplicated' END
FROM dbo.LGLTraceNumber
WHERE ApplicationName = @AppName;

/* If 0 rows, add one (pick a trace number that is not already in use):
       INSERT INTO dbo.LGLTraceNumber (ApplicationName, Trace_Number)
       VALUES ('NonBankGL Daily Acctg', 9000001);
*/

/* 0b. Accounts that will actually resolve a Workday category.
       GetExtractRecordsWorkdayAPIGL matches SUBSTRING(Account_Number,8,7) against
       WorkdayGLAccount, so only 7-character all-numeric mappings can ever match. */
SELECT TOP 20
    Check_Name          = '0b. usable category mappings',
    WorkdayGLAccount,
    SpendCategoryID,
    RevenueCategoryID,
    WorkdayGLAccountDescription
FROM dbo.GLAccountCategoryMapping
WHERE LEN(WorkdayGLAccount) = 7
  AND WorkdayGLAccount NOT LIKE '%[^0-9]%'
  AND (NULLIF(SpendCategoryID, '') IS NOT NULL OR NULLIF(RevenueCategoryID, '') IS NOT NULL)
ORDER BY WorkdayGLAccount;

SELECT
    Check_Name = '0b. usable mapping count',
    Usable     = COUNT(*),
    Verdict    = CASE WHEN COUNT(*) >= 3 THEN 'OK'
                      ELSE 'FAIL - seed accounts below will not resolve a category' END
FROM dbo.GLAccountCategoryMapping
WHERE LEN(WorkdayGLAccount) = 7
  AND WorkdayGLAccount NOT LIKE '%[^0-9]%'
  AND (NULLIF(SpendCategoryID, '') IS NOT NULL OR NULLIF(RevenueCategoryID, '') IS NOT NULL);

/* 0c. Work already in flight - the upload refuses to run twice. */
SELECT
    Check_Name       = '0c. TPI working tables',
    tblPrepareAcctg  = (SELECT COUNT(*) FROM dbo.tblPrepareAcctg),
    tblMainData      = (SELECT COUNT(*) FROM dbo.tblMainData),
    Verdict          = CASE WHEN (SELECT COUNT(*) FROM dbo.tblMainData) = 0 THEN 'OK'
                            ELSE 'WARNING - Complete Upload will refuse; finish or clear the run first' END;

/* 0d. What is already sitting in the NonBankGL feed table. */
SELECT
    Check_Name   = '0d. Non_Bank_GL.dbo.tblDueFromAcctg',
    TotalRows    = COUNT(*),
    Approved     = SUM(CASE WHEN ApproverDate IS NOT NULL THEN 1 ELSE 0 END),
    NotApproved  = SUM(CASE WHEN ApproverDate IS NULL     THEN 1 ELSE 0 END)
FROM Non_Bank_GL.dbo.tblDueFromAcctg;
GO


/*
===================================================================================
  SECTION 1 - SEED (writes to Non_Bank_GL.dbo.tblDueFromAcctg)
===================================================================================
  Each "pair" is one balanced debit/credit transaction sharing a TranID:
     debit  leg -> a MAPPED account   (resolves a Spend/Revenue category)
     credit leg -> the OFFSET account (deliberately UNMAPPED)
  That is the shape that exercises your package's category carry-over: the credit
  leg starts with a blank category and should inherit the debit leg's via the
  MAX() OVER (PARTITION BY Trace_Number, Transaction_Amount) window.
===================================================================================
*/
USE [Non_Bank_GL];
GO
SET NOCOUNT ON;

DECLARE @PostingDate     DATE        = CAST(GETDATE() AS DATE);  -- the date you will pick on GL Main
DECLARE @ApprovedPairs   INT         = 4;    -- -> "Available For Upload"
DECLARE @UnapprovedPairs INT         = 2;    -- -> "Not Approved"
DECLARE @Bank            VARCHAR(4)  = '300';
DECLARE @Center          VARCHAR(7)  = '1000001';
DECLARE @OffsetAccount   VARCHAR(9)  = '1000000';  -- must NOT be in GLAccountCategoryMapping
DECLARE @SeedUser        VARCHAR(8)  = 'TSTSEED';  -- tag for verification + cleanup
DECLARE @SeedApprover    VARCHAR(8)  = 'TSTAPPR';
DECLARE @BatchNumber     CHAR(3)     = '999';

DECLARE @EffDate DATETIME = CAST(@PostingDate AS DATETIME);  -- midnight - see gotcha 1

/* Guard: the offset account must be unmapped, or both legs arrive pre-categorised
   and the carry-over logic is never exercised. */
IF EXISTS (SELECT 1 FROM TPI.dbo.GLAccountCategoryMapping WHERE WorkdayGLAccount = @OffsetAccount)
BEGIN
    RAISERROR('@OffsetAccount %s IS mapped in GLAccountCategoryMapping - pick an unmapped one.', 16, 1, @OffsetAccount);
    RETURN;
END

/* Pull real mapped accounts so the categories actually resolve. */
DECLARE @Accounts TABLE (rn INT, Account VARCHAR(9));
INSERT INTO @Accounts (rn, Account)
SELECT TOP (@ApprovedPairs + @UnapprovedPairs)
       ROW_NUMBER() OVER (ORDER BY WorkdayGLAccount),
       WorkdayGLAccount
FROM TPI.dbo.GLAccountCategoryMapping
WHERE LEN(WorkdayGLAccount) = 7
  AND WorkdayGLAccount NOT LIKE '%[^0-9]%'
  AND (NULLIF(SpendCategoryID, '') IS NOT NULL OR NULLIF(RevenueCategoryID, '') IS NOT NULL)
ORDER BY WorkdayGLAccount;

IF (SELECT COUNT(*) FROM @Accounts) < (@ApprovedPairs + @UnapprovedPairs)
BEGIN
    RAISERROR('Not enough usable 7-digit category mappings - lower @ApprovedPairs/@UnapprovedPairs or fix the mapping table.', 16, 1);
    RETURN;
END

/* Distinct amount per pair - see gotcha 3. */
;WITH pairs AS (
    SELECT
        a.rn,
        a.Account,
        TranID     = 'TST' + RIGHT('0000' + CAST(a.rn AS VARCHAR(4)), 4),
        Amount     = CAST(1000.00 + (a.rn * 111.11) AS MONEY),
        IsApproved = CASE WHEN a.rn <= @ApprovedPairs THEN 1 ELSE 0 END
    FROM @Accounts a
),
legs AS (
    /* debit leg - mapped account, carries the category */
    SELECT p.rn, p.TranID, p.Amount, p.IsApproved,
           DR_CR_Ind = 'D', Account = p.Account,
           Descr = 'TPI WORKDAY TEST DR ' + p.TranID
    FROM pairs p
    UNION ALL
    /* credit leg - unmapped offset account, should inherit the category */
    SELECT p.rn, p.TranID, p.Amount, p.IsApproved,
           DR_CR_Ind = 'C', Account = @OffsetAccount,
           Descr = 'TPI WORKDAY TEST CR ' + p.TranID
    FROM pairs p
)
INSERT INTO dbo.tblDueFromAcctg
    (BatchNumber, Bank, UserID, EffectiveDate, TranID, Amount, DR_CR_Ind,
     Account, Center, [Description], Document, EntryDate,
     ApproverID, ApproverDate, ApproverComments, Posted, ModifiedBy)
SELECT
    @BatchNumber,
    @Bank,
    @SeedUser,
    @EffDate,                 -- midnight, must equal the posting date exactly
    l.TranID,
    l.Amount,
    l.DR_CR_Ind,
    l.Account,
    @Center,
    l.Descr,
    NULL,
    GETDATE(),
    CASE WHEN l.IsApproved = 1 THEN @SeedApprover END,
    CASE WHEN l.IsApproved = 1 THEN GETDATE() END,   -- ApproverDate drives the bucket
    CASE WHEN l.IsApproved = 1 THEN 'seeded for Workday SSIS test' END,
    NULL,                     -- Posted must be NULL
    @SeedUser
FROM legs l
ORDER BY l.rn, l.DR_CR_Ind DESC;

PRINT CONCAT('Inserted ', @@ROWCOUNT, ' rows into tblDueFromAcctg for posting date ',
             CONVERT(VARCHAR(10), @PostingDate, 101));
GO


/*
===================================================================================
  SECTION 2 - VERIFY (read-only). Should match the GL Upload screen exactly.
===================================================================================
*/
USE [Non_Bank_GL];
GO
DECLARE @PostingDate DATETIME = CAST(CAST(GETDATE() AS DATE) AS DATETIME);

SELECT
    Bucket        = 'Not Approved',
    ScreenCount   = COUNT(DISTINCT TranID),
    Rows          = COUNT(*)
FROM dbo.vMoneyTransfer_tblDueFromAcctg
WHERE (Account IS NULL OR Account <> '0000000')
  AND EffectiveDate <= @PostingDate
  AND ApproverDate IS NULL
UNION ALL
SELECT
    'Available For Upload',
    COUNT(DISTINCT TranID),
    COUNT(*)
FROM dbo.vMoneyTransfer_tblDueFromAcctg
WHERE (Account IS NULL OR Account <> '0000000')
  AND EffectiveDate <= @PostingDate
  AND ApproverDate IS NOT NULL;

/* Balance check per TranID - all must be zero. */
SELECT TranID,
       Debits       = SUM(CASE WHEN DR_CR_Ind = 'D' THEN Amount ELSE 0 END),
       Credits      = SUM(CASE WHEN DR_CR_Ind = 'C' THEN Amount ELSE 0 END),
       OutOfBalance = SUM(CASE WHEN DR_CR_Ind = 'D' THEN Amount ELSE 0 END)
                    - SUM(CASE WHEN DR_CR_Ind = 'C' THEN Amount ELSE 0 END)
FROM dbo.vMoneyTransfer_tblDueFromAcctg
WHERE UserID = 'TSTSEED'
GROUP BY TranID
ORDER BY TranID;

/* Amounts must be distinct across pairs - see gotcha 3. */
SELECT Amount, PairsSharingThisAmount = COUNT(DISTINCT TranID)
FROM dbo.vMoneyTransfer_tblDueFromAcctg
WHERE UserID = 'TSTSEED'
GROUP BY Amount
HAVING COUNT(DISTINCT TranID) > 1;
GO


/*
===================================================================================
  SECTION 3 - OPTIONAL SHORTCUT (writes to TPI). Skips the approve + Send_A000
  clicks so you can re-run the SSIS package quickly.

  Run this ONLY after Proceed + Complete Upload have landed rows in tblMainData.
  Use the real screens at least once first - this bypasses the approval path the
  business actually uses, so it proves the package, not the application.
===================================================================================
*/
USE [TPI];
GO
/*
DECLARE @Me VARCHAR(8) = 'TSTAPPR';

UPDATE dbo.tblMainData
SET Approved     = 1,
    ApproverID   = @Me,
    ApprovalTime = GETDATE(),
    Send_A000    = 1,
    ModifiedBy   = @Me
WHERE ApplicationName = 'NonBankGL Daily Acctg'
  AND (Approved IS NULL OR Approved = 0 OR Send_A000 IS NULL OR Send_A000 = 0);

-- What GetGLData will actually pick up: TranCode must be 01/02 (see gotcha 1).
SELECT TranCode, Send_A000, Approved, EffectiveDate,
       Rows = COUNT(*), Amount = SUM(TranAmount)
FROM dbo.tblMainData
WHERE ApplicationName = 'NonBankGL Daily Acctg'
GROUP BY TranCode, Send_A000, Approved, EffectiveDate
ORDER BY TranCode;

-- Then run GetGLData and confirm the extract your package consumes:
--   EXEC dbo.GetGLData;
--   SELECT * FROM dbo.OGLTransactions;
--   EXEC dbo.GetExtractRecordsWorkdayAPIGL;   -- categories must be non-blank on BOTH legs
*/
GO


/*
===================================================================================
  SECTION 4 - CLEANUP (deletes). Resets the seed so you can start over.
===================================================================================
*/
/*
USE [Non_Bank_GL];
DELETE FROM dbo.tblDueFromAcctg WHERE UserID = 'TSTSEED';

-- TPI side, only if a seeded run is stuck part-way through. Check what you are
-- deleting first - these tables also hold other source systems' entries.
USE [TPI];
SELECT * FROM dbo.tblPrepareAcctg WHERE ApplicationName = 'NonBankGL Daily Acctg';
SELECT * FROM dbo.tblMainData     WHERE ApplicationName = 'NonBankGL Daily Acctg';
-- DELETE FROM dbo.tblPrepareAcctg WHERE ApplicationName = 'NonBankGL Daily Acctg';
-- DELETE FROM dbo.tblMainData     WHERE ApplicationName = 'NonBankGL Daily Acctg';
*/
