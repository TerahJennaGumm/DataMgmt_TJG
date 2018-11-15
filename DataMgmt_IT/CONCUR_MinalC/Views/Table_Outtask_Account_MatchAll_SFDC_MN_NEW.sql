

CREATE view [CONCUR\MinalC].[Table_Outtask_Account_MatchAll_SFDC_MN_NEW] as 
with cte (cteloginid)
as
(
select business_login from metranet_data.dbo.vw_MN_CustAccount
union
select secondary_biz_login from metranet_data.dbo.vw_MN_CustAccount where secondary_biz_login LIKE '001%'
)


select   distinct ocl.company_id,  ocl.company_name, ocl.SFDC_18_digitID, ocl.city,a.Id, ocl.entity_id Outtask_Entity_id
, Name , Entity_ID__c, HMC_Entity__c, Outtask_ID__c,
 DIFFERENCE(company_name, Name) as NameMatchValue, Type
 , cte.cteloginid as business_login
 , Billing_Country__c, Billing_City__c, DunsNumber, Global_Ultimate_Duns_Number__c, SAP_Planning_Entity_Account_ID__c, SAP_Account_ID__c, Opportunities__c
 , Opportunities_Won__c,SAP_Business_Partner_Id__c  , Site, Travel_Org_Type__c, rrpu__Alert_Message__c
 , n.*
 from company_list_2018_03_09 ocl
 join [CONCUR\MinalC].[Table_Outtask_Account_MatchAll_NEW] b on ocl.company_id = b.company_id
join salesforce_data.dbo.account a  on b.[id] =a.Id 
full outer join [CONCUR\MinalC].[Indirect_Deals] n on ocl.company_id = n.[company id]
left join cte on cte.cteloginid = a.id
where Name not in ('test' , 'Test') 
and Name not like 'Concur%' 
