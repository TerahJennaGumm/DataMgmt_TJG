


 CREATE VIEW [dbo].[Active_Direct_Indirect_Customers_Metranet_SFDC_Status] AS 
  (
SELECT a.id, a.type, a.site, a.SAP_Planning_Entity__c, Account_Owner_ID__c, Account_Status__c, AccountStatus__c, Acct_Owner_Business_Unit__c, Billing_Contact__c, Billing_Email__c, Billing_Contact_Email__c, Contract_Termination_Date__c,  Outtask_ID__c,Data_Center__c, HMC_Entity__c, Opportunities__c, Opportunities_Won__c, a.OwnerId, a.RecordTypeId, SAP_Account_ID__c, SAP_Business_Partner_Id__c, SAP_Planning_Entity_Account_ID__c, SAP_Planning_Entity_Name__c, TMC_Comments__c, TMC_Travel_Agency__c, Travel_Org_Type__c, Billing_City__c, a.Service_Model__c, a.Name
, cdc.Account__c, cdc.Account_Type__c, cdc.Service_Type__c, cdc.Service_Type_Disconnect_Date__c, cdc.Approval_Status__c, cdc.CD_Final_Approval_Date__c
--cdc.name, cdc.Approval_Status__c, cdc.Comments__c, cdc.CD_Submitted_Date__c, cdc.CD_Final_Approval_Date__c, cdc.CD_Completed_Date__c, cdc.LastActivityDate 
,ss.[MNCustomerStatus], ss.[MNAccountId],[MNAccountName]

FROM [DataMgmt_Metranet].[dbo].[vw_Metranet_BusinessCustomer_Status] ss 
LEFT JOIN DataMgmt_SFDC.dbo.Account a ON (ss.MNAccountName = a.Id )
LEFT JOIN DataMgmt_SFDC.dbo.Client_Disconnect__c cdc ON a.id = cdc.Account__c
LEFT JOIN DataMgmt_SFDC.dbo.RecordType rt ON cdc.RecordTypeId = rt.Id 
)
   






