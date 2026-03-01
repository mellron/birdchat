USE CPMS
GO

/******************************************************************************
TPP-10223 - CPMS 2052A Create File SSIS
SSISConfigurations deployment script

Notes:
  - LOC_Collateral_FileName config rows are NOT included. The filename
    (LOCActive_MMDDYYYY.txt) is built dynamically via an expression on
    variable vLOCCollateralFileName at runtime.

  - LOCCollateral_FilePrefix rows ARE included. This drives the vLOCCollateralFilePrefix
    variable so the filename prefix can be changed without redeploying the package.

  - CPMSSendFileLocation rows are included for all environments. TPP-9415
    was only deployed to Development so these rows must be inserted for
    IT, UAT, and Production.

  - !! Confirm Production path with Diana/Glenn before running in Production !!

Created by:  detolle
Created when: 02/27/2026
******************************************************************************/

DELETE FROM [SSISConfigurations]
WHERE ConfigurationFilter IN ('CPMSSendFileLocation', 'LOCCollateral_FilePrefix')
GO

INSERT INTO [dbo].[SSISConfigurations] ( [ConfigurationFilter], [ConfiguredValue], [PackagePath], [ConfiguredValueType], [Environment], [PackageName]) VALUES ( N'CPMSSendFileLocation', N'\\us.bank-dns.com\NAS\pri\treasury-app_dev\FileTransfer\ConnectDirect\CPMS\Send\', N'\Package.Variables[User::vSendFileLocation].Properties[Value]', N'String', N'Development', N'All')
INSERT INTO [dbo].[SSISConfigurations] ( [ConfigurationFilter], [ConfiguredValue], [PackagePath], [ConfiguredValueType], [Environment], [PackageName]) VALUES ( N'CPMSSendFileLocation', N'\\us.bank-dns.com\NAS\pri\treasury-app_IT\FileTransfer\ConnectDirect\CPMS\Send\', N'\Package.Variables[User::vSendFileLocation].Properties[Value]', N'String', N'IT', N'All')
INSERT INTO [dbo].[SSISConfigurations] ( [ConfigurationFilter], [ConfiguredValue], [PackagePath], [ConfiguredValueType], [Environment], [PackageName]) VALUES ( N'CPMSSendFileLocation', N'\\us.bank-dns.com\NAS\pri\treasury-app_uat\FileTransfer\ConnectDirect\CPMS\Send\', N'\Package.Variables[User::vSendFileLocation].Properties[Value]', N'String', N'UAT', N'All')
INSERT INTO [dbo].[SSISConfigurations] ( [ConfigurationFilter], [ConfiguredValue], [PackagePath], [ConfiguredValueType], [Environment], [PackageName]) VALUES ( N'CPMSSendFileLocation', N'\\us.bank-dns.com\NAS\pri\treasury-app_prod\FileTransfer\ConnectDirect\CPMS\Send\', N'\Package.Variables[User::vSendFileLocation].Properties[Value]', N'String', N'Production', N'All')
GO

INSERT INTO [dbo].[SSISConfigurations] ( [ConfigurationFilter], [ConfiguredValue], [PackagePath], [ConfiguredValueType], [Environment], [PackageName]) VALUES ( N'LOCCollateral_FilePrefix', N'LOCActive_', N'\Package.Variables[User::vLOCCollateralFilePrefix].Properties[Value]', N'String', N'Development', N'CPMSExportActiveLOCCollateralData')
INSERT INTO [dbo].[SSISConfigurations] ( [ConfigurationFilter], [ConfiguredValue], [PackagePath], [ConfiguredValueType], [Environment], [PackageName]) VALUES ( N'LOCCollateral_FilePrefix', N'LOCActive_', N'\Package.Variables[User::vLOCCollateralFilePrefix].Properties[Value]', N'String', N'IT', N'CPMSExportActiveLOCCollateralData')
INSERT INTO [dbo].[SSISConfigurations] ( [ConfigurationFilter], [ConfiguredValue], [PackagePath], [ConfiguredValueType], [Environment], [PackageName]) VALUES ( N'LOCCollateral_FilePrefix', N'LOCActive_', N'\Package.Variables[User::vLOCCollateralFilePrefix].Properties[Value]', N'String', N'UAT', N'CPMSExportActiveLOCCollateralData')
INSERT INTO [dbo].[SSISConfigurations] ( [ConfigurationFilter], [ConfiguredValue], [PackagePath], [ConfiguredValueType], [Environment], [PackageName]) VALUES ( N'LOCCollateral_FilePrefix', N'LOCActive_', N'\Package.Variables[User::vLOCCollateralFilePrefix].Properties[Value]', N'String', N'Production', N'CPMSExportActiveLOCCollateralData')
GO
