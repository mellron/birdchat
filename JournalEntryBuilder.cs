using System;
using System.Collections.Generic;
using System.Linq;

/// <summary>
/// Builds Workday Import_Accounting_Journal payload with intercompany affiliate worktags.
/// Uses 050 as the header company and derives affiliates using amount-matching logic.
/// </summary>
public class JournalEntryBuilder
{
    /// <summary>
    /// The treasury hub company ID. Always use this as the header company.
    /// </summary>
    private const string HEADER_COMPANY = "050";

    /// <summary>
    /// The default currency for journal entries.
    /// </summary>
    private const string CURRENCY = "USD";

    /// <summary>
    /// Tracks the first non-050 company encountered for counterparty logic.
    /// Used as a fallback when amount-matching fails for 050 lines.
    /// </summary>
    private string _firstNonHeaderCompany = null;

    /// <summary>
    /// The payload object used to build the XML for the Workday REST API call body.
    /// </summary>
    public ImportAccountingJournalPayload Payload { get; private set; }

    /// <summary>
    /// Initializes a new instance of the JournalEntryBuilder class.
    /// </summary>
    public JournalEntryBuilder()
    {
        Payload = new ImportAccountingJournalPayload();
    }

    /// <summary>
    /// Adds a journal entry line to the payload with all required worktags including intercompany affiliate.
    /// </summary>
    /// <param name="bankNumber">The bank number used to derive the company ID.</param>
    /// <param name="costCenter">The cost center reference ID.</param>
    /// <param name="account">The ledger account ID.</param>
    /// <param name="spendCategoryId">The spend category ID (optional).</param>
    /// <param name="revenueCategoryId">The revenue category ID (optional, required for income accounts).</param>
    /// <param name="transactionAmount">The transaction amount in cents.</param>
    /// <param name="crDbFlag">The debit/credit flag ('D' or 'C').</param>
    /// <param name="transactionDescription">The memo/description for the journal line.</param>
    /// <returns>True if the journal entry was added successfully; otherwise, false.</returns>
    public bool AddJournalEntry(
        string bankNumber,
        string costCenter,
        string account,
        string spendCategoryId,
        string revenueCategoryId,
        string transactionAmount,
        string crDbFlag,
        string transactionDescription)
    {
        try
        {
            string company = ConvertBankNumberToCompany(bankNumber);

            TrackFirstNonHeaderCompany(company);

            decimal transAmt = Convert.ToDecimal(transactionAmount) / 100;
            string debitAmt = crDbFlag == "D" ? transAmt.ToString() : "0";
            string creditAmt = crDbFlag == "C" ? transAmt.ToString() : "0";

            List<Worktag> worktags = new List<Worktag>
            {
                new Worktag { Type = "Cost_Center_Reference_ID", Id = costCenter }
            };

            if (!string.IsNullOrWhiteSpace(spendCategoryId))
            {
                worktags.Add(new Worktag { Type = "Spend_Category_ID", Id = spendCategoryId });
            }

            if (!string.IsNullOrWhiteSpace(revenueCategoryId))
            {
                worktags.Add(new Worktag { Type = "Revenue_Category_ID", Id = revenueCategoryId });
            }

            // Add intercompany affiliate worktag (required for multi-company journals)
            // Non-050 lines get affiliate = 050; 050 lines are handled in FinalizePayload
            string affiliateCompany = GetAffiliateCompany(company);

            if (!string.IsNullOrWhiteSpace(affiliateCompany))
            {
                worktags.Add(new Worktag
                {
                    Type = "Company_Reference_ID",
                    Id = affiliateCompany
                });
            }

            Payload.AddJournalEntryLine(new JournalEntryLine
            {
                CompanyId = company,
                LedgerAccountId = account,
                Debit = Convert.ToDecimal(debitAmt),
                Credit = Convert.ToDecimal(creditAmt),
                CurrencyId = CURRENCY,
                Memo = transactionDescription,
                Worktags = worktags
            });

            return true;
        }
        catch
        {
            return false;
        }
    }

    /// <summary>
    /// Finalizes the payload by assigning affiliates to 050 lines and returns the XML.
    /// Call this after all journal entries have been added.
    /// </summary>
    /// <returns>The XML string for the Workday REST API call.</returns>
    public string FinalizeAndGetXml()
    {
        AssignAffiliatesTo050Lines();
        return Payload.ToXml();
    }

    /// <summary>
    /// Tracks the first non-050 company encountered for fallback counterparty logic.
    /// </summary>
    /// <param name="companyId">The company ID to evaluate.</param>
    private void TrackFirstNonHeaderCompany(string companyId)
    {
        if (_firstNonHeaderCompany == null && companyId != HEADER_COMPANY)
        {
            _firstNonHeaderCompany = companyId;
        }
    }

    /// <summary>
    /// Assigns intercompany affiliate worktags to 050 lines using amount-matching.
    /// Falls back to the first non-050 company if no amount match is found.
    /// </summary>
    private void AssignAffiliatesTo050Lines()
    {
        List<JournalEntryLine> headerLines = Payload.Lines
            .Where(l => l.CompanyId == HEADER_COMPANY)
            .ToList();

        if (!headerLines.Any())
            return;

        foreach (JournalEntryLine line in headerLines)
        {
            bool hasAffiliate = line.Worktags.Any(w =>
                w.Type == "Company_Reference_ID" && w.Id != line.CompanyId);

            if (hasAffiliate)
                continue;

            string affiliate = FindAffiliateByAmount(line.Debit > 0 ? line.Debit : line.Credit);

            if (string.IsNullOrEmpty(affiliate))
            {
                affiliate = _firstNonHeaderCompany;
            }

            if (!string.IsNullOrEmpty(affiliate))
            {
                line.Worktags.Add(new Worktag
                {
                    Type = "Company_Reference_ID",
                    Id = affiliate
                });
            }
        }
    }

    /// <summary>
    /// Finds the affiliate company for a 050 line by matching the amount to a non-050 line.
    /// </summary>
    /// <param name="amount">The debit or credit amount to match.</param>
    /// <returns>The company ID of the matching line, or null if no match found.</returns>
    private string FindAffiliateByAmount(decimal amount)
    {
        if (amount == 0)
            return null;

        JournalEntryLine match = Payload.Lines
            .FirstOrDefault(l => l.CompanyId != HEADER_COMPANY &&
                                (l.Debit == amount || l.Credit == amount));

        return match != null ? match.CompanyId : null;
    }

    /// <summary>
    /// Gets the intercompany affiliate company for a journal line.
    /// Non-050 lines return 050 as the affiliate.
    /// 050 lines return null (handled later by AssignAffiliatesTo050Lines).
    /// </summary>
    /// <param name="lineCompany">The company ID of the journal line.</param>
    /// <returns>The affiliate company ID, or null if deferred to post-processing.</returns>
    private string GetAffiliateCompany(string lineCompany)
    {
        if (lineCompany != HEADER_COMPANY)
        {
            return HEADER_COMPANY;
        }

        return null;
    }

    /// <summary>
    /// Converts a bank number to a company ID.
    /// Handles padding and trimming to ensure consistent 3-digit company codes.
    /// Examples: "5" -> "005", "85" -> "085", "0140" -> "140".
    /// </summary>
    /// <param name="bankNumber">The bank number from the source data.</param>
    /// <returns>The normalized company ID.</returns>
    private string ConvertBankNumberToCompany(string bankNumber)
    {
        if (string.IsNullOrWhiteSpace(bankNumber))
            return string.Empty;

        string trimmed = bankNumber.Trim();

        if (trimmed.Length == 4 && trimmed[0] == '0')
            return trimmed.Substring(1);

        return trimmed.Length < 3
            ? trimmed.PadLeft(3, '0')
            : trimmed;
    }
}
