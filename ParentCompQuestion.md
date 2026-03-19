# TPP-9670 Parent Company / Affiliate Mapping Questions
**Date:** 2026-03-17
**For:** Carl (+ Mark / Annie)

---

## Background

The NonBankGL Access app stores a `Parent_Co` field on each company in `Non_Bank_GL.dbo.tbl_Company`.
This is the field shown as **Parent ID** in the Access UI.

The plan is to stage this mapping into TPI at the start of the SSIS package
(`TPIGLUpload_Workday.dtsx`) so that `GetExtractRecordsWorkdayAPIGL` can return
the correct Workday affiliate company ID directly — replacing the current amount-matching logic
in `JournalEntryBuilder.cs`.

`OGLTransactions.Bank_Number` is always a **3-digit numeric string** (e.g. `300`, `050`, `085`).
Alpha-suffix company codes (`300C`, `808A`, etc.) do not appear in TPI.

---

## Company → Parent Mapping (from tbl_Company)

| Company | Name | Parent_Co |
|---------|------|-----------|
| 036 | | 050 |
| 050 | U.S. Bancorp | NULL |
| 066 | Mercantile Mortgage Financial | **300C** ⚠️ |
| 078 | Firstar Capital Corporation | 050 |
| 085 | Firstar Realty, LLC | **300C** ⚠️ |
| 140 | USB Municipal Lending and Finance | **300C** ⚠️ |
| 225 | Elavon, Inc | 300 |
| 248 | PFM Asset Management LLC | 300 |
| 300 | U.S. Bank NA | 050 |
| 352 | SID-Municipal Advisory Group | 300 |
| 364 | Pullman Transformation, Inc. | 300 |
| 368 | Red Sky Risk Services, LLC | 300 |
| 389 | Elavon PR | 300 |
| 417 | US Bank Trust Co | 300 |
| 479 | SA California Group, Inc. | 300 |
| 615 | Forecom Challenger, Inc. | 300 |
| 617 | Northwest Boulevard, Inc. | 300 |
| 631 | SA Challenger, Inc. | 300 |
| 672 | Sand Trap Properties | 300 |
| 711 | U.S. Bank Trust NA (South Dakota) | 300 |
| 785 | USB Comm Dev Corp | 300 |
| 787 | C'est La Vie, Inc. | 300 |
| 806 | USB Leasing, LT | **808A** ⚠️ |
| 808 | USB Leasing, LLC | 300 |
| 839 | USB Asset Management, Inc. | 300 |
| 845 | U.S. Bank Trust NA Delaware | 300 |
| 858 | USB Realty Corp | **300C** ⚠️ |
| 862 | Firstar Development, LLC | 050 |

---

## Questions

**Q1.** Companies `066`, `085`, `140`, and `858` all have `Parent_Co = 300C`
(U.S. Bank NA offshore ME). `300C` is an alpha-suffix code that does not exist
in TPI as a 3-digit numeric company.

- Does `300C` exist as a separate company entity in Workday?
- If not, should these four companies map to `300` instead?

**Q2.** Company `806` (USB Leasing, LT) has `Parent_Co = 808A`.
Same issue — `808A` is an alpha-suffix code not in TPI.

- Does `808A` exist as a separate entity in Workday?
- If not, should `806` map to `808` instead?

**Q3.** Company `050` (U.S. Bancorp) has `Parent_Co = NULL` in `tbl_Company`. There are
active GL transactions for bank `0050` in `OGLTransactions`. What affiliate should be
assigned to `050` lines in Workday?

**Q4.** Bank number `0854` has GL transactions in `OGLTransactions` but there is no
matching `854` entry in `tbl_Company` — only `854A` (One Eleven Investors) exists with
`Parent_Co = 300`. Is `0854` the same entity as `854A`? Should `0854` use `300` as its
affiliate, and should a `854` row be added to `tbl_Company`?

---

## Progress (as of 2026-03-19)

- [x] Identified `tbl_Company.Parent_Co` as the correct affiliate source
- [x] Added `Non_Bank_GL` connection to `TPIGLUpload_Workday.dtsx`
- [x] Created `tblCompanyAffiliateRef` staging table in TPI
- [x] Added truncate + reload step in SSIS package
- [x] Updated `Sel_GLtransactions.sql` to join `tblCompanyAffiliateRef` and return `AffiliateCompanyID`
- [x] Removed amount-matching logic from `JournalEntryBuilder.cs`
- [ ] Get answers to Q1–Q4 from Carl/Mark/Annie
- [ ] Update `Sel_GLtransactions.sql` to handle alpha-suffix edge cases once Carl answers Q1
- [ ] Update `main.cs` to pass `AffiliateCompanyID` from data flow into `AddJournalEntry`
- [ ] End-to-end test
