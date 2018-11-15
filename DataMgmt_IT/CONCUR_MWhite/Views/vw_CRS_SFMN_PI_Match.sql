create view [CONCUR\MWhite].[vw_CRS_SFMN_PI_Match]
as

select id
, bigmachines__part_number__c
, name
, marketing_name__c
, PI_Item_Type__c
, IsActive
, id_pi
, case
	when m.id_pi IS NULL then 'No MN PI Match'
	else 'MN PI Match'
	end as MatchStatus
, CreatedDate
, LastModifiedDate
from [DataMgmt_SFDC].[dbo].[Product2] p
left join [DataMgmt_SFDC].[dbo].[vw_CRS_MN_Products] m --1097 from inner join, 2464 outer join
on p.[BigMachines__Part_Number__c] = m.id_pi
