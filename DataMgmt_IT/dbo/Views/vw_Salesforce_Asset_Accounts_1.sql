create view [dbo].[vw_Salesforce_Asset_Accounts] as 
SELECT a.Id as AssetId, a.AccountId as AssetAccountId, MN_Subscription_ID__c as AssetMNSubId, MN_PO_ID__c as AssetMNPOId, a.Service_Acct_ID__c as AssetServAcctId 
 , a.MN_Update_ID__c as AssetMNUpdateId, Opportunity__c as AssetOppId, a.Name as AssetName, a.Status as AssetStatus, a.LastModifiedById as LastAssetModifiedById 
 , a.Next_Bill_Date__c, a.Purchase_Quote__c, a.PurchaseDate as AssetPurchaseDate, a.Asset_Begin_Date__c, a.Billing_Cycle__c, b.[Type] as AccountType
 , Adjustment_to_ARR__c
 from DataMgmt_SFDC.dbo.asset a 
 inner join DataMgmt_SFDC.dbo.Account b on b.Id = a.AccountId 

