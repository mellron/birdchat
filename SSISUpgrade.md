# SSIS Package Upgrade Guide: SQL Server 2016 → 2019 / 2022

**Author:** DBA Team  
**Date:** February 2026  
**Scope:** Legacy SSIS packages using OLE DB connections and SQL Server built-in logging

---

## Overview

This document outlines the steps required to upgrade SSIS packages originally developed against SQL Server 2016 to run against SQL Server 2019 and SQL Server 2022. The primary concerns are deprecated OLE DB drivers, encryption defaults, SSIS configuration management, and package compatibility levels.

---

## 1. The Core Problem — Deprecated OLE DB Drivers

Legacy SSIS packages typically use one of the following OLE DB providers in their connection managers:

| Provider | Status |
|---|---|
| `SQLOLEDB` | Original Windows DAC provider — deprecated, unsupported |
| `SQLNCLI` | SQL Native Client (SQL 2005 era) — deprecated |
| `SQLNCLI10` | SQL Native Client (SQL 2008 era) — deprecated |
| `SQLNCLI11` | SQL Native Client (SQL 2012 era) — **removed from SQL Server 2022** |
| `MSOLEDBSQL` | OLE DB Driver v18 (2018) — maintenance mode only |
| `MSOLEDBSQL19` | OLE DB Driver v19 — **current supported driver** |

If your packages reference `SQLNCLI11` or `SQLNCLI11.1`, they will fail on SQL Server 2022 as the driver has been completely removed. Migration to `MSOLEDBSQL19` is required.

---

## 2. Choosing the Right Driver

### MSOLEDBSQL (v18)
- Works on SQL 2019 and 2022
- Encryption defaults to **OFF** — existing connection strings work without changes
- In maintenance mode — no new features, limited lifespan
- Not recommended for new migrations

### MSOLEDBSQL19 (v19) — Recommended
- Fully supported current driver
- Encryption defaults to **ON** — connection strings must include `Encrypt=Optional` or `Trust Server Certificate=True`
- Installs side-by-side with v18 — no risk to existing configurations
- Longer support lifecycle

**Recommendation:** Migrate directly to MSOLEDBSQL19 to avoid repeating this exercise in the future.

---

## 3. Download and Install the Driver

### Prerequisites
Before installing the driver, the Microsoft Visual C++ Redistributable must be installed. For the x64 driver installer, both the **x86 and x64** versions of the C++ Redistributable are required.

Install in this order:
1. Visual C++ Redistributable x86
2. Visual C++ Redistributable x64
3. MSOLEDBSQL19 x64 MSI (installs both 32-bit and 64-bit drivers in one pass)

### Download Location
Download from the official Microsoft Learn page:  
https://learn.microsoft.com/en-us/sql/connect/oledb/download-oledb-driver-for-sql-server

Current latest version is **19.4.1**.

### Machines That Require the Driver
Install on every machine that runs or develops SSIS packages:

- SSIS server(s)
- Developer machines running SSDT / Visual Studio
- SQL Server Agent servers (if separate from SSIS server)
- Any servers running packages via `dtexec`

---

## 4. Verify Driver Installation

Before updating packages, confirm the driver is installed on each server.

### PowerShell — Quick File Check
```powershell
Test-Path "C:\Windows\System32\msoledbsql19.dll"
```
Returns `True` if v19 is installed, `False` if not.

### PowerShell — List All Registered OLE DB Providers
```powershell
(New-Object System.Data.OleDb.OleDbEnumerator).GetElements() | 
Select-Object SOURCES_NAME, SOURCES_DESCRIPTION
```
Look for `MSOLEDBSQL19` in the results.

### PowerShell — Remote Check (if no RDP access)
```powershell
Invoke-Command -ComputerName <ServerName> -ScriptBlock {
    Test-Path "C:\Windows\System32\msoledbsql19.dll"
}
```

---

## 5. Identify Affected Packages

Before making any changes, audit your package estate to identify all connection managers using deprecated providers.

### What to Look For
Since `.dtsx` files are XML, you can search them with PowerShell:

```powershell
Get-ChildItem -Path "D:\ssis" -Filter "*.dtsx" -Recurse |
Select-String -Pattern "SQLNCLI11|SQLNCLI10|SQLOLEDB" |
Select-Object Filename, LineNumber, Line
```

This will give you a list of every package and line number where an old provider is referenced.

### Also Check
- SSIS XML configuration files (`.dtsconfig` or `.xml`) — these can override connection strings at runtime and will undo package-level changes if not updated
- SQL Server tables or views used as SSIS configuration sources (e.g. `vSSISConfigurations_*` pattern) — connection strings stored here will overwrite package connection managers at runtime

---

## 6. Update Connection Strings

### Old Connection String (SQLNCLI11)
```
Data Source=MYSERVER;Initial Catalog=MyDB;Provider=SQLNCLI11;Integrated Security=SSPI;Auto Translate=False;
```

### New Connection String (MSOLEDBSQL19)
```
Data Source=MYSERVER;Initial Catalog=MyDB;Provider=MSOLEDBSQL19;Integrated Security=SSPI;Encrypt=Optional;
```

Key changes:
- `Provider=SQLNCLI11` → `Provider=MSOLEDBSQL19`
- Add `Encrypt=Optional` to handle the v19 encryption default
- Remove `Auto Translate=False` — this property is not supported in MSOLEDBSQL19

### Encryption Options for MSOLEDBSQL19

| Setting | Behaviour |
|---|---|
| `Encrypt=Optional` | Encrypts if server supports it, falls back if not — recommended for most environments |
| `Encrypt=Mandatory;Trust Server Certificate=True` | Forces encryption, trusts any certificate — use for dev/test only |
| `Encrypt=Strict` | Full certificate validation — requires proper SSL cert on SQL Server |

---

## 7. Real-World Example — BoliColiDownloadMROGLBalance.dtsx

The following is a real example of a package requiring migration. It has two connection managers both using `SQLNCLI11` and uses a chained SSIS configuration pattern that is a common gotcha.

### Connection Managers Found in Package

**BoliColiConn** — Primary connection used for all Execute SQL Tasks and SQL logging:
```
Data Source=VMBKSA69901MAD,51401;Initial Catalog=BoliColi_Devt;Provider=SQLNCLI11;Integrated Security=SSPI;Auto Translate=False;
```

**SystemsMasterConn** — Used to bootstrap the SSIS configuration:
```
Data Source=VMBKSA69901MAD;Initial Catalog=SystemsMaster;Provider=SQLNCLI11.1;Integrated Security=SSPI;Auto Translate=False;
```

### Updated Connection Strings (MSOLEDBSQL19)

**BoliColiConn:**
```
Data Source=VMBKSA69901MAD,51401;Initial Catalog=BoliColi_Devt;Provider=MSOLEDBSQL19;Integrated Security=SSPI;Encrypt=Optional;
```

**SystemsMasterConn:**
```
Data Source=VMBKSA69901MAD;Initial Catalog=SystemsMaster;Provider=MSOLEDBSQL19;Integrated Security=SSPI;Encrypt=Optional;
```

### The Chained Configuration Trap

This package uses a two-stage SSIS configuration chain:

1. `SSISConfig.xml` (`D:\ssis\CorpTreasury\SSISConfig.xml`) sets up `SystemsMasterConn` first
2. `SystemsMasterConn` then connects to `[dbo].[vSSISConfigurations_BoliColi]` in the SystemsMaster database to retrieve the runtime connection string for `BoliColiConn`

**This means if you only update the package in SSDT and do not update the config view, the runtime configuration will overwrite your fix every time the package runs.** The package will appear correct in SSDT but will still fail at runtime.

### Correct Update Order for This Package

1. Update `SSISConfig.xml` on the file system — change `SystemsMasterConn` provider to `MSOLEDBSQL19`
2. Update `[dbo].[vSSISConfigurations_BoliColi]` in the SystemsMaster database — change the stored `BoliColiConn` connection string to use `MSOLEDBSQL19`
3. Update both connection managers in the package in SSDT
4. Redeploy and test

### SQL Logging Note

This package uses the **SSIS Log Provider for SQL Server** pointed at `BoliColiConn`, logging events including `OnError`, `OnWarning`, `OnPreExecute`, `OnPostExecute`, `OnTaskFailed`, `OnPreValidate`, and `OnPostValidate`. Once `BoliColiConn` is updated to MSOLEDBSQL19, logging will continue working without any further changes.

---

## 8. Critical — Update Configuration Sources Before Packages  

If your packages use SSIS configurations (XML files or SQL table-based configs) to inject connection strings at runtime, **update these first**. If you update the package but not the configuration source, the runtime config will overwrite your changes every time the package runs.

### Checklist
- [ ] Update any `.dtsconfig` or `.xml` SSIS config files on the file system
- [ ] Update any SQL views or tables used as SSIS configuration sources
- [ ] Confirm the updated connection string includes `Provider=MSOLEDBSQL19` and `Encrypt=Optional`

---

## 9. Update Package Connection Managers in SSDT

Once the driver is installed and config sources are updated:

1. Open the package in **SSDT (SQL Server Data Tools)**
2. Navigate to the **Connection Managers** panel
3. Edit each connection manager referencing `SQLNCLI11`
4. Update the provider to `MSOLEDBSQL19` and add `Encrypt=Optional`
5. Test the connection before saving
6. Redeploy the package

### Note on ADO.NET
Switching to ADO.NET connection managers is **not recommended** for legacy OLE DB packages because:
- OLE DB Source/Destination components must be manually rebuilt as ADO.NET Source/Destination — this is not automatic
- The SSIS built-in SQL log provider uses OLE DB internally and cannot be pointed at an ADO.NET connection manager
- The migration effort is significant for large package estates

---

## 10. SQL Server Built-in Logging

If you use the **SSIS Log Provider for SQL Server** (built-in logging to `sysdtslog90`), it uses OLE DB internally via whichever connection manager it is pointed at. Once that connection manager is updated to MSOLEDBSQL19, logging will continue to work without any additional changes.

### Confirm the Log Table Exists
Check that `sysdtslog90` exists in the target logging database:

```sql
SELECT * FROM sysdtslog90 ORDER BY starttime DESC
```

If it does not exist, SSIS will create it automatically on first run, provided the service account has sufficient permissions.

---

## 11. SSIS Package Compatibility and Version

Packages built with older SSDT versions carry internal version references (e.g. `Version=11.0.0.0` for SQL 2012 assemblies). These are generally handled transparently by SSIS binding redirects, but it is good practice to open and re-save packages in a current version of SSDT during the migration, which will update these references automatically.

### Check Package Format Version
In the `.dtsx` XML, look for:
```xml
DTS:CreationName="SSIS.Package.3"
DTS:LastModifiedProductVersion="15.0.1300.371"
```
`PackageFormatVersion` 6 is compatible with SQL Server 2019 and 2022 without modification.

---

## 12. SQL Server 2022 Specific Considerations

### Compatibility Level
SQL Server 2022 uses compatibility level **160**. If your packages execute T-SQL via Execute SQL Tasks, test carefully for:
- Changes in cardinality estimation behaviour
- Parameter sniffing differences
- Any deprecated T-SQL syntax

### TLS Requirements
SQL Server 2022 enforces stricter TLS requirements. Ensure all SSIS and application servers are running TLS 1.2 or higher. Older OS versions or outdated .NET Framework versions may need updates.

---

## 13. Recommended Upgrade Order

Follow this sequence to minimise risk:

1. **Install MSOLEDBSQL19** on all relevant machines (dev, SSIS server, agent server)
2. **Audit** all packages and config sources for `SQLNCLI11` references
3. **Update SQL config views/tables** with new connection strings
4. **Update XML config files** on the file system
5. **Update and redeploy packages** in SSDT one at a time
6. **Test each package** in a non-production environment first
7. **Validate SQL logging** is writing correctly after each package update
8. **Roll out to production** once testing is complete

---

## 14. Quick Reference — Connection String Before and After

| Element | Before | After |
|---|---|---|
| Provider | `SQLNCLI11` or `SQLNCLI11.1` | `MSOLEDBSQL19` |
| Encrypt | Not specified (defaults off) | `Encrypt=Optional` |
| Auto Translate | `Auto Translate=False` | Remove this property |
| Everything else | Unchanged | Unchanged |

---

## 15. Useful Scripts

### Find All Old Providers in DTSX Files
```powershell
Get-ChildItem -Path "D:\ssis" -Filter "*.dtsx" -Recurse |
Select-String -Pattern "SQLNCLI11|SQLNCLI10|SQLOLEDB" |
Select-Object Filename, LineNumber, Line | 
Export-Csv "C:\temp\OldProviderAudit.csv" -NoTypeInformation
```

### Check Registered OLE DB Providers on Remote Server
```powershell
Invoke-Command -ComputerName <ServerName> -ScriptBlock {
    (New-Object System.Data.OleDb.OleDbEnumerator).GetElements() | 
    Select-Object SOURCES_NAME, SOURCES_DESCRIPTION
}
```

### Verify Driver File Exists
```powershell
$servers = @("SERVER1", "SERVER2", "SERVER3")
foreach ($s in $servers) {
    $result = Invoke-Command -ComputerName $s -ScriptBlock {
        Test-Path "C:\Windows\System32\msoledbsql19.dll"
    }
    Write-Host "$s : MSOLEDBSQL19 Installed = $result"
}
```

---

*Document based on Microsoft OLE DB Driver 19.4.1 for SQL Server. Always verify against the latest Microsoft documentation at https://learn.microsoft.com/en-us/sql/connect/oledb/oledb-driver-for-sql-server*
