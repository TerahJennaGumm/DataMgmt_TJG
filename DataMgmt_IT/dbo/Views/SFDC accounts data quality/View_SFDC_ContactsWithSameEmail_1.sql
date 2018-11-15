
create view dbo.[View_SFDC_ContactsWithSameEmail] as (
select 
--count(distinct b.Email)
distinct c.AccountId, c.Email, Contact_Status__c, HasOptedOutOfEmail, c.CreatedDate, c.Buying_Role__c, a.Website
, a.Name,  Acct_Owner_Business_Unit__c, Acct_Owner_Theater__c, Acct_Owner_Market__c ,Acct_Owner_Division__c,Type, Site, Opportunities_Open__c, Opportunities_Won__c, Billing_Contact_Email__c, Company_Created_Date__c
from [$(DataMgmt_SFDC)].dbo.Contact c
join 
(
select  Email
from [$(DataMgmt_SFDC)].dbo.contact cc
--where  Contact_Status__c != 'No Longer With Company'
group by Email
having count(cc.Id) > 1
) b
on c.Email = b.Email
join [$(DataMgmt_SFDC)].dbo.Account a 
on a.Id = c.AccountId
--order by c.Email
)

