# Next Steps: DBC/DB2 Staging and Export

Based on `testdates.sql` results in `test_results.txt`, you have fully ready dates (all DBC/DB2 rates verified and valued):

- Latest ready date: `2025-12-31`
- Other ready dates (ReadyCount = TotalRates = 364):
  - `2025-11-28`, `2025-10-31`, `2025-09-30`, `2025-08-29`, `2025-07-31`

Use the exact `ProcessDate` from the calendar when staging.

## 1) Stage DBC/DB2 for a Date

```sql
EXEC dbo.SSISStageAnnualRatesForDBC @exportDate = '2025-09-30';
-- or any other fully-ready ProcessDate from the list above
```

## 2) Verify Rows Were Staged

```sql
SELECT COUNT(*) AS RowsStaged
FROM ExportRateValues erv
JOIN ExportRateDefinitions erd ON erd.ExportRateID = erv.ExportRateID
JOIN LExportTypes et ON et.IID = erd.ExportTypeID AND et.Code IN ('DBC','DB2')
WHERE erv.ExportDate = '2025-09-30';
```

Optional spot-check:

```sql
SELECT TOP (50)
    et.Code AS ExportType,
    erd.ShortName,
    erv.*
FROM ExportRateValues erv
JOIN ExportRateDefinitions erd ON erd.ExportRateID = erv.ExportRateID
JOIN LExportTypes et ON et.IID = erd.ExportTypeID AND et.Code IN ('DBC','DB2')
WHERE erv.ExportDate = '2025-09-30'
ORDER BY erd.ShortName, erv.RateDate DESC;
```

## 3) Run Your Export Procedure

Invoke your existing export proc for DBC/DB2 that reads `ExportRateValues` on the chosen `@exportDate`.

Example (if using the Daily Curve export):

```sql
EXEC dbo.SSISExportDailyCurveMRO @exportDate = '2025-09-30';
```

## Notes

- Ensure `ExportRateCalendar` entries remain verified for the chosen date; the staging proc requires `VerifiedBy IS NOT NULL`.
- The staging proc deletes existing `ExportRateValues` for DBC/DB2 on that `ExportDate` before inserting. Verify calendars first to avoid delete-without-repopulate scenarios.
