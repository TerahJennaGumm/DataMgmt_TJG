

CREATE VIEW [dbo].[vw_Active_INDIRECT_Customers_SFDCAccount]
AS
(SELECT
		a.id
	   ,a.type
	   ,a.site
	   ,a.SAP_Planning_Entity__c
	   ,Account_Owner_ID__c
	   ,Account_Status__c
	   --,AccountStatus__c  --gives distorted result when pasted to excel 
	   ,Acct_Owner_Business_Unit__c
	   ,Billing_Contact__c
	   ,Billing_Email__c
	   ,Billing_Contact_Email__c
	   ,Contract_Termination_Date__c
	   ,Outtask_ID__c
	   ,Data_Center__c
	   ,HMC_Entity__c
	   ,Opportunities__c
	   ,Opportunities_Won__c
	   ,a.OwnerId
	   ,a.RecordTypeId
	   ,SAP_Account_ID__c
	   ,SAP_Business_Partner_Id__c
	   ,SAP_Planning_Entity_Account_ID__c
	   ,SAP_Planning_Entity_Name__c
	   --,TMC_Comments__c -created distortion in result
	   ,TMC_Travel_Agency__c
	   ,Travel_Org_Type__c
	   ,Billing_City__c
	   ,a.Service_Model__c
	   , a.Fulfillment_Partner_Account__c
	   , a.Named_Partner__c
	   --, a.Partner_Category__c
	   --, a.bd_partner_account__c
	FROM DataMgmt_SFDC.dbo.Account a
	LEFT JOIN DataMgmt_SFDC.dbo.Client_Disconnect__c cdc
		ON a.id = cdc.Account__c
	LEFT JOIN DataMgmt_SFDC.dbo.RecordType rt
		ON cdc.RecordTypeId = rt.Id
		WHERE (a.type = 'Indirect Customer'
	OR Travel_Org_Type__c IN ( 'Indirect')
	-- OR Fulfillment_Partner_Account__c = 'true' --for TMCS 
	) 
	AND rt.DeveloperName NOT IN ( 'System_Shutdown' , 'Indirect_Travel_Disconnect')
	)

	----To get a list of only TMCs try this????
	 
--	[Travel_Org_Type__c] = 'TMC Reseller'
--  AND type != 'Former Customer'
 -- OR Fulfillment_Partner_Account__c = 'true' 




