

CREATE view [CONCUR\MinalC].[VW__Outtask_Companies_matching_more_than_on_valid_SFDC_Acct]
as (
select  distinct MatchAnalysis, MatchAnalysisComments,  MNCustomerStatus,company_id, SFDC_18_digitID, Id, Name, Outtask_Entity_id, HMC_Entity__c, business_login, SAP_Business_Partner_Id__c, Outtask_ID__c, company_name, city, Billing_City__c, Type, Site, Opportunities_Won__c, Travel_Org_Type__c, NameMatchValue, rrpu__Alert_Message__c, Entity_ID__c
from Table__Outtask_Account_MatchAll_SFDC_MN_MASTER_NEW m
join Metranet_BusinessCustomer_Status s on s.MNAccountName = m.Id
where company_id in
(
select distinct company_id
from Table__Outtask_Account_MatchAll_SFDC_MN_MASTER_NEW
where (MatchAnalysis ! = 'D'  and  MatchAnalysis !=  'cleanup' and   MatchAnalysis !=  '00')
--and business_login is not null
group by company_id
having count(MatchAnalysis)> 1
)
and (MatchAnalysis ! = 'D'  and  MatchAnalysis !=  'cleanup'and   MatchAnalysis !=  '00')
--and business_login is not null
--order by company_id 
) 
