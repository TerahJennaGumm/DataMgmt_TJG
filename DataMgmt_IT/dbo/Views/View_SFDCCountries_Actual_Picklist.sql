/****** Script for SelectTopNRows command from SSMS  ******/
CREATE VIEW dbo.View_SFDCCountries_Actual_Picklist
AS
(SELECT
		[SFDCAllPicklistCountryValues]
	   ,a.[Billing_Country__c]
	FROM [DataMgmt_IT].[dbo].[AllSFDCCountryPicklistValues] p
	FULL OUTER JOIN [dbo].[Salesforce_Distinct_Countries_Actual] a
		ON p.[SFDCAllPicklistCountryValues] = a.[Billing_Country__c])