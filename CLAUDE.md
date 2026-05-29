# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Scope of this directory

Working folder for **TPP-10871 — BSDRate WeeklyCOFExtract**. This is *not* application source; it's where draft SSIS/SQL/Autosys artifacts, Jira exports, and screenshots for the story live until they get committed to their final homes elsewhere in `BSDRate/`.

- `TPP-10871.md` — story description + acceptance criteria (authoritative)
- `TPP-10871.xml` — raw Jira RSS export (Sprint, Epic TPP-10671, etc.)
- `WeeklyCOFExt.png` — screenshot of the existing **EmailReport** form ("Weekly COF Extract" menu item)
- `SQL/` — drafts of any new procs/views before they're folded into `BSDRate/BSDRate_Database.sql`
- `Autosys/` — drafts of the Autosys job definition for the scheduled file drop

## What the story is doing

The existing weekly process emails `WeeklyCOFExtract.xls` via the BSDRate desktop UI (EmailReport form). The story adds a **parallel** CSV drop to an Azure file share, on the same cadence. Email path stays untouched.

Three target paths (entitlements are listed in `TPP-10871.md`):

| Env | Path |
| --- | --- |
| Dev | `\\sasgnc1zpii04dsyndbbsv03.file.core.windows.net\saf-cus-syndbbsv-dev-01\COF` |
| IT  | `\\sasgnc1zpii03isynibbsv03.file.core.windows.net\saf-cus-synibbsv-it-01\COF` |
| UAT | `\\sasgnc1gpii05usynubbsv03.file.core.windows.net\saf-cus-synubbsv-uat-01\COF` |

Filename gets the run date appended.

## Where the moving parts live in the parent repo

The story spans three layers — UI (already exists, don't touch), DB (proc already exists), SSIS/Autosys (new):

- **The full BSDRate database is scripted out** at `BSDRate/BSDRate_Database.sql` (single file, ~50k+ lines, all tables/views/procs). When you need to know what exists in the DB, grep this file rather than guessing — it is the authoritative snapshot.
- **Data source — already exists:** stored proc `dbo.ReportWeeklyCOFExtract` in `BSDRate/BSDRate_Database.sql:51334`. Takes `@startDate`, `@endDate` (defaults: last month → today). Selects from `vBSDRateLocks`. This is the proc the existing SSRS report runs, and the proc the new SSIS package should call directly.
- **Existing email path (don't change):** the form shown in `WeeklyCOFExt.png` is `BSDRateUI/EmailReport.vb` — a *generic* SSRS Report Viewer (`Microsoft.Reporting.WinForms`), not a hard-coded COF form. The "Weekly COF Extract" TreeView node is just an `STask` row with `RunType='Custom Form'`, `EntryPoint='EmailReport'`. Trace:
  - `InitialDisplay.InitialDisplayTreeView_AfterSelect` (`InitialDisplay.vb:824`) reads `STask` and dispatches.
  - `InitialDisplay.LaunchForm` (`InitialDisplay.vb:482`) Activator-creates `BSDRate.EmailReport`.
  - `EmailReport.NewCommon` (`EmailReport.vb:456`) calls proc `GetTaskByDescription` with `'Weekly COF Extract'`, loads `STaskParameter` rows; the `ReportName` parameter resolves the SSRS .rdl path.
  - `EmailReport.DisplayReport` (`EmailReport.vb:626`) and `GenerateAttachment` (`EmailReport.vb:798`) render via `ReportViewer1.ServerReport.Render(...)` — the actual proc call (`ReportWeeklyCOFExtract`) is *inside the .rdl on the SSRS server*, not in VB.
- **New SSIS package — to be added under:** `BSDRate/SSIS/`. Pattern to follow: `BSDRate ExportExtractData.dtsx` (same DB, OLEDB source + flat-file destination + SystemsMaster config table). Connection strings / run paths are externalized via `SystemsMaster.dbo.vSSISConfigurations_BSD` — match that pattern, don't hard-code. Bypass SSRS entirely: have the OLEDB source call `EXEC dbo.ReportWeeklyCOFExtract` directly.
- **CSV format reference:** `BSDRate/docs/SSISExportDailyCurveMRO_Copybook.txt` documents the CSV conventions used by sibling exports (UTF-8, MM/DD/YYYY, no text qualifier, header row).
- **Autosys:** new job to invoke the SSIS package on the existing weekly cadence — drop the JIL in `Autosys/` here first.

## Solution / build context (parent repo, for reference only)

The BSDRate solution is at `BSDRate/BSDRate.sln` (VS 2019, three projects):

- `BSDRateBusiness` (VB.NET) — business logic, calculators, data access
- `BSDRateUI` (VB.NET WinForms) — desktop app, includes `EmailReport.vb`
- `BSDRate.Tests` (C#) — test project
- `BSDRate SSIS.dtproj` under `BSDRate/SSIS/` — separate SSIS project

This is a Visual Studio + SSDT codebase. There is no Linux build path — build/test/deploy happens on Windows via VS / dtexec / Autosys. Don't try to compile from this shell.

## Working notes

- Acceptance criteria are deliberately thin: "file lands in the shared location at the same frequency; business validates in UAT." There is no UI change in scope. Don't expand scope into the desktop app.
- The existing email recipient list is visible in the screenshot but is not part of the story — leave the email path untouched.
- Story is in Epic **TPP-10671**; assignee Doug Tolley; reporter Brady Ramthun. Open Jira ticket: `https://jira.us.bank-dns.com/browse/TPP-10871`.
