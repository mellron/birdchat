USE CPMS
GO 

IF OBJECT_ID('SSISLOCCollateral', 'P') IS NOT NULL
    DROP PROCEDURE SSISLOCCollateral;
GO 

CREATE  PROCEDURE [dbo].[SSISLOCCollateral]
/***************************************************************************
Stored Procedure Description:
TPP-9415 - Returns ELOCCollateral data for the last ran batch in the format needed for output file  
Created stored procedure instead of view because view doesn't guarantee order by 

Created by: Tatiana Glistvain
Created when: 1/12/2026

Used By: CPMSExportLOCCollateralData SSIS package 
Modifications:

Date		By          Reason/What changed
--------	---------	-------------------
****************************************************************************/
AS 

--Header row Date
SELECT TOP 1 '"HDR"|' +  '"' + ISNULL(CONVERT(VARCHAR(8), AsOfDate, 112), '') + '"' AS RowData, 1 AS SortOrder
FROM ELOCCollateralData
WHERE runtime = (SELECT MAX(runtime) FROM ELOCCollateralData )

UNION ALL
-- Data rows headers 
SELECT '"AsOfDate"|"PledgeCode"|"CheckingBalance"|"SavingsBalance"|"UninsuredBalance"|"CollateralRequired"|"LetterOfCredit"|"ExcessCollateral"' AS RowData, 2 AS SortOrder

UNION ALL
-- Data rows
SELECT 
    '"' + ISNULL(CONVERT(VARCHAR(8), AsOfDate, 112), '') + '"'
    + '|"' + REPLACE(ISNULL(TRIM(PledgeCode), ''), '"', '""') + '"'
    + '|"' +ISNULL(FORMAT(CheckingBalance, 'G'), '') + '"'
    + '|"' + ISNULL(CONVERT(VARCHAR(30), SavingsBalance), '') + '"'
    + '|"' + ISNULL(CONVERT(VARCHAR(30), UninsuredBalance), '') + '"'
    + '|"' + ISNULL(CONVERT(VARCHAR(30), CollateralRequired), '') + '"'
    + '|"' + ISNULL(CONVERT(VARCHAR(30), LetterOfCredit), '') + '"'
    + '|"' + ISNULL(CONVERT(VARCHAR(30), ExcessCollateral), '') + '"'
AS RowData,
3 AS SortOrder
FROM ELOCCollateralData
WHERE runtime = (SELECT MAX(runtime) FROM ELOCCollateralData )

UNION ALL
-- Trailer row (record count)
SELECT '"TLR"|"' +  FORMAT(RecordCount, '0000000000')  + '"' AS RowData,4 AS SortOrder
FROM 
 (SELECT COUNT(*) AS RecordCount, AsOfDate
 FROM ELOCCollateralData   
 WHERE runtime = (SELECT MAX(runtime) FROM ELOCCollateralData )  
 GROUP BY AsOfDate) A 
 ORDER BY SortOrder 
GO 
