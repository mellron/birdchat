SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*****************************************************************************
Description: Stage bullet curve rates for export types DBC and DB2 into
             ExportRateValues for a given export date. Intended to support
             downstream SSIS exports that pivot DBC/DB2 daily curve values.

Notes:
- Deletes existing staged rows for DBC/DB2 on the same ExportDate before insert.
- Inserts both calculated (BaseRateType = 'C') and source (BaseRateType = 'S')
  rate values using latest available value on or before @exportDate.
- Requires verified ExportRateCalendar entry for the @exportDate.

Used By: BSDRate SSIS

Created by: AI assistant (based on existing staging patterns)
Created when: 2025-09-02
*****************************************************************************/
CREATE PROCEDURE [dbo].[SSISStageAnnualRatesForDBC]
    @exportDate date = NULL
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @exportTypeCode1 varchar(3) = 'DBC';
    DECLARE @exportTypeCode2 varchar(3) = 'DB2';

    -- SSIS cannot pass NULL; treat 12/30/1899 as NULL sentinel
    IF (ISNULL(@exportDate, '1899-12-30') = '1899-12-30')
    BEGIN
        SET @exportDate = CAST(GETDATE() AS date);
    END;

    -- Delete any existing ExportRateValues for DBC/DB2 on this export date.
    DELETE erv
    FROM ExportRateValues erv
    JOIN ExportRateDefinitions erd ON erd.ExportRateID = erv.ExportRateID
    JOIN LExportTypes et ON et.IID = erd.ExportTypeID
                         AND et.Code IN (@exportTypeCode1, @exportTypeCode2)
    WHERE erv.ExportDate = @exportDate;

    -- Insert calculated rate values (BaseRateType = 'C') using latest value <= @exportDate.
    INSERT INTO ExportRateValues (ExportRateID, ExportDate, EffectiveDate, RateDate, ProcessedDate, Value)
    SELECT
        erd.ExportRateID,
        erc.ProcessDate,
        erc.EffectiveDate,
        crv.CalculatedDate,
        GETDATE(),
        crv.Value
    FROM ExportRateDefinitions erd
    JOIN LExportTypes et
        ON et.IID = erd.ExportTypeID
       AND et.Code IN (@exportTypeCode1, @exportTypeCode2)
    JOIN ExportRateCalendar erc
        ON erc.ExportRateID = erd.ExportRateID
       AND erc.ProcessDate = @exportDate
       AND erc.VerifiedBy IS NOT NULL
    JOIN CalculatedRateValues crv
        ON crv.CalculatedRateID = erd.BaseRateID
       AND crv.CalculatedDate = (
            SELECT MAX(CalculatedDate)
            FROM CalculatedRateValues
            WHERE CalculatedRateID = erd.BaseRateID
              AND CalculatedDate <= @exportDate)
    WHERE erd.BaseRateType = 'C'
      AND ISNULL(erd.TerminationDate, @exportDate) <= @exportDate;

    -- Insert source rate values (BaseRateType = 'S') using latest value <= @exportDate.
    INSERT INTO ExportRateValues (ExportRateID, ExportDate, EffectiveDate, RateDate, ProcessedDate, Value)
    SELECT
        erd.ExportRateID,
        erc.ProcessDate,
        erc.EffectiveDate,
        srv.RateDate,
        GETDATE(),
        srv.Value
    FROM ExportRateDefinitions erd
    JOIN LExportTypes et
        ON et.IID = erd.ExportTypeID
       AND et.Code IN (@exportTypeCode1, @exportTypeCode2)
    JOIN ExportRateCalendar erc
        ON erc.ExportRateID = erd.ExportRateID
       AND erc.ProcessDate = @exportDate
       AND erc.VerifiedBy IS NOT NULL
    JOIN SourceRateValues srv
        ON srv.SourceRateID = erd.BaseRateID
       AND srv.RateDate = (
            SELECT MAX(RateDate)
            FROM SourceRateValues
            WHERE SourceRateID = erd.BaseRateID
              AND RateDate <= @exportDate)
    WHERE erd.BaseRateType = 'S'
      AND ISNULL(erd.TerminationDate, @exportDate) <= @exportDate;
END
GO

