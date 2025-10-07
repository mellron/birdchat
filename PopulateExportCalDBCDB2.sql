USE BSDRate;
GO

/*
    PopulateExportCalDBCDB2.sql

    Purpose: Backfill ExportRateCalendar rows for DBC/DB2 rates that were newly
             introduced by PopulateMROExportRate.sql. Copies the calendar data
             for a specific ProcessDate from production into the current
             environment, matching rows by ExportRateDefinitions.ShortName.

    Instructions:
    - Replace PROD_LINKED and ProdDb with the appropriate linked-server and
      production database names before running.
    - Review the filters in TargetNewCurves if you tagged the new definitions
      differently (CreatedBy / CreatedDate / explicit ShortName list).
    - Optional: wrap the insert in an explicit transaction for manual review.
*/

DECLARE @processDate date = '2025-12-01';

;WITH TargetNewCurves AS (
    SELECT
        erd.ShortName,
        erd.ExportRateID
    FROM dbo.ExportRateDefinitions erd
    JOIN dbo.LExportTypes et
        ON et.IID = erd.ExportTypeID
    WHERE et.Code IN ('DBC', 'DB2')
      AND erd.CreatedBy = 'TPP-8278'            -- adjust if you used a different stamp
      AND erd.CreatedDate >= '2025-06-24'       -- narrow the window to the new curves
),
ProdCalendar AS (
    SELECT
        pErd.ShortName,
        c.ProcessDate,
        c.EffectiveDate,
        c.Ignore,
        c.CreatedBy,
        c.CreatedDate,
        c.UpdatedBy,
        c.UpdatedDate,
        c.VerifiedBy,
        c.VerifiedDate
    FROM [PROD_LINKED].[ProdDb].[dbo].[ExportRateCalendar] AS c
    JOIN [PROD_LINKED].[ProdDb].[dbo].[ExportRateDefinitions] AS pErd
        ON pErd.ExportRateID = c.ExportRateID
    JOIN [PROD_LINKED].[ProdDb].[dbo].[LExportTypes] AS pEt
        ON pEt.IID = pErd.ExportTypeID
    WHERE c.ProcessDate = @processDate
      AND pEt.Code IN ('DBC', 'DB2')
      AND EXISTS (
            SELECT 1
            FROM TargetNewCurves t
            WHERE t.ShortName = pErd.ShortName
      )
)
INSERT INTO dbo.ExportRateCalendar (
    ExportRateID,
    ProcessDate,
    EffectiveDate,
    Ignore,
    CreatedBy,
    CreatedDate,
    UpdatedBy,
    UpdatedDate,
    VerifiedBy,
    VerifiedDate
)
SELECT
    tgt.ExportRateID,
    prod.ProcessDate,
    prod.EffectiveDate,
    prod.Ignore,
    prod.CreatedBy,
    prod.CreatedDate,
    prod.UpdatedBy,
    prod.UpdatedDate,
    prod.VerifiedBy,
    prod.VerifiedDate
FROM ProdCalendar AS prod
JOIN TargetNewCurves AS tgt
    ON tgt.ShortName = prod.ShortName
LEFT JOIN dbo.ExportRateCalendar AS existing
    ON existing.ExportRateID = tgt.ExportRateID
   AND existing.ProcessDate = prod.ProcessDate
WHERE existing.CalendarID IS NULL;

SELECT @@ROWCOUNT AS RowsInserted;

SELECT
    erd.ShortName,
    ec.ExportRateID,
    ec.ProcessDate,
    ec.VerifiedBy
FROM dbo.ExportRateCalendar ec
JOIN dbo.ExportRateDefinitions erd
    ON erd.ExportRateID = ec.ExportRateID
WHERE ec.ProcessDate = @processDate
  AND erd.CreatedBy = 'TPP-8278'
ORDER BY erd.ShortName;
