


CREATE view dbo.[vw_Outtask_Account_MatchAll_And_SAs_SFDCjoin]
 as (
select 
--CASE  when s.company_id is null then company_id_SAMatch else  s.company_id end as companyid 

[company_id_SAMatch] [SAMatch_company_id]
      ,[Outtask_service_id]
      ,[SAMatch_business_id_acc]
      ,[SAMatch_secondary_business_id_acc]
      ,[SAMatch_MN_Service_acct_id]
      ,[SAMatch_MN_Bus_Login]
      ,[SAMatch_MN_Sec_Bus_Login]

      ,[SAMatch_SFDC_Name] SAMatch_SFDCName
	  ,[SAMatch_Opportunities_Won__c] SAMatch_SFDC_WONOpportunities
	  , DIFFERENCE(s.SAMatch_SFDC_Name , l.company_name) SAMatch_NameMatchValue   	 
	  , a.Entity_ID__c SAMatch_FreeTrialEntityID
	  , a.HMC_Entity__c SAMatch_HMCEntityID
	  , a.Outtask_ID__c SAMatch_OuttaskId
      ,[SAMatch_type] SAMatch_SFDC_AcctType
      ,[SAMatch_billing_country__c] SAMatch_SFDC_BillingCountry      
      ,[SAMatch_SAP_Account_ID__c] SAMatch_SAPAccountID
      ,[SAMatch_SAP_Planning_Entity_Account_ID__c] SAMatch_PlanningEntityAccountID
      ,[SAMatch_Global_Ultimate_Duns_Number__c] SAMatch_GlobalUltimateDunsNumber
      ,[SAMatch_Site] SAMatch_SFDCsite
      ,[SAMatch_website] SAMatch_SFDCWebsite
      ,[SAMatch_Travel_Org_Type__c] SAMatch_SFDCTravel_org
	  
	 
	  ,case  when s.[company_id] is null then l.company_id else s.[company_id] end as company_id
      ,case when s.[company_name] is null then l.company_name else s.[company_name] end as company_name
      ,s.[address]
      ,case when s.[city] is null then l.[city] else s.[city] end as [city]
      ,case when s.[state] is null then  l.[state] else  s.[state] end as  [state]
      ,s.[zip_code]
      ,s.[salesforce_account_id]
      ,case when s.[entity_id] is null then l.[entity_id] else s.[entity_id] end as [entity_id]
      ,case when s.[salesforce_account_18digitid] is null then l.[salesforce_account_18digitid] else s.[salesforce_account_18digitid] end as [salesforce_account_18digitid]

	  ,s.[id] MatchAll_SFDCId
      ,s.[Name] MatchAll_SFDCName
	  ,s.[Opportunities_Won__c] MatchAll_SFDC_WONOpportunities	
	  ,s.[NameMatchValue] MatchAll_NameMatchValue
      ,s.[Entity_ID__c] MatchAll_FreeTrialEntityID
      ,s.[HMC_Entity__c] MatchAll_HMCEntityID
      ,s.[Outtask_ID__c] MatchAll_OuttaskID      
      ,s.[Type] MatchAll_SFDC_AcctType
      ,s.[business_login] MatchAll_ActiveMN_Exists
      ,s.[Billing_Country__c] MatchAll_SFDC_BillingCountry
      ,s.[Billing_City__c] MatchAll_SFDC_BillingCity
      ,s.[DunsNumber] MatchAll_SFDC_DUNS
      ,s.[Opportunities__c] MatchAll_SFDC_TotalOpportunities       
      ,a1.Site MatchAll_SFDCsite
      ,a1.Website MatchAll_SFDCWebsite
      ,a1.Travel_Org_Type__c MatchAll_SFDCTravel_org
      
	  ,s.[MatchSecBus_MN_CBSFAID] MatchSecBus_CB_SFAID
	  ,s.c_CBMasterAcct MatchSecBus_CBMasterAcct
	  ,a2.name MatchSecBus_SFDCName
	  ,DIFFERENCE(a2.name , l.company_name)   MatchSecBus_NameMatchValue
	  ,a2.Opportunities_Won__c MatchSecBus_WONOpportunities
	  ,s.c_CBCompanyID MatchSecBus_CBCompanyID	  
	  ,s.c_CBAgencyID MatchSecBus_CBAgencyID
	  ,s.c_CBTravelConfigID MatchSecBus_CBTravelConfigID
	  ,a2.[Entity_ID__c] MatchSecBus_FreeTrialEntityID
      ,a2.[HMC_Entity__c] MatchSecBus_HMCEntityID
      ,a2.[Outtask_ID__c] MatchSecBus_OuttaskID
      
      ,a2.[Type] MatchSecBus_SFDC_AcctType
      --,a2.[business_login] MatchSecBus_ActiveMN_Exists
      ,a2.[Billing_Country__c] MatchSecBus_SFDC_BillingCountry
      ,a2.[Billing_City__c] MatchSecBus_SFDC_BillingCity
      ,a2.[DunsNumber] MatchSecBus_SFDC_DUNS
      ,a2.[Opportunities__c] MatchSecBus_SFDC_TotalOpportunities
	  ,a2.Site MatchSecBus_SFDCsite
      ,a2.Website MatchSecBus_SFDCWebsite
      ,a2.Travel_Org_Type__c MatchSecBus_SFDCTravel_org

from [vw_Outtask_Account_MatchAll_And_SAs_join] s
left join DataMgmt_SFDC.dbo.Account a
on a.id = SAMatch_MN_Bus_Login
left join DataMgmt_SFDC.dbo.Account a1
on a1.id =  s.id
left join [dbo].[Outtask_Company_List_SA] l
on l.company_id = company_id_SAMatch
left join DataMgmt_SFDC.dbo.Account a2
on a2.id = s.[MatchSecBus_MN_CBSFAID] 
)

