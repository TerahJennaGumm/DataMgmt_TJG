CREATE TABLE [CONCUR\MinalC].[Table_CSYS92050_HMC_Outtask_Id] (
    [new_Outtask_ID__c]       NVARCHAR (8)   NULL,
    [Outtask_ID__c]           NVARCHAR (8)   NULL,
    [id]                      NCHAR (18)     NULL,
    [Name]                    NVARCHAR (255) NULL,
    [new_HMC_Entity__c]       NVARCHAR (255) NULL,
    [HMC_Entity__c]           NVARCHAR (80)  NULL,
    [MatchAll_SFDC_AcctType]  NVARCHAR (40)  NULL,
    [MatchAll_SFDCTravel_org] NVARCHAR (255) NULL
);


GO
EXECUTE sp_addextendedproperty @name = N'Query', @value = N'select * into Table_CSYS92050_HMC_Outtask_Id
from (
SELECT 
distinct 
      [company_id] new_Outtask_ID__c
	  , MatchAll_OuttaskID Outtask_ID__c
          , [MatchAll_SFDCId] id
      ,[MatchAll_SFDCName] Name
	  , entity_id new_HMC_Entity__c
	  , MatchAll_HMCEntityID HMC_Entity__c
	  , MatchAll_SFDC_AcctType
	  , MatchAll_SFDCTravel_org
from [DataMgmt_IT].[CONCUR\MinalC].[Table_Outtask_Account_MatchAll_And_SAs_SFDCjoin_MC]  
where company_id in (
  select company_id from [DataMgmt_IT].[CONCUR\MinalC].[Table_Outtask_Account_MatchAll_And_SAs_SFDCjoin_MC]    
  group by company_id 
  having COUNT(distinct MatchAll_SFDCId) = 1)  
and  MatchAll_SFDC_AcctType in (''Former Customer'',''Indirect Customer'',''Customer'')
and MatchAll_NameMatchValue in (3,4)
--and MatchAll_HMCEntityID is null and entity_id is not null
and MatchAll_OuttaskID is null
--order by MatchAll_SFDC_AcctType, MatchAll_SFDCTravel_org
) a
', @level0type = N'SCHEMA', @level0name = N'CONCUR\MinalC', @level1type = N'TABLE', @level1name = N'Table_CSYS92050_HMC_Outtask_Id';

