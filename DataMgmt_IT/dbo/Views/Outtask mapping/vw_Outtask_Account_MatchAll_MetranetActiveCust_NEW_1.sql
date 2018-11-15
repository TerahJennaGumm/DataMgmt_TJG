


CREATE view dbo.[vw_Outtask_Account_MatchAll_MetranetActiveCust_NEW] as 
with cte (cteloginid)
as
(
select business_login from dbo.vw_MN_CustAccount
union
select secondary_biz_login from dbo.vw_MN_CustAccount where secondary_biz_login LIKE '001%'
)

select   ocl.company_id,  ocl.company_name, ocl.SFDC_18_digitID, ocl.city,id, ocl.entity_id Outtask_Entity_id
, Name , Entity_ID__c, HMC_Entity__c, Outtask_ID__c,
 DIFFERENCE(company_name, Name) as NameMatchValue, Type
 , cte.cteloginid as business_login
 , Billing_Country__c, Billing_City__c, DunsNumber, Global_Ultimate_Duns_Number__c, SAP_Planning_Entity_Account_ID__c, SAP_Account_ID__c, Opportunities__c
 , Opportunities_Won__c,SAP_Business_Partner_Id__c  , Site, Travel_Org_Type__c
 from company_list_2018_03_09 ocl
join [$(DataMgmt_SFDC)].dbo.account on cast(company_id as nvarchar) = cast(Outtask_ID__c as nvarchar)
left join cte on cte.cteloginid = id
where Name not in ('test' , 'Test') 
and Name not like 'Concur%' 

union
--MATCH on 18 digit SFDC id 
select   ocl.company_id,  ocl.company_name, ocl.SFDC_18_digitID, ocl.city,id, ocl.entity_id Outtask_Entity_id
, Name , Entity_ID__c, HMC_Entity__c, Outtask_ID__c,
 DIFFERENCE(company_name, Name) as NameMatchValue, Type
 , cte.cteloginid as business_login
 , Billing_Country__c, Billing_City__c, DunsNumber, Global_Ultimate_Duns_Number__c, SAP_Planning_Entity_Account_ID__c, SAP_Account_ID__c, Opportunities__c
 , Opportunities_Won__c,SAP_Business_Partner_Id__c  , Site, Travel_Org_Type__c
 from company_list_2018_03_09 ocl
 join [$(DataMgmt_SFDC)].dbo.account on ([SFDC_18_digitID] = id)
 left join cte on cte.cteloginid = id
where Name not in ('test' , 'Test')
and Name not like 'Concur%' 

union
--MATCH on entity id to hmc id  
select   ocl.company_id,  ocl.company_name, ocl.SFDC_18_digitID, ocl.city,id, ocl.entity_id Outtask_Entity_id
, Name , Entity_ID__c, HMC_Entity__c, Outtask_ID__c,
 DIFFERENCE(company_name, Name) as NameMatchValue, Type
 , cte.cteloginid as business_login
 , Billing_Country__c, Billing_City__c, DunsNumber, Global_Ultimate_Duns_Number__c, SAP_Planning_Entity_Account_ID__c, SAP_Account_ID__c, Opportunities__c
 , Opportunities_Won__c,SAP_Business_Partner_Id__c  , Site, Travel_Org_Type__c
 from company_list_2018_03_09 ocl
join [$(DataMgmt_SFDC)].dbo.account on  ((entity_id = HMC_Entity__c) )
left join cte on cte.cteloginid = id
where Name not in ('test' , 'Test')
and Name not like 'Concur%'  

union
---MATCH on entity id to  freetrial entity id 
select   ocl.company_id,  ocl.company_name, ocl.SFDC_18_digitID, ocl.city,id, ocl.entity_id Outtask_Entity_id
, Name , Entity_ID__c, HMC_Entity__c, Outtask_ID__c,
 DIFFERENCE(company_name, Name) as NameMatchValue, Type
 , cte.cteloginid as business_login
 , Billing_Country__c, Billing_City__c, DunsNumber, Global_Ultimate_Duns_Number__c, SAP_Planning_Entity_Account_ID__c, SAP_Account_ID__c, Opportunities__c
 , Opportunities_Won__c,SAP_Business_Partner_Id__c  , Site, Travel_Org_Type__c
 from company_list_2018_03_09 ocl
join [$(DataMgmt_SFDC)].dbo.account on  ((entity_id = Entity_ID__c) )
left join cte on cte.cteloginid = id
where Name not in ('test' , 'Test')
and Name not like 'Concur%'  


union
--MATCH on name 
select   ocl.company_id,  ocl.company_name, ocl.SFDC_18_digitID, ocl.city,id, ocl.entity_id Outtask_Entity_id
, Name , Entity_ID__c, HMC_Entity__c, Outtask_ID__c,
 DIFFERENCE(company_name, Name) as NameMatchValue, Type
 , cte.cteloginid as business_login
 , Billing_Country__c, Billing_City__c, DunsNumber, Global_Ultimate_Duns_Number__c, SAP_Planning_Entity_Account_ID__c, SAP_Account_ID__c, Opportunities__c
 , Opportunities_Won__c,SAP_Business_Partner_Id__c  , Site, Travel_Org_Type__c
 from company_list_2018_03_09 ocl
join [$(DataMgmt_SFDC)].dbo.account on  (company_name = Name )
left join cte on cte.cteloginid = id
where Name not in ('test' , 'Test')
and Name not like 'Concur%'  




