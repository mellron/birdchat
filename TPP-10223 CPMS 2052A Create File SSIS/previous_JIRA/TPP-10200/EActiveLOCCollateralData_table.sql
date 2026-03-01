USE [CPMS]
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[EActiveLOCCollateralData]') AND type in (N'U'))
BEGIN
	DROP TABLE [dbo].[EActiveLOCCollateralData]
	PRINT 'Table EActiveLOCCollateralData has been dropped'
END
GO

CREATE TABLE [dbo].[EActiveLOCCollateralData](
	[IID] [int] IDENTITY(1,1) NOT NULL,
	[AsOfDate] [datetime] NOT NULL,
	[PledgeCode] [dbo].[typPledgeCode] NOT NULL,
	[ReferenceNumber] VARCHAR(25) NOT NULL,
	[MaturityDate] [datetime] NOT NULL,
	[Amount] [numeric](20, 2) NULL,
	[RunTime] [datetime] NOT NULL,
 CONSTRAINT [pkEActiveLOCCollateralData] PRIMARY KEY CLUSTERED 
(
	[IID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
GO


