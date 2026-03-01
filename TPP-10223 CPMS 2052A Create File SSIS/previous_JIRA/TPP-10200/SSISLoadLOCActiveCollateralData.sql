USE [CPMS]
GO


CREATE OR ALTER     PROCEDURE [dbo].[SSISLoadActiveLOCCollateralData]  
    ( @RetentionMonths INT = 13
	)
AS   
/*****************************************************************************  
Stored Procedure Description: TPP-10200 To Load data from Active loc report data to EActiveLocCollateralData table for SSIS package.
Created by:  Amarnath Tiwari
Created when: 02/18/2026 
Used By: CPMS SSIS Package. 
Modifications: 
  
Date		By			Reason/What changed  
--------	---------	-------------------  
********************************************************************************/  
  
  DECLARE  @StartDate DATETIME
  DECLARE  @AsofDate DATETIME
  DECLARE  @ACurrDate DATETIME
  
  SET @StartDate = CAST(GETDATE() AS DATE)
  SELECT @ACurrDate =  CurrDt FROM CPMSStat
  --- Calling function for Busines date
  SET @AsofDate =(SELECT  dbo.fnGetPreviousBusinessDate(@ACurrDate) )
   
   
   --- fetching records for Active LOC as per ReportLetterOfCreditActive
	SELECT		P.PldgCd,
				L.RefNum, 
				L.MaturityDate,  
				L.Amount
	INTO		#ActiveLoc
	FROM   
				CPMSStat,tblPldgPool P  
				INNER JOIN tblLetterOfCredit L ON P.PldgCd = L.PldgCd  
	WHERE		P.LofC = 1 
				AND L.Status = 'Active'  
				AND CurrDt BETWEEN IssueDate AND MaturityDate  
	ORDER BY	L.MaturityDate  , PldgCd

   INSERT INTO EActiveLOCCollateralData (  
				[AsOfDate],		
				[PledgeCode],	
				[ReferenceNumber],
				[MaturityDate],
				[Amount],
				[RunTime]	)
   SELECT   
				@AsofDate,  
				A.[PldgCd],    
				A.[RefNum],       
				A.[MaturityDate],           
				A.[Amount] ,
				GETDATE()
   FROM			#ActiveLoc A  
  
  
 -- Clear data older than 13 months.   
 DELETE EActiveLOCCollateralData   
 WHERE [AsOfDate] < DATEADD(m,-@RetentionMonths,@StartDate)  
  