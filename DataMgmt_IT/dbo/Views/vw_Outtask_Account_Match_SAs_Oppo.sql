


create view  dbo.[vw_Outtask_Account_Match_SAs_Oppo]
as (
SELECT
-- vw.*
distinct 
sa.company_id
, sa.CONTRACT_EXTERNAL_REFERENCE_ID Outtask_service_id
, h.business_id_acc SAMatch_business_id_acc, h.secondary_business_id_acc SAMatch_secondary_business_id_acc, h.service_id_acc SAMatch_MN_Service_acct_id
, acc.nm_login SAMatch_MN_Bus_Login 
, acc1.nm_login SAMatch_MN_Sec_Bus_Login
, a.name SAMatch_SFDC_Name
--, vmca.business_login Customer_Active
, a.type SAMatch_type, a.billing_country__c SAMatch_billing_country__c,Opportunities_Won__c SAMatch_Opportunities_Won__c, a.SAP_Account_ID__c SAMatch_SAP_Account_ID__c, SAP_Planning_Entity_Account_ID__c SAMatch_SAP_Planning_Entity_Account_ID__c,Global_Ultimate_Duns_Number__c SAMatch_Global_Ultimate_Duns_Number__c, a.Site SAMatch_Site, a.Website SAMatch_website, a.Travel_Org_Type__c SAMatch_Travel_Org_Type__c

FROM 
[dbo].[Outtask_Company_List_SA] sa 
left join [DataMgmt_Metranet].dbo.t_account_mapper map
on map.nm_login = sa.CONTRACT_EXTERNAL_REFERENCE_ID
left join [DataMgmt_Metranet].dbo.rpt_v_accountflattenedhierarchy h
on map.id_acc = h.service_id_acc 
left join [DataMgmt_Metranet].dbo.rpt_v_account acc
on ( h.business_id_acc = acc.id_acc )
left join [DataMgmt_Metranet].dbo.rpt_v_account acc1
on ( h.secondary_business_id_acc = acc1.id_acc )
left join [DataMgmt_SFDC].dbo.account a
on acc.nm_login = a.id or acc1.nm_login = a.id 
where id is not null
--order by sa. company_id,acc.nm_login, Global_Ultimate_Duns_Number__c, Opportunities_Won__c, business_id_acc
)
