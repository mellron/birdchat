USE BSDRate;
GO

/*
    `.sql

    Purpose: Generate portable INSERT statements for ExportRateCalendar rows so
             the data can be replayed in another environment. Rows are matched
             by ExportRateDefinitions.ShortName so the insert can resolve the
             destination ExportRateID dynamically.

    Instructions:
    - Set @processDate to the calendar date you need to migrate.
    - Adjust the filter on CreatedBy/CreatedDate (or replace with an explicit
      ShortName list) to target only the rows you want to script.
    - Run the query and copy the InsertStatement output; those statements can be
      executed in the target environment after verifying prerequisites.
*/

DECLARE @processDate date = '2025-12-01';
DECLARE @crlf char(2) = CHAR(13) + CHAR(10);

;WITH SourceRows AS (
    SELECT
        erd.ShortName,
        et.Code AS ExportTypeCode,
        c.ProcessDate,
        c.EffectiveDate,
        c.Ignore,
        c.CreatedBy,
        c.CreatedDate,
        c.UpdatedBy,
        c.UpdatedDate,
        c.VerifiedBy,
        c.VerifiedDate
    FROM dbo.ExportRateCalendar AS c
    JOIN dbo.ExportRateDefinitions AS erd
        ON erd.ExportRateID = c.ExportRateID
    JOIN dbo.LExportTypes AS et
        ON et.IID = erd.ExportTypeID
    WHERE c.ProcessDate = @processDate
      AND et.Code IN ('DBC', 'DB2')
      AND erd.CreatedBy = 'TPP-8278'           -- narrow to the new curves seeded by PopulateMROExportRate.sql
      AND erd.CreatedDate >= '2025-06-24'      -- adjust or replace with explicit ShortName list as needed
),
ValueFormats AS (
    SELECT
        src.ShortName,
        src.ExportTypeCode,
        ProcessDateIso    = CONVERT(varchar(10), src.ProcessDate, 121),
        EffectiveDateIso  = CONVERT(varchar(10), src.EffectiveDate, 121),
        CreatedDateIso    = CONVERT(varchar(23), src.CreatedDate, 121),
        UpdatedDateIso    = CONVERT(varchar(23), src.UpdatedDate, 121),
        VerifiedDateIso   = CONVERT(varchar(23), src.VerifiedDate, 121),
        IgnoreLiteral     = CASE WHEN src.Ignore IS NULL THEN 'NULL' ELSE CAST(src.Ignore AS varchar(1)) END,
        ShortNameEscaped  = REPLACE(src.ShortName, '''', ''''''),
        CodeEscaped       = REPLACE(src.ExportTypeCode, '''', ''''''),
        CreatedByEscaped  = CASE WHEN src.CreatedBy IS NULL THEN NULL ELSE REPLACE(src.CreatedBy, '''', '''''') END,
        UpdatedByEscaped  = CASE WHEN src.UpdatedBy IS NULL THEN NULL ELSE REPLACE(src.UpdatedBy, '''', '''''') END,
        VerifiedByEscaped = CASE WHEN src.VerifiedBy IS NULL THEN NULL ELSE REPLACE(src.VerifiedBy, '''', '''''') END
    FROM SourceRows AS src
)
SELECT
    InsertStatement =
        CAST('-- ShortName: ' + vf.ShortName + ' | ExportType: ' + vf.ExportTypeCode + @crlf AS varchar(max)) +
        'IF NOT EXISTS (' + @crlf +
        '    SELECT 1' + @crlf +
        '    FROM ExportRateCalendar ec' + @crlf +
        '    JOIN ExportRateDefinitions erd ON erd.ExportRateID = ec.ExportRateID' + @crlf +
        '    JOIN LExportTypes et ON et.IID = erd.ExportTypeID' + @crlf +
        '    WHERE erd.ShortName = ''' + vf.ShortNameEscaped + '''' + @crlf +
        '      AND et.Code = ''' + vf.CodeEscaped + '''' + @crlf +
        '      AND ec.ProcessDate = ''' + vf.ProcessDateIso + '''' + @crlf +
        ')' + @crlf +
        'BEGIN' + @crlf +
        '    INSERT INTO ExportRateCalendar (' + @crlf +
        '        ExportRateID,' + @crlf +
        '        ProcessDate,' + @crlf +
        '        EffectiveDate,' + @crlf +
        '        Ignore,' + @crlf +
        '        CreatedBy,' + @crlf +
        '        CreatedDate,' + @crlf +
        '        UpdatedBy,' + @crlf +
        '        UpdatedDate,' + @crlf +
        '        VerifiedBy,' + @crlf +
        '        VerifiedDate' + @crlf +
        '    )' + @crlf +
        '    SELECT TOP (1)' + @crlf +
        '        erd.ExportRateID,' + @crlf +
        '        ''' + vf.ProcessDateIso + ''',' + @crlf +
        '        ' + CASE WHEN vf.EffectiveDateIso IS NULL THEN 'NULL' ELSE CONCAT('''', vf.EffectiveDateIso, '''') END + ',' + @crlf +
        '        ' + vf.IgnoreLiteral + ',' + @crlf +
        '        ' + CASE WHEN vf.CreatedByEscaped IS NULL THEN 'NULL' ELSE CONCAT('''', vf.CreatedByEscaped, '''') END + ',' + @crlf +
        '        ' + CASE WHEN vf.CreatedDateIso IS NULL THEN 'NULL' ELSE CONCAT('''', vf.CreatedDateIso, '''') END + ',' + @crlf +
        '        ' + CASE WHEN vf.UpdatedByEscaped IS NULL THEN 'NULL' ELSE CONCAT('''', vf.UpdatedByEscaped, '''') END + ',' + @crlf +
        '        ' + CASE WHEN vf.UpdatedDateIso IS NULL THEN 'NULL' ELSE CONCAT('''', vf.UpdatedDateIso, '''') END + ',' + @crlf +
        '        ' + CASE WHEN vf.VerifiedByEscaped IS NULL THEN 'NULL' ELSE CONCAT('''', vf.VerifiedByEscaped, '''') END + ',' + @crlf +
        '        ' + CASE WHEN vf.VerifiedDateIso IS NULL THEN 'NULL' ELSE CONCAT('''', vf.VerifiedDateIso, '''') END + @crlf +
        '    FROM ExportRateDefinitions erd' + @crlf +
        '    JOIN LExportTypes et ON et.IID = erd.ExportTypeID' + @crlf +
        '    WHERE erd.ShortName = ''' + vf.ShortNameEscaped + '''' + @crlf +
        '      AND et.Code = ''' + vf.CodeEscaped + ''';' + @crlf +
        'END'
FROM ValueFormats AS vf
ORDER BY vf.ExportTypeCode, vf.ShortName;
