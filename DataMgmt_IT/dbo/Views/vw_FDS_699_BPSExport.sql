
--IF OBJECT_ID('[dba_tmp].[CSYS_69338_BPSExport]') IS NULL -- Check if View Exists
--    EXEC('CREATE VIEW [dba_tmp].[CSYS_69338_BPSExport] AS SELECT 1 AS columnName;');

--SELECT COUNT(*) FROM [dba_tmp].RowNumber_CSYS_89178_BPSExport --4906341

create VIEW [dbo].[vw_FDS_699_BPSExport] AS 
(
SELECT
	CAST('02' AS NVARCHAR(255)) AS 'OrganizationType'
   ,CAST(Id AS NVARCHAR(255)) AS 'Organization'
   ,ISNULL(CAST(CONVERT(VARCHAR(8), CreatedDate, 112) AS NVARCHAR(255)),
	'') AS 'Regidate'
   ,CAST('02' AS NVARCHAR(255)) AS 'RiskLevel'
   ,CAST('Billing' AS NVARCHAR(255)) AS 'AddressId'
   ,ISNULL(CAST(CONVERT(VARCHAR(8), Customer_Since__c, 112) AS NVARCHAR(255)),
	'') AS 'ValidFrom'
   ,ISNULL(CAST(Name AS NVARCHAR(255)), '') AS 'CompanyName'
	,ISNULL(CAST(AKA_Company_Name__c AS NVARCHAR(255)), '') AS 'AKACompanyName'
   --,'' AS 'AKACompanyName'
   ,ISNULL(CAST([2 Char ISO Code] AS NVARCHAR(255)), 'ZZ') AS 'Country'
   ,ISNULL(CAST(Billing_Zip_Postal__c AS NVARCHAR(255)), '') AS 'PostCode'
   ,ISNULL(CAST(Billing_City__c AS NVARCHAR(255)), '') AS 'City'
   ,ISNULL(CAST(Billing_State_Province__c AS NVARCHAR(255)), '') AS 'State'
   ,ISNULL(CAST(Billing_St__c AS NVARCHAR(255)), '') AS 'Street'
   ,ISNULL(CAST(Billing_St_Line_2__c AS NVARCHAR(255)), '') AS 'Street2'
   ,ISNULL(CAST(Billing_Country__c AS NVARCHAR(255)), '') AS 'OrigCountry'
FROM DataMgmt_SFDC.dbo.Account  a
LEFT OUTER JOIN DataMgmt_IT.[dbo].[UpdatedcountryCodeMapping] c
	ON Billing_Country__c = [SFDC Country]
WHERE Type <> 'Test'
UNION
SELECT --TOP 10
	CAST('02' AS NVARCHAR(255)) AS 'OrganizationType'
   ,ISNULL(CAST(Id AS NVARCHAR(255)), '') AS 'Organization'
   ,ISNULL(CAST(CONVERT(VARCHAR(8), CreatedDate, 112) AS NVARCHAR(255)),
	'') AS 'Regidate'
   ,CAST('02' AS NVARCHAR(255)) AS 'RiskLevel'
   ,CAST('Notice' AS NVARCHAR(255)) AS 'AddressId'
   ,ISNULL(CAST(CONVERT(VARCHAR(8), Customer_Since__c, 112) AS NVARCHAR(255)),
	'') AS 'ValidFrom'
   ,ISNULL(CAST(Name AS NVARCHAR(255)), '') AS 'CompanyName'
	,ISNULL(CAST(AKA_Company_Name__c AS NVARCHAR(255)), '') AS 'AKACompanyName'
   --,'' AS 'AKACompanyName'
   ,ISNULL(CAST([2 Char ISO Code] AS NVARCHAR(255)), 'ZZ') AS 'Country'
   ,ISNULL(CAST(Notice_Address_Zip__c AS NVARCHAR(255)), '') AS 'PostCode'
   ,ISNULL(CAST(Notice_Address_City__c AS NVARCHAR(255)), '') AS 'City'
   ,ISNULL(CAST(Notice_Address_State__c AS NVARCHAR(255)), '') AS 'State'
   ,ISNULL(CAST(Notice_Address_Street_1__c AS NVARCHAR(255)), '') AS 'Street'
   ,ISNULL(CAST(Notice_Address_Street_2__c AS NVARCHAR(255)), '') AS 'Street2'
   ,ISNULL(CAST(Notice_Address_Country__c AS NVARCHAR(255)), '') AS 'OrigCountry'
FROM DataMgmt_SFDC.dbo.Account  a
LEFT OUTER JOIN DataMgmt_IT.[dbo].[UpdatedcountryCodeMapping] c
	ON Notice_Address_Country__c = [SFDC Country]
WHERE Type <> 'Test'
UNION
SELECT --TOP 10
	CAST('02' AS NVARCHAR(255)) AS 'OrganizationType'
   ,ISNULL(CAST(Id AS NVARCHAR(255)), '') AS 'Organization'
   ,ISNULL(CAST(CONVERT(VARCHAR(8), CreatedDate, 112) AS NVARCHAR(255)),
	'') AS 'Regidate'
   ,CAST('02' AS NVARCHAR(255)) AS 'RiskLevel'
   ,CAST('Service' AS NVARCHAR(255)) AS 'AddressId'
   ,ISNULL(CAST(CONVERT(VARCHAR(8), Customer_Since__c, 112) AS NVARCHAR(255)),
	'') AS 'ValidFrom'
   ,ISNULL(CAST(Name AS NVARCHAR(255)), '') AS 'CompanyName'
	,ISNULL(CAST(AKA_Company_Name__c AS NVARCHAR(255)), '') AS 'AKACompanyName'
   --,'' AS 'AKACompanyName'
   ,ISNULL(CAST([2 Char ISO Code] AS NVARCHAR(255)), 'ZZ') AS 'Country'
   ,ISNULL(CAST(Service_Address_Zip__c AS NVARCHAR(255)), '') AS 'PostCode'
   ,ISNULL(CAST(Service_Address_City__c AS NVARCHAR(255)), '') AS 'City'
   ,ISNULL(CAST(Service_Address_State__c AS NVARCHAR(255)), '') AS 'State'
   ,ISNULL(CAST(Service_Address_Street_1__c AS NVARCHAR(255)), '') AS 'Street'
   ,ISNULL(CAST(Service_Address_Street_2__c AS NVARCHAR(255)), '') AS 'Street2'
   ,ISNULL(CAST(Service_Address_Country__c AS NVARCHAR(255)), '') AS 'OrigCountry'
FROM DataMgmt_SFDC.dbo.Account  a
LEFT OUTER JOIN DataMgmt_IT.[dbo].[UpdatedcountryCodeMapping] c
	ON Service_Address_Country__c = [SFDC Country]
WHERE Type <> 'Test'
);


--SELECT 
--	ROW_NUMBER() OVER (ORDER BY Organization) AS 'RowNum'
--   ,* INTO DataMgmt_SFDC.dbo.RowNumber_FDS_699_BPSExport
--FROM  DataMgmt_SFDC.dbo.View_FDS_699_BPSExport

--SELECT
--	*
--FROM DataMgmt_SFDC.dbo.RowNumber_FDS_557_BPSExport
--WHERE RowNum > 0
--AND RowNum <= 100000
--ORDER BY RowNum




