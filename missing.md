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

## Suggested Fix

These accounts need a Revenue Category worktag added to the integration mapping. Based on similar income accounts in this journal (4540665, 4110060, 4240022), the likely Revenue Category is:

```
Revenue_Category_ID: Int_Inc_Gen
```

## Accounts Requiring Mapping

| Ledger Account | Description (if known) |
|----------------|------------------------|
| 5210752 | Interest Expense (classified as Income-type in Workday) |
| 5210750 | Interest Expense (classified as Income-type in Workday) |
