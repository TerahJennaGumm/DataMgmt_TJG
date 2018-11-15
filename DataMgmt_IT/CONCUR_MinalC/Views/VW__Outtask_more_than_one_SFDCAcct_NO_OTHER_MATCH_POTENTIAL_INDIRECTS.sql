create view [CONCUR\MinalC].VW__Outtask_more_than_one_SFDCAcct_NO_OTHER_MATCH_POTENTIAL_INDIRECTS
as
(
select a.*  
from [CONCUR\MinalC].[VW__Outtask_Companies_matching_more_than_on_valid_SFDC_Acct] a
join [CONCUR\MinalC].[Table__Outtask_Account_MatchAll_SFDC_MN_MASTER_NEW] b on (a.company_id = b.company_id) and (a.Id= b.Id)
where a.company_id not in (
select distinct company_id from [CONCUR\MinalC].[VW__Outtask_Companies_matching_more_than_on_valid_SFDC_Acct]
where Outtask_Entity_id = left (HMC_Entity__c, 12)
OR (SFDC_18_digitID = Id)
or (Outtask_Entity_id = Entity_ID__c)
)
)
--order by a.company_id 