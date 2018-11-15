
CREATE VIEW [dbo].[vw_SFDCAccount_Oppo_MDG_CRM_fields]
AS (
SELECT DISTINCT  
  a.id
, a.Name, a.MDG_C_ID__c
, a.SAP_Account_ID__c
, a.SAP_Account_Name__c
, a.SAP_Account_Type__c, a.SAP_Customer_ID__c, a.SAP_Expense_Customer__c
, a.SAP_Planning_Entity__c, a.SAP_Planning_PE_Locked__c, a.SAP_Business_Partner_Id__c
, RIGHT('00000000' + a.SAP_Account_ID__c, 10) AS SAP_Account_ID_10
FROM [$(DataMgmt_SFDC)].dbo.Account a 
JOIN [$(DataMgmt_SFDC)].dbo.Opportunity o ON o.Account_ID__c = a.Id AND 1=1
WHERE o.StageName IN 
(
'Sales Working'
,'Discovery'
,'Demo / Proposal'
,'VOC'
,'Closing'
)

)