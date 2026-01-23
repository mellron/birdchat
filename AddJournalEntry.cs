// ============================================================================
// AddJournalEntry.cs
// ============================================================================
//
// TICKET: TPP-9670 Workday TPI Rest API
// DATE:   January 2026
//
// PURPOSE:
//   Modified AddJournalEntry function with Intercompany Affiliate worktag logic
//   for Workday Import_Accounting_Journal API.
//
// PROBLEM:
//   Workday requires an Intercompany Affiliate worktag on every journal line
//   when a journal contains entries for multiple companies. The source system
//   (TPI GL) does not provide affiliate codes, and Workday does not auto-derive
//   them. Without this worktag, journals fail with:
//   "FIN - Intercompany Affiliate Worktag is Required on All Intercompany Ledger Accounts"
//
// SOLUTION:
//   1. Use company 050 (U.S. Bancorp / Treasury) as the fixed header company
//   2. Add Intercompany Affiliate worktag to each journal line:
//      - If line company != 050, affiliate = 050 (the header/hub)
//      - If line company == 050, affiliate = counterparty (first non-050 company)
//   3. The worktag type is "Company_Reference_ID" (not "Intercompany_Affiliate_Reference_ID")
//
// WORKDAY VALIDATION RULES:
//   - Each line needs exactly one affiliate when journal has multiple companies
//   - Affiliate must NOT equal the line company
//   - Affiliate must be a valid, active company in Workday
//   - For intercompany journals, affiliate should typically be the header company
//
// XML STRUCTURE FOR AFFILIATE WORKTAG:
//   <wd:Worktags_Reference>
//       <wd:ID wd:type="Company_Reference_ID">050</wd:ID>
//   </wd:Worktags_Reference>
//
// REFERENCES:
//   - Workday Import_Accounting_Journal API:
//     https://community.workday.com/sites/default/files/file-hosting/productionapi/Financial_Management/v20/Import_Accounting_Journal.html
//   - Workday Financial Management API:
//     https://community.workday.com/sites/default/files/file-hosting/productionapi/Financial_Management/
//
// USAGE:
//   This file is for reference only - copy the relevant portions into your
//   SSIS Script Component (TPIGLUpload_Workday.dtsx -> "Create Workday Body XML")
//
// ALSO UPDATE:
//   In ImportAccountingJournalPayload.ToXml(), change the header company:
//   FROM: returnxml = Utility.ReplaceCompanyNumberInHeader(returnxml, COMPANY_TAG, Lines[0].CompanyId);
//   TO:   returnxml = Utility.ReplaceCompanyNumberInHeader(returnxml, COMPANY_TAG, "050");
//
// ============================================================================

using System;
using System.Collections.Generic;

public partial class ScriptMain
{
    // ============================================================
    // CONSTANTS - Set header company to treasury hub
    // ============================================================
    private const string HEADER_COMPANY = "050";  // Treasury hub - always use this as header
    private const string CURRENCY = "USD";

    // Track the first non-050 company for counterparty logic (for 050 lines)
    private static string _firstNonHeaderCompany = null;

    // ============================================================
    // Call this at the START of processing (PreExecute or first row)
    // to determine a counterparty for 050 lines
    // ============================================================
    public void SetCounterpartyCompany(string companyId)
    {
        if (_firstNonHeaderCompany == null && companyId != HEADER_COMPANY)
        {
            _firstNonHeaderCompany = companyId;
        }
    }

    // ============================================================
    // MODIFIED AddJournalEntry with Intercompany Affiliate logic
    // ============================================================
    private bool AddJournalEntry(
        string BankNumber,
        string CostCenter,
        string Account,
        string SpendCategoryID,
        string SpendCategoryName,
        string RevenueCategoryID,
        string RevenueCategoryName,
        string TransactionAmount,
        string CRDBFLAG,
        string TraceNumber,
        string TransactionDescription,
        string Addendumflag,
        string MemoFlag)
    {
        try
        {
            // Parse the company from BankNumber (e.g., "005" -> "050")
            string Company = ConvertBankNumberToCompany(BankNumber);

            // Track first non-header company for counterparty logic
            SetCounterpartyCompany(Company);

            // Parse debit/credit amounts
            decimal TransAmt = Convert.ToDecimal(TransactionAmount) / 100;
            string DebitAmt = CRDBFLAG == "D" ? TransAmt.ToString() : "0";
            string CreditAmt = CRDBFLAG == "C" ? TransAmt.ToString() : "0";

            // ============================================================
            // BUILD WORKTAGS LIST
            // ============================================================
            var worktags = new List<Worktag>
            {
                new Worktag { Type = "Cost_Center_Reference_ID", Id = CostCenter }
            };

            // Add Spend Category if provided
            if (!string.IsNullOrWhiteSpace(SpendCategoryID))
            {
                worktags.Add(new Worktag { Type = "Spend_Category_ID", Id = SpendCategoryID });
            }

            // Add Revenue Category if provided
            if (!string.IsNullOrWhiteSpace(RevenueCategoryID))
            {
                worktags.Add(new Worktag { Type = "Revenue_Category_ID", Id = RevenueCategoryID });
            }

            // ============================================================
            // INTERCOMPANY AFFILIATE WORKTAG - THE KEY FIX
            // ============================================================
            // Workday requires an Intercompany Affiliate worktag on every line
            // when the journal contains multiple companies.
            //
            // Rules:
            //   - If line company != header company (050), affiliate = header (050)
            //   - If line company == header company (050), affiliate = counterparty
            //   - Affiliate must NEVER equal the line company
            // ============================================================

            string affiliateCompany = GetAffiliateCompany(Company);

            if (!string.IsNullOrWhiteSpace(affiliateCompany))
            {
                worktags.Add(new Worktag
                {
                    Type = "Company_Reference_ID",
                    Id = affiliateCompany
                });
            }

            // ============================================================
            // ADD THE JOURNAL LINE
            // ============================================================
            payload.AddJournalEntryLine(new JournalEntryLine
            {
                CompanyId = Company,
                LedgerAccountId = Account,
                Debit = Convert.ToDecimal(DebitAmt),
                Credit = Convert.ToDecimal(CreditAmt),
                CurrencyId = CURRENCY,
                Memo = TransactionDescription,
                Worktags = worktags
            });

            return true;
        }
        catch (Exception ex)
        {
            bool cancel;
            ComponentMetaData.FireError(0, "AddJournalEntry",
                "Failed to add journal entry: " + ex.Message, "", 0, out cancel);
            return false;
        }
    }

    // ============================================================
    // HELPER: Determine the Intercompany Affiliate for a line
    // ============================================================
    private string GetAffiliateCompany(string lineCompany)
    {
        // If line company is NOT the header (050), affiliate = header (050)
        if (lineCompany != HEADER_COMPANY)
        {
            return HEADER_COMPANY;
        }

        // If line company IS the header (050), affiliate = counterparty
        // Use the first non-050 company we encountered
        if (_firstNonHeaderCompany != null)
        {
            return _firstNonHeaderCompany;
        }

        // Fallback: If somehow we have only 050 lines (shouldn't happen in intercompany)
        // Return null - no affiliate needed for single-company journals
        return null;
    }

    // ============================================================
    // HELPER: Convert BankNumber to Company ID
    // All company numbers are 3 digits - left-pad with zeros if needed
    // e.g., "5" -> "005", "85" -> "085", "140" -> "140"
    // ============================================================
    private string ConvertBankNumberToCompany(string bankNumber)
    {
        if (string.IsNullOrWhiteSpace(bankNumber))
            return bankNumber;

        // Left-pad with zeros to ensure 3 digits
        return bankNumber.PadLeft(3, '0');
    }
}

// ============================================================
// ALSO UPDATE: Header Company in ToXml() or ReplaceCompanyNumberInHeader
// ============================================================
// In your ImportAccountingJournalPayload class, change:
//
// FROM:
//   returnxml = Utility.ReplaceCompanyNumberInHeader(returnxml, COMPANY_TAG, Lines[0].CompanyId);
//
// TO:
//   const string HEADER_COMPANY = "050";
//   returnxml = Utility.ReplaceCompanyNumberInHeader(returnxml, COMPANY_TAG, HEADER_COMPANY);
//
// This ensures the header company is ALWAYS 050, regardless of what's in the data.
// ============================================================


// ============================================================
// SUPPORTING CLASSES (for reference)
// ============================================================
public class Worktag
{
    public string Type { get; set; }
    public string Id { get; set; }
}

public class JournalEntryLine
{
    public string CompanyId { get; set; }
    public string LedgerAccountId { get; set; }
    public decimal Debit { get; set; }
    public decimal Credit { get; set; }
    public string CurrencyId { get; set; }
    public string Memo { get; set; }
    public List<Worktag> Worktags { get; set; } = new List<Worktag>();
}
