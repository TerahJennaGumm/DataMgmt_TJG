

CREATE VIEW [dbo].[Active_INDIRECT_Customers_Opportunity]
AS
(
SELECT DISTINCT
		o.Fulfillment_Partner_Actual_Name__c
	   ,o.Fullfillment__c
	   ,o.Fulfillment_Partner__c
	    ,o.Indirect_Travel_Deal__c
	   ,a.type
	   ,a.Travel_Org_Type__c
	   ,a.Name
	   ,a.Named_Partner__c
	   ,a.Id AccountId
	   ,o.StageName
	   ,o.Travel_Config_Id__c
	   ,o.Travel_Config_Name__c
	   ,o.Travel_Only_Contract__c
	   , o.Approved_Indirect_Travel_Deal__c
	   --, cdc.CD_Completed_Date__c, cdc.Disconnect_Reason__c, cdc.Disconnect_Date__c, cdc.Disconnect_Status__c, cdc.Disconnecting_all_Sites__c	   , rt.Name DisconnectType
	FROM DataMgmt_SFDC.dbo.Opportunity o 
	LEFT JOIN DataMgmt_SFDC.dbo.account a 	ON o.AccountId = a.Id
	LEFT JOIN DataMgmt_SFDC.dbo.Client_Disconnect__c cdc ON a.id = cdc.Account__c
	LEFT JOIN DataMgmt_SFDC.dbo.RecordType rt ON  ((cdc.RecordTypeId = rt.Id) AND rt.DeveloperName NOT IN ( 'System_Shutdown' , 'Indirect_Travel_Disconnect'))
	WHERE Fulfillment_Partner__c IS NOT NULL
	AND StageName = 'Closed Won'
	AND o.Indirect_Travel_Deal__c = 'true'
	
	)







