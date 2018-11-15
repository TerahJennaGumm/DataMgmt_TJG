
create view dbo.[View_SFDC_AccountsWithSameWebsite_perOwner]
as (
select a.Website, a.OwnerId, a.Id, Type,  Account_Owner_ID__c
, a.Name,  Acct_Owner_Business_Unit__c, Acct_Owner_Theater__c, Acct_Owner_Market__c ,Acct_Owner_Division__c, Site, Opportunities_Open__c, Opportunities_Won__c,  Company_Created_Date__c
from  DataMgmt_SFDC.dbo.Account a
join
(select Website, OwnerId from DataMgmt_SFDC.dbo.Account b with (nolock)
--where 
--SAP_Data_Verified_Date__c is null
--and Acct_Owner_Business_Unit__c = 'SMB BU'
group by Website, OwnerId
having count(Id) > 1
) b
on (a.OwnerId = b.OwnerId  and a.Website = b.Website)
--order by Website, OwnerId
)

