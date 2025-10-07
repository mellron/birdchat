-- SSIS Configuration scripts
USE SystemsMaster
GO

-- Drop WorkdayAuthURL
IF EXISTS (SELECT 1 FROM SystemsMaster.dbo.SSISConfigurations WHERE ConfigurationFilter = 'WorkdayAuthURL')
BEGIN
    DELETE FROM SystemsMaster.dbo.SSISConfigurations WHERE ConfigurationFilter = 'WorkdayAuthURL' And PackageName='TPIGLUpload_Workday.dtsx' And Environment='Development' And ApplicationName='TPI'
END

-- Drop WorkdayImportURL
IF EXISTS (SELECT 1 FROM SystemsMaster.dbo.SSISConfigurations WHERE ConfigurationFilter = 'WorkdayImportURL')
BEGIN
    DELETE FROM SystemsMaster.dbo.SSISConfigurations WHERE ConfigurationFilter = 'WorkdayImportURL' And PackageName='TPIGLUpload_Workday.dtsx' And Environment='Development' And ApplicationName='TPI'
END

-- Drop WorkdayStatusURL
IF EXISTS (SELECT 1 FROM SystemsMaster.dbo.SSISConfigurations WHERE ConfigurationFilter = 'WorkdayStatusURL')
BEGIN
    DELETE FROM SystemsMaster.dbo.SSISConfigurations WHERE ConfigurationFilter = 'WorkdayStatusURL'And PackageName='TPIGLUpload_Workday.dtsx' And Environment='Development' And ApplicationName='TPI'
END

-- Drop WorkdayCert
IF EXISTS (SELECT 1 FROM SystemsMaster.dbo.SSISConfigurations WHERE ConfigurationFilter = 'WorkdayCert')
BEGIN
    DELETE FROM SystemsMaster.dbo.SSISConfigurations WHERE ConfigurationFilter = 'WorkdayCert'And PackageName='TPIGLUpload_Workday.dtsx' And Environment='Development' And ApplicationName='TPI'
END

-- Drop WorkdayCertPassphrase
IF EXISTS (SELECT 1 FROM SystemsMaster.dbo.SSISConfigurations WHERE ConfigurationFilter = 'WorkdayCertPassphrase')
BEGIN
    DELETE FROM SystemsMaster.dbo.SSISConfigurations WHERE ConfigurationFilter = 'WorkdayCertPassphrase'And PackageName='TPIGLUpload_Workday.dtsx' And Environment='Development' And ApplicationName='TPI'
END

-- Drop ConsumerKey
IF EXISTS (SELECT 1 FROM SystemsMaster.dbo.SSISConfigurations WHERE ConfigurationFilter = 'ConsumerKey')
BEGIN
    DELETE FROM SystemsMaster.dbo.SSISConfigurations WHERE ConfigurationFilter = 'ConsumerKey'And PackageName='TPIGLUpload_Workday.dtsx' And Environment='Development' And ApplicationName='TPI'
END

-- Drop ConsumerSecret
IF EXISTS (SELECT 1 FROM SystemsMaster.dbo.SSISConfigurations WHERE ConfigurationFilter = 'ConsumerSecret')
BEGIN
    DELETE FROM SystemsMaster.dbo.SSISConfigurations WHERE ConfigurationFilter = 'ConsumerSecret'And PackageName='TPIGLUpload_Workday.dtsx' And Environment='Development' And ApplicationName='TPI'
END

-- Drop HashiCorpVaultURL
IF EXISTS (SELECT 1 FROM SystemsMaster.dbo.SSISConfigurations WHERE ConfigurationFilter = 'HashiCorpVaultURL')
BEGIN
    DELETE FROM SystemsMaster.dbo.SSISConfigurations WHERE ConfigurationFilter = 'HashiCorpVaultURL' And PackageName='TPIGLUpload_Workday.dtsx' And Environment='Development' And ApplicationName='TPI'
END

-- Drop HashiSecretName
IF EXISTS (SELECT 1 FROM SystemsMaster.dbo.SSISConfigurations WHERE ConfigurationFilter = 'HashiSecretName')
BEGIN
    DELETE FROM SystemsMaster.dbo.SSISConfigurations WHERE ConfigurationFilter = 'HashiSecretName' And PackageName='TPIGLUpload_Workday.dtsx' And Environment='Development' And ApplicationName='TPI'
END

-- Drop CarID
IF EXISTS (SELECT 1 FROM SystemsMaster.dbo.SSISConfigurations WHERE ConfigurationFilter = 'CarID')
BEGIN
    DELETE FROM SystemsMaster.dbo.SSISConfigurations WHERE ConfigurationFilter = 'CarID' And PackageName='TPIGLUpload_Workday.dtsx' And Environment='Development' And ApplicationName='TPI'
END

-- Drop HashiCorpRoleID
IF EXISTS (SELECT 1 FROM SystemsMaster.dbo.SSISConfigurations WHERE ConfigurationFilter = 'HashiCorpRoleID')
BEGIN
    DELETE FROM SystemsMaster.dbo.SSISConfigurations WHERE ConfigurationFilter = 'HashiCorpRoleID' And PackageName='TPIGLUpload_Workday.dtsx' And Environment='Development' And ApplicationName='TPI'
END

-- Drop HashiCorpEnvVarable
IF EXISTS (SELECT 1 FROM SystemsMaster.dbo.SSISConfigurations WHERE ConfigurationFilter = 'HashiCorpEnvVarable')
BEGIN
    DELETE FROM SystemsMaster.dbo.SSISConfigurations WHERE ConfigurationFilter = 'HashiCorpEnvVarable' And PackageName='TPIGLUpload_Workday.dtsx' And Environment='Development' And ApplicationName='TPI'
END

-- Drop HashiCorpKeyName
IF EXISTS (SELECT 1 FROM SystemsMaster.dbo.SSISConfigurations WHERE ConfigurationFilter = 'HashiCorpKeyName')
BEGIN
    DELETE FROM SystemsMaster.dbo.SSISConfigurations WHERE ConfigurationFilter = 'HashiCorpKeyName' And PackageName='TPIGLUpload_Workday.dtsx' And Environment='Development' And ApplicationName='TPI'
END

-- Drop HashiCorpVersion
IF EXISTS (SELECT 1 FROM SystemsMaster.dbo.SSISConfigurations WHERE ConfigurationFilter = 'HashiCorpVersion')
BEGIN
    DELETE FROM SystemsMaster.dbo.SSISConfigurations WHERE ConfigurationFilter = 'HashiCorpVersion' And PackageName='TPIGLUpload_Workday.dtsx' And Environment='Development' And ApplicationName='TPI'
END

-- DROP WorkdayXMLCompany
IF EXISTS (SELECT 1 FROM SystemsMaster.dbo.SSISConfigurations WHERE ConfigurationFilter = 'WorkdayXMLCompany')
BEGIN
    DELETE FROM SystemsMaster.dbo.SSISConfigurations WHERE ConfigurationFilter = 'WorkdayXMLCompany' And PackageName='TPIGLUpload_Workday.dtsx' And Environment='Development' And ApplicationName='TPI'
END

-- DROP SystemsEmail
IF EXISTS (SELECT 1 FROM SystemsMaster.dbo.SSISConfigurations WHERE ConfigurationFilter = 'SystemsEmail')
BEGIN
    DELETE FROM SystemsMaster.dbo.SSISConfigurations WHERE ConfigurationFilter = 'SystemsEmail' And PackageName='TPIGLUpload_Workday.dtsx'
END

-- lets add SystemsEmail with value of treasurysystemssupport@usbank.com
INSERT INTO SystemsMaster.dbo.SSISConfigurations
           (ConfigurationFilter
           ,ConfiguredValue
           ,PackagePath
           ,ConfiguredValueType
           ,Environment
           ,ApplicationName
           ,PackageName)
     VALUES
           ('SystemsEmail'
           ,'treasurysystemssupport@usbank.com'
           ,'\Package.Variables[User::SystemsEmail].Properties[Value]'
           ,'String'
           ,'Development'
           ,'TPI'
           ,'TPIGLUpload_Workday.dtsx')

-- Lets make one for WorkdayXMLCompany with the value of 300
INSERT INTO SystemsMaster.dbo.SSISConfigurations
           (ConfigurationFilter
           ,ConfiguredValue
           ,PackagePath
           ,ConfiguredValueType
           ,Environment
           ,ApplicationName
           ,PackageName)
     VALUES
           ('WorkdayXMLCompany'
           ,'300'
           ,'\Package.Variables[User::WorkdayXMLCompany].Properties[Value]'
           ,'String'
           ,'Development'
           ,'TPI'
           ,'TPIGLUpload_Workday.dtsx')


INSERT INTO SystemsMaster.dbo.SSISConfigurations
           (ConfigurationFilter
           ,ConfiguredValue
           ,PackagePath
           ,ConfiguredValueType
           ,Environment
           ,ApplicationName
           ,PackageName)
     VALUES
           ('WorkdayAuthURL'
           ,'https://dev-api2.us.bank-dns.com/auth/oauth2/v1/token'
           ,'\Package.Variables[User::WorkdayAuthURL].Properties[Value]'
           ,'String'
           ,'Development'
           ,'TPI'
           ,'TPIGLUpload_Workday.dtsx')


-- Lets make one for WorkdayImportURL value https://dev-api2.us.bank-dns.com/third-party/workday/postgl/v1/import-accounting-journal
INSERT INTO SystemsMaster.dbo.SSISConfigurations
           (ConfigurationFilter
           ,ConfiguredValue
           ,PackagePath
           ,ConfiguredValueType
           ,Environment
           ,ApplicationName
           ,PackageName)
     VALUES
           ('WorkdayImportURL'
           ,'https://dev-api2.us.bank-dns.com/third-party/workday/postgl/v1/import-accounting-journal'
           ,'\Package.Variables[User::WorkdayImportURL].Properties[Value]'
           ,'String'
           ,'Development'
           ,'TPI'
           ,'TPIGLUpload_Workday.dtsx')

-- Now WorkdayStatusURL and https://dev-api2.us.bank-dns.com/third-party/workday/postgl/v1/get-status
INSERT INTO SystemsMaster.dbo.SSISConfigurations
           (ConfigurationFilter
           ,ConfiguredValue
           ,PackagePath
           ,ConfiguredValueType
           ,Environment
           ,ApplicationName
           ,PackageName)
     VALUES
           ('WorkdayStatusURL'
           ,'https://dev-api2.us.bank-dns.com/third-party/workday/postgl/v1/get-status'
           ,'\Package.Variables[User::WorkdayStatusURL].Properties[Value]'
           ,'String'
           ,'Development'
           ,'TPI'
           ,'TPIGLUpload_Workday.dtsx')

-- WorkdayCert value of 'MyCert'
INSERT INTO SystemsMaster.dbo.SSISConfigurations
           (ConfigurationFilter
           ,ConfiguredValue
           ,PackagePath
           ,ConfiguredValueType
           ,Environment
           ,ApplicationName
           ,PackageName)
     VALUES
           ('WorkdayCert'
           ,'D:\Development_GIT\GitLab\personal\misc\workdayapitest\certificates\workdayhcmapigeejwttest.pfx'
           ,'\Package.Variables[User::WorkdayCert].Properties[Value]'
           ,'String'
           ,'Development'
           ,'TPI'
           ,'TPIGLUpload_Workday.dtsx')

-- WorkdayCertPassphrase value of MyPassphrase
INSERT INTO SystemsMaster.dbo.SSISConfigurations
           (ConfigurationFilter
           ,ConfiguredValue
           ,PackagePath
           ,ConfiguredValueType
           ,Environment
           ,ApplicationName
           ,PackageName)
     VALUES
           ('WorkdayCertPassphrase'
           ,'ISU_API_User'
           ,'\Package.Variables[User::WorkdayCertPassphrase].Properties[Value]'
           ,'String'
           ,'Development'
           ,'TPI'
           ,'TPIGLUpload_Workday.dtsx')

-- ConsumerKey  value of MyKey
INSERT INTO SystemsMaster.dbo.SSISConfigurations
           (ConfigurationFilter
           ,ConfiguredValue
           ,PackagePath
           ,ConfiguredValueType
           ,Environment
           ,ApplicationName
           ,PackageName)
     VALUES
           ('ConsumerKey'
           ,'oHVvOn3N3y6r3ghHpQvCGjwJYRoIJYne'
           ,'\Package.Variables[User::ConsumerKey].Properties[Value]'
           ,'String'
           ,'Development'
           ,'TPI'
           ,'TPIGLUpload_Workday.dtsx')

-- ConsumerSecret value of MySecret
INSERT INTO SystemsMaster.dbo.SSISConfigurations
           (ConfigurationFilter
           ,ConfiguredValue
           ,PackagePath
           ,ConfiguredValueType
           ,Environment
           ,ApplicationName
           ,PackageName)
     VALUES
           ('ConsumerSecret'
           ,'BgB7bKiHktVPqfG2'
           ,'\Package.Variables[User::ConsumerSecret].Properties[Value]'
           ,'String'
           ,'Development'
           ,'TPI'
           ,'TPIGLUpload_Workday.dtsx')

-- HashiCorpVaultURL value from Parameterexample.txt
INSERT INTO SystemsMaster.dbo.SSISConfigurations
           (ConfigurationFilter
           ,ConfiguredValue
           ,PackagePath
           ,ConfiguredValueType
           ,Environment
           ,ApplicationName
           ,PackageName)
     VALUES
           ('HashiCorpVaultURL'
           ,'https://hashicorp-vault-test.us.bank-dns.com'
           ,'\Package.Variables[User::HashiCorpVaultURL].Properties[Value]'
           ,'String'
           ,'Development'
           ,'TPI'
           ,'TPIGLUpload_Workday.dtsx')

-- HashiSecretName from Parameterexample.txt
INSERT INTO SystemsMaster.dbo.SSISConfigurations
           (ConfigurationFilter
           ,ConfiguredValue
           ,PackagePath
           ,ConfiguredValueType
           ,Environment
           ,ApplicationName
           ,PackageName)
     VALUES
           ('HashiSecretName'
           ,'dev/workaytpigl'
           ,'\Package.Variables[User::HashiSecretName].Properties[Value]'
           ,'String'
           ,'Development'
           ,'TPI'
           ,'TPIGLUpload_Workday.dtsx')

-- CarID from Parameterexample.txt
INSERT INTO SystemsMaster.dbo.SSISConfigurations
           (ConfigurationFilter
           ,ConfiguredValue
           ,PackagePath
           ,ConfiguredValueType
           ,Environment
           ,ApplicationName
           ,PackageName)
     VALUES
           ('CarID'
           ,'2509'
           ,'\Package.Variables[User::CarID].Properties[Value]'
           ,'String'
           ,'Development'
           ,'TPI'
           ,'TPIGLUpload_Workday.dtsx')

-- HashiCorpRoleID from Parameterexample.txt
INSERT INTO SystemsMaster.dbo.SSISConfigurations
           (ConfigurationFilter
           ,ConfiguredValue
           ,PackagePath
           ,ConfiguredValueType
           ,Environment
           ,ApplicationName
           ,PackageName)
     VALUES
           ('HashiCorpRoleID'
           ,'9ce637ff-78b2-6159-cb95-595e2ec401c5'
           ,'\Package.Variables[User::HashiCorpRoleID].Properties[Value]'
           ,'String'
           ,'Development'
           ,'TPI'
           ,'TPIGLUpload_Workday.dtsx')

-- HashiCorpEnvVarable from Parameterexample.txt
INSERT INTO SystemsMaster.dbo.SSISConfigurations
           (ConfigurationFilter
           ,ConfiguredValue
           ,PackagePath
           ,ConfiguredValueType
           ,Environment
           ,ApplicationName
           ,PackageName)
     VALUES
           ('HashiCorpEnvVarable'
           ,'APP_2509_ENV'
           ,'\Package.Variables[User::HashiCorpEnvVarable].Properties[Value]'
           ,'String'
           ,'Development'
           ,'TPI'
           ,'TPIGLUpload_Workday.dtsx')

-- HashiCorpKeyName retains the default key used in SSIS helper
INSERT INTO SystemsMaster.dbo.SSISConfigurations
           (ConfigurationFilter
           ,ConfiguredValue
           ,PackagePath
           ,ConfiguredValueType
           ,Environment
           ,ApplicationName
           ,PackageName)
     VALUES
           ('HashiCorpKeyName'
           ,'secret'
           ,'\Package.Variables[User::HashiCorpKeyName].Properties[Value]'
           ,'String'
           ,'Development'
           ,'TPI'
           ,'TPIGLUpload_Workday.dtsx')

-- HashiCorpVersion value from Parameterexample.txt
INSERT INTO SystemsMaster.dbo.SSISConfigurations
           (ConfigurationFilter
           ,ConfiguredValue
           ,PackagePath
           ,ConfiguredValueType
           ,Environment
           ,ApplicationName
           ,PackageName)
     VALUES
           ('HashiCorpVersion'
           ,'2'
           ,'\Package.Variables[User::HashiCorpVersion].Properties[Value]'
           ,'String'
           ,'Development'
           ,'TPI'
           ,'TPIGLUpload_Workday.dtsx')



