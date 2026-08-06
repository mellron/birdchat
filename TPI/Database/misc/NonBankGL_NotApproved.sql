/*
===================================================================================
Script Name: NonBankGL_NotApproved.sql
Purpose:     Show the rows behind the "Not Approved" number for the NonBankGL row
             of the GL Upload screen.

Environment: UAT   -> VMCKSA69901M08U.us.bank-dns.com,49001   database [Non_Bank_GL]
             (IT/DEV -> VMBKSA69901MRT,49001 ; PROD -> VMCKSA69901M08X...)

Mirrors:     ApplicationService.getNonBankGLUnapprovedCount()
             TPI/Application/TPI.Services/TPIUploadService.cs:412

                 context.vMoneyTransfer_tblDueFromAcctg.AsNoTracking()
                        .Where(x => x.Account != "0000000"
                                 && x.EffectiveDate <= postingDate
                                 && x.ApproverDate == null)
                        .Select(x => x.TranID).Distinct().Count();

Read-only. SELECT only, no data is modified.

Notes:
  - The screen counts DISTINCT TranID, not rows. A TranID with a debit and a
    credit leg counts once. Result set 1 reproduces the screen number;
    result set 2 lists the underlying rows.
  - "Account <> '0000000'": EF Core translates a C# `!=` on a nullable column to
    "<> value OR IS NULL", so rows with a NULL Account are INCLUDED here.
    Written out explicitly below so this matches the app rather than plain
    T-SQL three-valued logic (which would drop them).
  - Rows with Account = '0000000' are NOT counted here - the app buckets those
    into "Future Dated" regardless of their effective date.
  - @PostingDate defaults to GETDATE() to match the screen's own default
    (GLUploadController.Index uses DateTime.Now, which carries a time of day).
    Picking a date from the app's dropdown instead yields midnight of that date,
    so set @PostingDate = '20260806 00:00:00' style if you are reproducing that.
===================================================================================
*/

USE [Non_Bank_GL];
GO

SET NOCOUNT ON;

DECLARE @PostingDate DATETIME = GETDATE();   -- <<< set to the date shown on the GL Upload screen

/* ---------------------------------------------------------------------------
   1) The number the screen shows: DISTINCT TranID
   --------------------------------------------------------------------------- */
SELECT
    PostingDate      = @PostingDate,
    SourceSystem     = 'NonBankGL',
    Bucket           = 'Not Approved',
    NotApprovedCount = COUNT(DISTINCT v.TranID)
FROM dbo.vMoneyTransfer_tblDueFromAcctg AS v
WHERE (v.Account IS NULL OR v.Account <> '0000000')
  AND v.EffectiveDate <= @PostingDate
  AND v.ApproverDate IS NULL;

/* ---------------------------------------------------------------------------
   2) The rows behind that number
   --------------------------------------------------------------------------- */
SELECT
    v.TranID,
    v.BatchNumber,
    v.EffectiveDate,
    v.EntryDate,
    v.Bank,
    v.Center,
    v.Account,
    v.DR_CR_Ind,
    v.Amount,
    v.Description,
    v.Document,
    v.UserID,
    v.ApproverID,
    v.ApproverDate,
    v.ApproverComments,
    v.Posted,
    v.ModifiedBy,
    v.IID
FROM dbo.vMoneyTransfer_tblDueFromAcctg AS v
WHERE (v.Account IS NULL OR v.Account <> '0000000')
  AND v.EffectiveDate <= @PostingDate
  AND v.ApproverDate IS NULL
ORDER BY v.EffectiveDate, v.TranID, v.IID;

/* ---------------------------------------------------------------------------
   3) One line per TranID - who entered it and whether its legs balance
   --------------------------------------------------------------------------- */
SELECT
    v.TranID,
    EffectiveDate = MIN(v.EffectiveDate),
    EnteredBy     = MIN(v.UserID),
    Legs          = COUNT(*),
    DebitAmount   = SUM(CASE WHEN v.DR_CR_Ind = 'D' THEN v.Amount ELSE 0 END),
    CreditAmount  = SUM(CASE WHEN v.DR_CR_Ind = 'C' THEN v.Amount ELSE 0 END),
    OutOfBalance  = SUM(CASE WHEN v.DR_CR_Ind = 'D' THEN v.Amount ELSE 0 END)
                  - SUM(CASE WHEN v.DR_CR_Ind = 'C' THEN v.Amount ELSE 0 END)
FROM dbo.vMoneyTransfer_tblDueFromAcctg AS v
WHERE (v.Account IS NULL OR v.Account <> '0000000')
  AND v.EffectiveDate <= @PostingDate
  AND v.ApproverDate IS NULL
GROUP BY v.TranID
ORDER BY v.TranID;
