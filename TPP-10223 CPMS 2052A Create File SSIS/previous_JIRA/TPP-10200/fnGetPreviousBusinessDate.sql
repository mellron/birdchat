USE CPMS;

GO
CREATE OR ALTER FUNCTION dbo.fnGetPreviousBusinessDate
(
   @InputDate DATE
)
Returns DATE
AS
/*****************************************************************************  
Description: Find the previous Business Date
Used By:  SSISLoadLOCCollateral  Originally created for SSISLoadLOCCollateral stored procedure but could be used by other processes. 
  
Created by:  Amarnath Tiwari
Created when: 01/13/2026
Modifications:  
  
Date		By			Reason/What changed  
--------	---------   ------------------  
01/13/2026  atiwari     TPP-9868  - Need previous business date for using for AsofDate column for SSISLoadLOCCollateral stored procedure.
*****************************************************************************/  
BEGIN
DECLARE @PrevDate DATE
SET @PrevDate =DATEADD(DAY,-1, @InputDate);

WHILE
(
	DATEPART(WEEKDAY, @PrevDate) in (1,7)
	OR
	EXISTS(SELECT * FROM [syn_vCPMSHoliday] WHERE [HolidayDate] = CAST(@PrevDate as DATE) )
)

BEGIN

	SET @PrevDate= DATEADD(DAy,-1,@PrevDate);
END

RETURN @PrevDate;

END


-- - Added Grant permission  for SystmesSupport for this function
GO
		 GRANT EXECUTE ON OBJECT::dbo.fnGetPreviousBusinessDate TO SystemsSupport;
GO