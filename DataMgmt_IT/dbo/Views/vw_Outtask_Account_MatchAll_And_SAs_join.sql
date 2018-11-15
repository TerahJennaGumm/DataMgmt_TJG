





CREATE view  dbo.[vw_Outtask_Account_MatchAll_And_SAs_join]
as (
select s.[company_id] [company_id_SAMatch]
      ,[Outtask_service_id]
      ,[SAMatch_business_id_acc]
      ,case when [SAMatch_secondary_business_id_acc] is null then [SAMatch_business_id_acc] else [SAMatch_business_id_acc] end as [SAMatch_secondary_business_id_acc]
      ,[SAMatch_MN_Service_acct_id]
      ,[SAMatch_MN_Bus_Login]
      ,[SAMatch_MN_Sec_Bus_Login]
      ,[SAMatch_SFDC_Name]
      ,[SAMatch_type]
      ,[SAMatch_billing_country__c]
      ,[SAMatch_Opportunities_Won__c]
      ,[SAMatch_SAP_Account_ID__c]
      ,[SAMatch_SAP_Planning_Entity_Account_ID__c]
      ,[SAMatch_Global_Ultimate_Duns_Number__c]
      ,[SAMatch_Site]
      ,[SAMatch_website]
      ,[SAMatch_Travel_Org_Type__c]
	  , m.c_CBSFAID MatchSecBus_MN_CBSFAID
	  , m.c_CBCompanyID
	  , m.c_CBMasterAcct
	  , m.c_CBAgencyID
	  , m.c_CBTravelConfigID
	  --, m. c_CBTravelConfigName
	  , a.*
	  from [vw_Outtask_Account_Match_SAs_Oppo] s
full outer join [dbo].[vw_Outtask_Account_MatchAll_MetranetActiveCust_Oppo] a
on s.company_id = a.company_id
left join DataMgmt_Metranet.dbo.rpt_v_account m
on  [SAMatch_MN_Service_acct_id] = m.id_acc  
)

