
CREATE view dbo.[vw_Outtask_Account_MatchAll_MetranetActiveCust_Oppo] as 
with cte (cteloginid)
as
(
select business_login from dbo.vw_MN_CustAccount
union
select secondary_biz_login from dbo.vw_MN_CustAccount where secondary_biz_login LIKE '0016%'
)

select  id, Name, ocl.*, Entity_ID__c, HMC_Entity__c, Outtask_ID__c, DIFFERENCE(company_name, Name) as NameMatchValue, Type, cte.cteloginid as business_login, Billing_Country__c, Billing_City__c, DunsNumber, Opportunities__c, Opportunities_Won__c
from [dbo].[Outtask_Company_List_SA] ocl
join dbo.vw_Salesforce_Account_selectFields on company_id = Outtask_ID__c
left join cte on cte.cteloginid = id
where Name not in ('test' , 'Test') 
and Name not like 'Concur%' 

union
--MATCH on 18 digit SFDC id and matchvalue > 1
select  id, Name, ocl.*, Entity_ID__c, HMC_Entity__c, Outtask_ID__c, DIFFERENCE(company_name, Name) as NameMatchValue, Type, cte.cteloginid as business_login, Billing_Country__c, Billing_City__c, DunsNumber, Opportunities__c, Opportunities_Won__c
from [dbo].[Outtask_Company_List_SA] ocl
 join dbo.vw_Salesforce_Account_selectFields on salesforce_account_18digitid = id
 left join cte on cte.cteloginid = id
where Name not in ('test' , 'Test')
and Name not like 'Concur%' 

union
--MATCH on entity id to hmc id  and matchvalue > 1
select  id, Name, ocl.*, Entity_ID__c, HMC_Entity__c, Outtask_ID__c, DIFFERENCE(company_name, Name) as NameMatchValue, Type, cte.cteloginid as business_login, Billing_Country__c, Billing_City__c, DunsNumber, Opportunities__c, Opportunities_Won__c
from [dbo].[Outtask_Company_List_SA] ocl
join dbo.vw_Salesforce_Account_selectFields on  ((entity_id = HMC_Entity__c) )
left join cte on cte.cteloginid = id
where Name not in ('test' , 'Test')
and Name not like 'Concur%'  

union
--MATCH on entity id to  freetrial entity id and matchvalue > 1
select  id, Name, ocl.*, Entity_ID__c, HMC_Entity__c, Outtask_ID__c, DIFFERENCE(company_name, Name) as NameMatchValue, Type, cte.cteloginid as business_login, Billing_Country__c, Billing_City__c, DunsNumber, Opportunities__c, Opportunities_Won__c
from [dbo].[Outtask_Company_List_SA] ocl
join dbo.vw_Salesforce_Account_selectFields on  ((entity_id = Entity_ID__c) )
left join cte on cte.cteloginid = id
where Name not in ('test' , 'Test')
and Name not like 'Concur%' 

union
--MATCH on name and matchvalue > 1
select  id, Name, ocl.*, Entity_ID__c, HMC_Entity__c, Outtask_ID__c, DIFFERENCE(company_name, Name) as NameMatchValue, Type, cte.cteloginid as business_login, Billing_Country__c, Billing_City__c, DunsNumber, Opportunities__c, Opportunities_Won__c
from [dbo].[Outtask_Company_List_SA] ocl
join dbo.vw_Salesforce_Account_selectFields on  (company_name = Name )
left join cte on cte.cteloginid = id
where Name not in ('test' , 'Test')
and Name not like 'Concur%' 



