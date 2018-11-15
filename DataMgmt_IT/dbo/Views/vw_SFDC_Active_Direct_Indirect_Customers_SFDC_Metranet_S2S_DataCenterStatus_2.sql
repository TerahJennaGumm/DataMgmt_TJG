CREATE VIEW dbo.[vw_SFDC_Active_Direct_Indirect_Customers_SFDC_Metranet_S2S_DataCenterStatus] AS (
SELECT DISTINCT s.id, stsc.[Data_Center__c] S2SDataCenter, s.Data_Center__c ActiveCustomerDataCenter, s.type ,
CASE  
WHEN (LEFT([HMC_Entity__c],3) = 'P00') THEN 'US' 
WHEN (LEFT([HMC_Entity__c],3) = 'P05') THEN 'GOV' 
WHEN (LEFT([HMC_Entity__c],3) = 'P06') THEN 'EMEA' 
WHEN (LEFT([HMC_Entity__c],3) = 'P08') THEN 'China' 
END AS SetDataCenter_HMCBasis
FROM 
DataMgmt_SFDC.dbo.Sales_To_Service__c stsc JOIN [DataMgmt_SFDC].dbo.Opportunity o ON stsc.[Opportunity__c] = o.id
RIGHT JOIN [dbo].[Active_Direct_Indirect_Customers_SFDC_Metranet_Status] s  ON s.id = o.[Account_ID__c] )