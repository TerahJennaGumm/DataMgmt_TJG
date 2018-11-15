/****** Script for SelectTopNRows command from SSMS  ******/
CREATE VIEW dbo.View_SFDCCountries_Actual_SAPMapping
AS
(SELECT
		[SFDC Country]
	   ,[2 Char ISO Code]
	   ,a.[Billing_Country__c]
	FROM [DataMgmt_IT].[dbo].[countryCodeMapping]
	FULL OUTER JOIN [dbo].[Salesforce_Distinct_Countries_Actual] a
		ON [SFDC Country] = [Billing_Country__c])