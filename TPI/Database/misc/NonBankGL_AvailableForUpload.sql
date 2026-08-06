/*
===================================================================================
Script Name: NonBankGL_AvailableForUpload.sql
Purpose:     Show the rows behind the "Available For Upload" number for the
             NonBankGL row of the GL Upload screen.

Environment: UAT   -> <UAT-SQL-SERVER>,49001   database [Non_Bank_GL]
             (IT/DEV -> <IT-SQL-SERVER>,49001 ; PROD -> <PROD-SQL-SERVER>)

Mirrors:     ApplicationService.getNonBankGLAvailableForUploadCount()
             TPI/Application/TPI.Services/TPIUploadService.cs:419
             (same predicate as getApprovedNonbankGLAccountingEntries(), which is
              what actually loads TPI when you press Proceed)

                 context.vMoneyTransfer_tblDueFromAcctg.AsNoTracking()
                        .Where(x => x.Account != "0000000"
                                 && x.EffectiveDate <= postingDate
                                 && x.ApproverDate != null)
                        .Select(x => x.TranID).Distinct().Count();

Read-only. SELECT only, no data is modified.

Notes:
  - The screen counts DISTINCT TranID. The upload instead GROUPs the rows by
    accounting key and SUMs the amount, so the count on screen will NOT equal
    the number of rows inserted into TPI.dbo.tblPrepareAcctg. Result set 4
    previews the grouped shape that actually gets inserted.
  - "Account <> '0000000'": EF Core translates a C# `!=` on a nullable column to
    "<> value OR IS NULL", so rows with a NULL Account are INCLUDED here.
    Written out explicitly below so this matches the app rather than plain
    T-SQL three-valued logic (which would drop them).
  - TranCode is derived in code, not stored (vNonBankGL_DuefromAcctgDto.TranCode):
    effective date = posting date -> '01' debit / '02' credit
    otherwise (past dated)        -> '21' debit / '22' credit
    Reproduced in result set 4.
  - Description and ApplicationName are hardcoded to 'NonBankGL Daily Acctg'
    by the DTO; the view's own Description column is ignored on upload.
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
    PostingDate    = @PostingDate,
    SourceSystem   = 'NonBankGL',
    Bucket         = 'Available For Upload',
    AvailableCount = COUNT(DISTINCT v.TranID)
FROM dbo.vMoneyTransfer_tblDueFromAcctg AS v
WHERE (v.Account IS NULL OR v.Account <> '0000000')
  AND v.EffectiveDate <= @PostingDate
  AND v.ApproverDate IS NOT NULL;

/* ---------------------------------------------------------------------------
   2) The rows behind that number - these are what get pulled into TPI
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
  AND v.ApproverDate IS NOT NULL
ORDER BY v.EffectiveDate, v.TranID, v.IID;

/* ---------------------------------------------------------------------------
   3) One line per TranID - do the legs balance before it reaches TPI
   --------------------------------------------------------------------------- */
SELECT
    v.TranID,
    EffectiveDate = MIN(v.EffectiveDate),
    ApprovedBy    = MIN(v.ApproverID),
    Legs          = COUNT(*),
    DebitAmount   = SUM(CASE WHEN v.DR_CR_Ind = 'D' THEN v.Amount ELSE 0 END),
    CreditAmount  = SUM(CASE WHEN v.DR_CR_Ind = 'C' THEN v.Amount ELSE 0 END),
    OutOfBalance  = SUM(CASE WHEN v.DR_CR_Ind = 'D' THEN v.Amount ELSE 0 END)
                  - SUM(CASE WHEN v.DR_CR_Ind = 'C' THEN v.Amount ELSE 0 END)
FROM dbo.vMoneyTransfer_tblDueFromAcctg AS v
WHERE (v.Account IS NULL OR v.Account <> '0000000')
  AND v.EffectiveDate <= @PostingDate
  AND v.ApproverDate IS NOT NULL
GROUP BY v.TranID
ORDER BY v.TranID;

/* ---------------------------------------------------------------------------
   4) Preview of what Proceed would insert into TPI.dbo.tblPrepareAcctg
      (same grouping the app does in memory, with the derived TranCode)
   --------------------------------------------------------------------------- */
SELECT
    BatchNumber     = v.BatchNumber,
    EffectiveDate   = v.EffectiveDate,
    Company         = v.Bank,
    CostCenter      = v.Center,
    Account         = v.Account,
    TranCode        = CASE
                          WHEN v.EffectiveDate = @PostingDate
                               THEN CASE WHEN v.DR_CR_Ind = 'D' THEN '01' ELSE '02' END
                          ELSE CASE WHEN v.DR_CR_Ind = 'D' THEN '21' ELSE '22' END
                      END,
    [Description]   = 'NonBankGL Daily Acctg',
    ApplicationName = 'NonBankGL Daily Acctg',
    TranAmount      = SUM(v.Amount),
    SourceRows      = COUNT(*)
FROM dbo.vMoneyTransfer_tblDueFromAcctg AS v
WHERE (v.Account IS NULL OR v.Account <> '0000000')
  AND v.EffectiveDate <= @PostingDate
  AND v.ApproverDate IS NOT NULL
GROUP BY
    v.BatchNumber,
    v.EffectiveDate,
    v.Bank,
    v.Center,
    v.Account,
    CASE
        WHEN v.EffectiveDate = @PostingDate
             THEN CASE WHEN v.DR_CR_Ind = 'D' THEN '01' ELSE '02' END
        ELSE CASE WHEN v.DR_CR_Ind = 'D' THEN '21' ELSE '22' END
    END
ORDER BY Company, TranCode DESC;
