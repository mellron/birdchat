USE CPMS
GO 

IF OBJECT_ID('SSISActiveLOCCollateral', 'P') IS NOT NULL
    DROP PROCEDURE SSISActiveLOCCollateral;
GO 

CREATE  PROCEDURE [dbo].[SSISActiveLOCCollateral]
/***************************************************************************
Stored Procedure Description: TPP-10200 - Returns EActiveLOCCollateralData data for the last ran batch in the format needed for output file  
Created by: Amarnath Tiwari
Created when: 02/18/2026

Used By: SSIS package generate Active Loc file.
Modifications:

Date		By          Reason/What changed
--------	---------	-------------------
****************************************************************************/
AS 

--Header row Date
SELECT TOP 1 '"HDR"|' +  '"' + ISNULL(CONVERT(CHAR(8), AsOfDate, 112), '') + '"' AS RowData, 1 AS SortOrder
FROM EActiveLOCCollateralData
WHERE runtime = (SELECT MAX(runtime) FROM EActiveLOCCollateralData )

UNION ALL
-- Data rows headers 
SELECT '"AsOfDate"|"PledgeCode"|"ReferenceNumber"|"MaturityDate"|"Amount"' AS RowData, 2 AS SortOrder

UNION ALL
-- Data rows
SELECT 
    '"'+ ISNULL(CONVERT(VARCHAR(8), AsOfDate, 112), '') + '"'
    + '|"' + REPLACE(ISNULL(TRIM(PledgeCode), ''), '"', '""') + '"'
   + '|"' +ISNULL(ReferenceNumber, '') + '"'
    + '|"' + ISNULL(CONVERT(VARCHAR(8), MaturityDate,112), '') + '"'
    + '|"' + ISNULL(CONVERT(VARCHAR(30), Amount), '') + '"'
AS RowData,
3 AS SortOrder
FROM EActiveLOCCollateralData
WHERE runtime = (SELECT MAX(runtime) FROM EActiveLOCCollateralData )

UNION ALL
-- Trailer row (record count)
SELECT '"TLR"|"' +  FORMAT(RecordCount, '0000000000')  + '"' AS RowData,4 AS SortOrder
FROM 
 (SELECT COUNT(*) AS RecordCount, AsOfDate
 FROM EActiveLOCCollateralData   
 WHERE runtime = (SELECT MAX(runtime) FROM EActiveLOCCollateralData )  
 GROUP BY AsOfDate) A 
 ORDER BY SortOrder 
GO 
