
CREATE VIEW dbo.[vw_Salesforce_Distinct_Countries_Actual] AS (

SELECT DISTINCT
	a.Billing_Country__c
FROM [$(DataMgmt_SFDC)].dbo.Account a
UNION
SELECT DISTINCT
	a.Notice_Address_Country__c
FROM [$(DataMgmt_SFDC)].dbo.Account a 
UNION
SELECT DISTINCT
	a.Service_Address_Country__c
FROM [$(DataMgmt_SFDC)].dbo.Account a
)