USE [BSDRate]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

/*****************************************************************************
Description: Export Daily Curve (MRO) values for SSIS using bullet curve
             definitions across DBC and DB2 export types. Produces columns:
             CURVE, Date, O/N, 7D, 14D, 21D, 1M-12M, 24M, 36M, 48M, 60M,
             72M, 84M, 120M, 180M, 240M, 360M, Fedtar.

Notes:
- Pulls from ExportRateDefinitions/ExportRateValues joined to
  CalculatedRateDefinitions and LCurrencies.
- Includes both export type codes DBC and DB2 to cover full tenor range.
- Fedtar is included as a column; if no bullet-curve Fed target definition
  exists under DBC/DB2, it will return NULL.

Created by: detolle (based on SSISExportAnnualRatesForMRO)
Created when: 2025-08-29
*****************************************************************************/
CREATE OR ALTER PROCEDURE [dbo].[SSISExportDailyCurveMRO]
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
    END

    ;WITH BulletCurve AS (
        SELECT
            CurrencyCode = c.Code,
            erv.RateDate,
            erd.ShortName,
            erv.Value
        FROM ExportRateDefinitions erd
        JOIN LExportTypes et
            ON et.IID = erd.ExportTypeID
           AND et.Code IN (@exportTypeCode1, @exportTypeCode2)
        JOIN CalculatedRateDefinitions crd
            ON crd.CalculatedRateID = erd.BaseRateID
        JOIN LCurrencies c
            ON c.IID = crd.CurrencyID
        JOIN ExportRateValues erv
            ON erv.ExportRateID = erd.ExportRateID
           AND erv.ExportDate = @exportDate
        WHERE erd.ShortName IN (
            '1daybulletcurve','7daybulletcurve','14daybulletcurve','21daybulletcurve',
            '1mobulletcurve','2mobulletcurve','3mobulletcurve','4mobulletcurve','5mobulletcurve','6mobulletcurve',
            '7mobulletcurve','8mobulletcurve','9mobulletcurve','10mobulletcurve','11mobulletcurve','12mobulletcurve',
            '24mobulletcurve','36mobulletcurve','48mobulletcurve','60mobulletcurve','72mobulletcurve','84mobulletcurve',
            '120mobulletcurve','180mobulletcurve','240mobulletcurve','360mobulletcurve'
        )
    ),
    Pivoted AS (
        SELECT
            CurrencyCode,
            RateDate,
            [1daybulletcurve],
            [7daybulletcurve],
            [14daybulletcurve],
            [21daybulletcurve],
            [1mobulletcurve],[2mobulletcurve],[3mobulletcurve],[4mobulletcurve],[5mobulletcurve],[6mobulletcurve],
            [7mobulletcurve],[8mobulletcurve],[9mobulletcurve],[10mobulletcurve],[11mobulletcurve],[12mobulletcurve],
            [24mobulletcurve],[36mobulletcurve],[48mobulletcurve],[60mobulletcurve],[72mobulletcurve],[84mobulletcurve],
            [120mobulletcurve],[180mobulletcurve],[240mobulletcurve],[360mobulletcurve]
        FROM BulletCurve AS src
        PIVOT (
            MAX(Value) FOR ShortName IN (
                [1daybulletcurve],[7daybulletcurve],[14daybulletcurve],[21daybulletcurve],
                [1mobulletcurve],[2mobulletcurve],[3mobulletcurve],[4mobulletcurve],[5mobulletcurve],[6mobulletcurve],
                [7mobulletcurve],[8mobulletcurve],[9mobulletcurve],[10mobulletcurve],[11mobulletcurve],[12mobulletcurve],
                [24mobulletcurve],[36mobulletcurve],[48mobulletcurve],[60mobulletcurve],[72mobulletcurve],[84mobulletcurve],
                [120mobulletcurve],[180mobulletcurve],[240mobulletcurve],[360mobulletcurve]
            )
        ) AS p
    )
    SELECT
        [CURVE]  = CurrencyCode,
        [Date]   = CONVERT(varchar, RateDate, 101),
        [O/N]    = CAST(([1daybulletcurve] * 100) AS varchar),
        [7D]     = CAST(([7daybulletcurve] * 100) AS varchar),
        [14D]    = CAST(([14daybulletcurve] * 100) AS varchar),
        [21D]    = CAST(([21daybulletcurve] * 100) AS varchar),
        [1M]     = CAST(([1mobulletcurve] * 100) AS varchar),
        [2M]     = CAST(([2mobulletcurve] * 100) AS varchar),
        [3M]     = CAST(([3mobulletcurve] * 100) AS varchar),
        [4M]     = CAST(([4mobulletcurve] * 100) AS varchar),
        [5M]     = CAST(([5mobulletcurve] * 100) AS varchar),
        [6M]     = CAST(([6mobulletcurve] * 100) AS varchar),
        [7M]     = CAST(([7mobulletcurve] * 100) AS varchar),
        [8M]     = CAST(([8mobulletcurve] * 100) AS varchar),
        [9M]     = CAST(([9mobulletcurve] * 100) AS varchar),
        [10M]    = CAST(([10mobulletcurve] * 100) AS varchar),
        [11M]    = CAST(([11mobulletcurve] * 100) AS varchar),
        [12M]    = CAST(([12mobulletcurve] * 100) AS varchar),
        [24M]    = CAST(([24mobulletcurve] * 100) AS varchar),
        [36M]    = CAST(([36mobulletcurve] * 100) AS varchar),
        [48M]    = CAST(([48mobulletcurve] * 100) AS varchar),
        [60M]    = CAST(([60mobulletcurve] * 100) AS varchar),
        [72M]    = CAST(([72mobulletcurve] * 100) AS varchar),
        [84M]    = CAST(([84mobulletcurve] * 100) AS varchar),
        [120M]   = CAST(([120mobulletcurve] * 100) AS varchar),
        [180M]   = CAST(([180mobulletcurve] * 100) AS varchar),
        [240M]   = CAST(([240mobulletcurve] * 100) AS varchar),
        [360M]   = CAST(([360mobulletcurve] * 100) AS varchar),
        [Fedtar] = NULL  -- populate if a DBC/DB2 Fed target definition exists
    FROM Pivoted
    ORDER BY CURVE, RateDate;
END

GO

