

USE CPMS 
GO 

DELETE FROM [SSISConfigurations] 
WHERE ConfigurationFilter in ('LOC_Collateral_FileName','CPMSSendFileLocation')
GO 

INSERT INTO [dbo].[SSISConfigurations] ( [ConfigurationFilter], [ConfiguredValue], [PackagePath], [ConfiguredValueType], [Environment], [PackageName]) VALUES ( N'LOC_Collateral_FileName', N'LOC_Collateral.txt', N'\Package.Variables[User::vLOCCollateralFileName].Properties[Value]', N'String', N'Development', N'CPMSExportLOCCollateralData')
INSERT INTO [dbo].[SSISConfigurations] ( [ConfigurationFilter], [ConfiguredValue], [PackagePath], [ConfiguredValueType], [Environment], [PackageName]) VALUES ( N'LOC_Collateral_FileName', N'LOC_Collateral.txt', N'\Package.Variables[User::vLOCCollateralFileName].Properties[Value]', N'String', N'IT', N'CPMSExportLOCCollateralData')
INSERT INTO [dbo].[SSISConfigurations] ( [ConfigurationFilter], [ConfiguredValue], [PackagePath], [ConfiguredValueType], [Environment], [PackageName]) VALUES ( N'LOC_Collateral_FileName', N'LOC_Collateral.txt', N'\Package.Variables[User::vLOCCollateralFileName].Properties[Value]', N'String', N'UAT', N'CPMSExportLOCCollateralData')
INSERT INTO [dbo].[SSISConfigurations] ( [ConfigurationFilter], [ConfiguredValue], [PackagePath], [ConfiguredValueType], [Environment], [PackageName]) VALUES ( N'LOC_Collateral_FileName', N'LOC_Collateral.txt', N'\Package.Variables[User::vLOCCollateralFileName].Properties[Value]', N'String', N'Production', N'CPMSExportLOCCollateralData')
GO 

INSERT INTO [dbo].[SSISConfigurations] ( [ConfigurationFilter], [ConfiguredValue], [PackagePath], [ConfiguredValueType], [Environment], [PackageName]) VALUES ( N'CPMSSendFileLocation', N'\\us.bank-dns.com\NAS\pri\treasury-app_dev\FileTransfer\ConnectDirect\CPMS\Send\', N'\Package.Variables[User::vSendFileLocation].Properties[Value]', N'String', N'Development', N'All')
INSERT INTO [dbo].[SSISConfigurations] ( [ConfigurationFilter], [ConfiguredValue], [PackagePath], [ConfiguredValueType], [Environment], [PackageName]) VALUES ( N'CPMSSendFileLocation', N'\\us.bank-dns.com\NAS\pri\treasury-app_IT\FileTransfer\ConnectDirect\CPMS\Send\', N'\Package.Variables[User::vSendFileLocation].Properties[Value]', N'String', N'IT', N'All')
INSERT INTO [dbo].[SSISConfigurations] ( [ConfigurationFilter], [ConfiguredValue], [PackagePath], [ConfiguredValueType], [Environment], [PackageName]) VALUES ( N'CPMSSendFileLocation', N'\\us.bank-dns.com\NAS\pri\treasury-app_uat\FileTransfer\ConnectDirect\CPMS\Send\', N'\Package.Variables[User::vSendFileLocation].Properties[Value]', N'String', N'UAT', N'All')
INSERT INTO [dbo].[SSISConfigurations] ( [ConfigurationFilter], [ConfiguredValue], [PackagePath], [ConfiguredValueType], [Environment], [PackageName]) VALUES ( N'CPMSSendFileLocation', N'\\us.bank-dns.com\NAS\pri\treasury-app_prod\FileTransfer\ConnectDirect\CPMS\Send\', N'\Package.Variables[User::vSendFileLocation].Properties[Value]', N'String', N'Production', N'All')
GO 

