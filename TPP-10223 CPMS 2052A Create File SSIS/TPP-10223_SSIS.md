# TPP-10223: SSIS Package Analysis

Reference package: `previous_JIRA/TPP-9415/CPMSExportLOCCallateralData.dtsx`
New package name: `CPMSExportActiveLOCCollateralData.dtsx`

---

## Package Flow (unchanged from TPP-9415)

```
Insert Log - Job Start
        ↓ (success)
Create LOC Collat Data          → (failure) → Insert Log - Create LOC Collat data fail
        ↓ (success)
Export LOC Collat Data          → (failure) → Insert Log - Export LOC Collat data fail
        ↓ (success)
Insert Log - Job Complete success
```

All precedence constraints, error handling, and logging tasks carry over as-is.

---

## Changes Required

### 1. Package Metadata

| Property | Old Value | New Value |
|----------|-----------|-----------|
| `DTS:ObjectName` | `CPMSExportLOCCollateralData` | `CPMSExportActiveLOCCollateralData` |
| `DTS:CreatorName` | `US\tmkaras` | `US\detolle` |
| `DTS:DTSID` | `{F719F41A-F2A5-41D7-B5D0-4E8CD5489F4D}` | New GUID |
| `DTS:VersionGUID` | `{A9494910-1D0B-46B3-AA1F-901C0DA12798}` | New GUID |
| Annotation text | TPP-9415, tmkaras, 01/06/26 | TPP-10223, detolle, today's date |

---

### 2. Execute SQL Task — "Create LOC Collat Data"

One line change:

| | Old | New |
|-|-----|-----|
| `SqlStatementSource` | `Exec SSISLoadLOCCollateralData` | `Exec SSISLoadActiveLOCCollateralData` |

> **Note:** Task display label ("Create LOC Collat Data") left unchanged — cosmetic only, no impact on execution.

---

### 3. Data Flow Task — OLE DB Source ("LOC Collat Export")

One line change:

| | Old | New |
|-|-----|-----|
| `SqlCommand` | `EXEC [dbo].[SSISLOCCollateral]` | `EXEC [dbo].[SSISActiveLOCCollateral]` |

Output column `RowData` (wstr, length 4000) is **identical** — both SPs return the same single-column result set. No mapping changes needed.

---

### 4. Variable Default Values

| Variable | Old | New |
|----------|-----|-----|
| `User::vLOCCollateralFileName` | Static: `LOC_Collateral.txt` (overridden by SSISConfigurations) | Expression: `"LOCActive_" + RIGHT("0" + (DT_STR,2,1252)MONTH(GETDATE()),2) + RIGHT("0" + (DT_STR,2,1252)DAY(GETDATE()),2) + (DT_STR,4,1252)YEAR(GETDATE()) + ".txt"` — evaluates to e.g. `LOCActive_02272026.txt` |
| `User::vSendFileLocation` | `\\us.bank-dns.com\NAS\pri\treasury-app_dev\FileTransfer\ConnectDirect\CPMS\Send\` | Unchanged — overridden at runtime by SSISConfigurations |

> `LOC_Collateral_FileName` SSISConfigurations entry removed from package — filename is now fully driven by the expression.

---

### 5. SSISConfigurations Table (in CPMS)

| Config Key | Status | Notes |
|------------|--------|-------|
| `CPMSSendFileLocation` | Reuse existing | Confirm prod path with Diana/Glenn |
| `LOC_Collateral_FileName` | ⚠️ New row needed | Filename is now `LOCActive_MMDDYYYY` — need new key or update existing |

No new SSISConfigurations rows are needed. `CPMSSendFileLocation` already covers all environments via `PackageName='All'` (set in TPP-9415). `LOC_Collateral_FileName` is not required since the filename is expression-driven. See `SQL/SSISConfigurations.sql` for a verification script.

---

## What Stays Identical (no changes)

| Element | Notes |
|---------|-------|
| CPMS OLE DB connection manager | Same server (`VMBKSA69901MRS.us.bank-dns.com,49001`), same DB |
| Flat file connection manager structure | Single column, CRLF delimited, path built from expression `@[User::vSendFileLocation] + @[User::vLOCCollateralFileName]` |
| Config file | `D:\SSIS\CorpTreasury\CPMS_CAR2165\CPMSSSISConfig.dtsConfig` |
| All 4 `InsertSLogSSIS` logging tasks | Job Start, Create fail, Export fail, Job Complete |
| SQL Server log provider | Connected to CPMS |
| All precedence constraints | Flow structure is identical |

---

## Connection Manager Reference

### CPMS (OLE DB)
```
Data Source=VMBKSA69901MRS.us.bank-dns.com,49001;
Initial Catalog=CPMS;
Provider=MSOLEDBSQL.1;
Integrated Security=SSPI;
Auto Translate=False;
MultiSubnetFailover=true;
```

### LOCCollateralFile (Flat File)
- Path expression: `@[User::vSendFileLocation] + @[User::vLOCCollateralFileName]`
- Format: Delimited, single column, CRLF row delimiter
- Max column width: 1000 chars
- Code page: 1252
- No text qualifier on the file connection itself (qualifiers are embedded in the SP output)

---

## Build Checklist

- [x] Copy `CPMSExportLOCCallateralData.dtsx` as starting point → saved as `SSIS/CPMSExportActiveLOCCollateralData.dtsx`
- [x] Update package metadata (name, GUIDs, creator, annotation)
- [x] Update Execute SQL Task: `SSISLoadLOCCollateralData` → `SSISLoadActiveLOCCollateralData` (task label left unchanged)
- [x] Update OLE DB Source: `SSISLOCCollateral` → `SSISActiveLOCCollateral`
- [x] Update variable `vLOCCollateralFileName` — set `EvaluateAsExpression=True`, dynamic date expression; removed `LOC_Collateral_FileName` SSISConfigurations entry
- [x] SSISConfigurations — `LOC_Collateral_FileName` not required (filename is expression-driven). `CPMSSendFileLocation` INSERT script created for all 4 environments — TPP-9415 was only deployed to Development so IT/UAT/Production rows must be inserted. ⚠️ Confirm prod path before running in Production. Script: `SQL/SSISConfigurations.sql`
- [ ] Confirm `CPMSSendFileLocation` prod path with Diana/Glenn
- [ ] Commit new package to `cpmsssis` GitLab on branch `TPP-10223_detolle`
- [ ] Test end-to-end once TPP-10200 passes code review and SPs are deployed
