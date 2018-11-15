
/****** Script for SelectTopNRows command from SSMS  ******/
CREATE VIEW [dbo].[View_SFDCCountries_Actual_Picklist]
AS
(SELECT
		[SFDCAllPicklistCountryValues]
	   ,a.[Billing_Country__c]
	FROM [dbo].[AllSFDCCountryPicklistValues] p
	FULL OUTER JOIN [dbo].[vw_Salesforce_Distinct_Countries_Actual] a
		ON p.[SFDCAllPicklistCountryValues] = a.[Billing_Country__c])
