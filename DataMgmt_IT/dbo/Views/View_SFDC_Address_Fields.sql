

CREATE VIEW dbo.[View_SFDC_Address_Fields] AS (
SELECT  a.Billing_City__c, a.Billing_Country__c, a.Billing_St__c, a.Billing_St_Line_2__c, a.Billing_State_Province__c, a.Billing_Zip_Postal__c, a.Service_Address_City__c, a.Service_Address_Country__c, a.Service_Address_State__c, a.Service_Address_Street_1__c, a.Service_Address_Street_2__c, a.Service_Address_Zip__c, a.Notice_Address_City__c, a.Notice_Address_Country__c, a.Notice_Address_State__c, a.Notice_Address_Street_1__c, a.Notice_Address_Street_2__c, a.Notice_Address_Zip__c
 FROM DataMgmt_SFDC.dbo.Account a )

