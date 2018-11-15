/****** Script for SelectTopNRows command from SSMS  ******/
CREATE VIEW dbo.View_SFDCCountries_Picklist_SAPMapping AS (
SELECT  [SFDC Country]
      ,[2 Char ISO Code], a.[SFDCAllPicklistCountryValues]
  FROM [DataMgmt_IT].[dbo].[countryCodeMapping]
  FULL OUTER JOIN [dbo].[AllSFDCCountryPicklistValues]  a ON [SFDC Country] = [SFDCAllPicklistCountryValues])