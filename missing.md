# Missing Revenue Category - Ledger Accounts

The following ledger accounts are configured in Workday as **Income-type** but are missing the required `Revenue_Category_Reference` worktag. Please add the appropriate Revenue Category mapping for these accounts.

## Affected Journal Lines

| Ledger_Account_ID | Company_Reference_ID | Cost_Center_Reference_ID | Debit Amount |
|-------------------|----------------------|--------------------------|--------------|
| 5210752 | 785 | 07850000063 | $21,027.59 |
| 5210752 | 808 | 08080006300 | $1.78 |
| 5210752 | 300 | 03000006300 | $20,718.12 |
| 5210752 | 368 | 03680000999 | $43.46 |
| 5210750 | 862 | 08620000999 | $78.20 |

## Error Message

```
FIN - Ledger Account Type = Income Requires a Revenue Category
```

---

## Database Mapping Analysis

Query against `[TPI].[dbo].[GLAccountCategoryMapping]`:

```sql
SELECT WorkdayGLAccount, SpendCategoryID, SpendCategoryName, RevenueCategoryID, RevenueCategoryName
FROM [TPI].[dbo].[GLAccountCategoryMapping]
WHERE WorkdayGLAccount IN ('5210752', '5210750')
```

### Current Mapping

| WorkdayGLAccount | WorkdayGLAccountDescription | SpendCategoryID | RevenueCategoryID |
|------------------|----------------------------|-----------------|-------------------|
| 5210750 | IEO S/T BORROWINGS DUE TO FBS - INTERCO | Int_Exp_Gen | **(null)** |
| 5210752 | IEO-S/T BORR DUE TO AFFL-INTRA-IT | Int_Exp_Gen | **(null)** |

### The Problem

There is a **mismatch** between the database mapping and Workday configuration:

- **Database mapping** treats these as **Expense** accounts (has `SpendCategoryID = Int_Exp_Gen`)
- **Workday configuration** treats these as **Income-type** accounts (requires `RevenueCategoryID`)

---

## Resolution Options

### Option 1: Update GLAccountCategoryMapping Table (Recommended)

Add `RevenueCategoryID` to these accounts in the mapping table:

```sql
UPDATE [TPI].[dbo].[GLAccountCategoryMapping]
SET RevenueCategoryID = 'Int_Inc_Gen',
    RevenueCategoryName = 'Interest Income - General',
    UpdatedBy = 'TPP-9670',
    UpdatedDate = GETDATE()
WHERE WorkdayGLAccount IN ('5210750', '5210752')
```

### Option 2: Update Workday Ledger Account Configuration

Change the ledger account type in Workday from "Income" to "Expense" for accounts 5210750 and 5210752. This may require coordination with the Workday Finance team.

### Option 3: Update Integration Logic

Modify the integration to use a fallback Revenue Category when:
- Workday requires a Revenue Category
- Only a Spend Category exists in the mapping

---

## Summary

| Account | Description | Current Category | Missing |
|---------|-------------|------------------|---------|
| 5210750 | IEO S/T BORROWINGS DUE TO FBS - INTERCO | SpendCategory only | RevenueCategoryID |
| 5210752 | IEO-S/T BORR DUE TO AFFL-INTRA-IT | SpendCategory only | RevenueCategoryID |
