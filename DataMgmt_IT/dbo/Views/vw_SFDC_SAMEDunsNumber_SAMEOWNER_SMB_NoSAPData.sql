



CREATE view dbo.[vw_SFDC_SAMEDunsNumber_SAMEOWNER_SMB_NoSAPData] as (
select 
--Id, OwnerId, DunsNumber
aa.DunsNumber 
, Global_Ultimate_Duns_Number__c
, Website--Website
, aa.id --Id
-- Dup/Existing account
, aa.CreatedDate--Created Date
, aa.CreatedById--CreatedBy.Name
, aa.Name AccountName--Account Name
, d.name [DandbCompany Primary Business Name]
, aa.OwnerId, uu.Name UserName, uu.Owner_Record_Business_Unit__c, Owner_Record_Market__c --Owner Full Name
, aa.Type--Account Type
, aa.Site--Account Site
, aa.Opportunities__c--# Opportunities
, aa.Opportunities_Open__c, aa.Opportunities_Won__c--# Opportunities Open
, aa.Acct_Owner_Business_Unit__c--Acct Owner Business Unit
, aa.Acct_Owner_Division__c--Acct Owner Division
, Billing_City__c--Billing St
, Billing_St__c--Billing City
, Billing_State_Province__c--Billing State/Province
from DataMgmt_SFDC.dbo.Account aa with (nolock)
left join  DataMgmt_SFDC.dbo.[User] uu on uu.Id = aa.OwnerId
left join DataMgmt_SFDC.dbo.dandbcompany d on d.dunsnumber = aa.dunsnumber
where aa.DunsNumber in 
(
select DunsNumber from DataMgmt_SFDC.dbo.Account with (nolock)
where 
SAP_Data_Verified_Date__c is null
and Acct_Owner_Business_Unit__c = 'SMB BU'
group by DunsNumber
having count(Id) > 1
and MIN (OwnerId) = MAX(OwnerId)
)
--order by Website, OwnerId
)



