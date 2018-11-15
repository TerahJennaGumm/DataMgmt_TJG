
create view [CONCUR\MinalC].[SFDCId_SAMEGlobalDUNS_SameOWNER_SMB_NoSAPData] as (
select id, Global_Ultimate_Duns_Number__c, OwnerId 
from DataMgmt_SFDC.dbo.Account with (nolock)
where Global_Ultimate_Duns_Number__c in 
(
select Global_Ultimate_Duns_Number__c from DataMgmt_SFDC.dbo.Account with (nolock)
where 
SAP_Data_Verified_Date__c is null
and Acct_Owner_Business_Unit__c = 'SMB BU'
group by Global_Ultimate_Duns_Number__c
having count(Id) > 1
and MIN (OwnerId) = MAX(OwnerId)
)
--order by OwnerId, DunsNumber
)



