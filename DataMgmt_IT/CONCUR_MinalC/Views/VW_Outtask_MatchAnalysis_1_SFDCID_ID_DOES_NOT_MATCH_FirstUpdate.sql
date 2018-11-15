

CREATE view [CONCUR\MinalC].[VW_Outtask_MatchAnalysis_1_SFDCID_ID_DOES_NOT_MATCH_FirstUpdate]
as
(
select  
[company_id]
      ,[company_name]
      ,[SFDC_18_digitID]
      ,[city]
      ,[Id]
      ,[Outtask_Entity_id]
      ,[Name]
      ,[Entity_ID__c]
      ,[HMC_Entity__c]
      ,[Outtask_ID__c]
      ,[NameMatchValue]
      ,[Type]
      ,[business_login]
      ,[Billing_Country__c]
      ,[Billing_City__c]
      ,[DunsNumber]
      ,[Global_Ultimate_Duns_Number__c]
      ,[SAP_Planning_Entity_Account_ID__c]
      ,[SAP_Account_ID__c]
      ,[Opportunities__c]
      ,[Opportunities_Won__c]
      ,[SAP_Business_Partner_Id__c]
      ,[Site]
      ,[Travel_Org_Type__c]
      ,[rrpu__Alert_Message__c]
      ,[Travel Config Id]
      ,[Travel Config Name]
      ,[Opportunity Name]
      ,[Account ID]
      ,[Account Name]
      ,[Company Id]
      ,[Agency Id]
      ,[TMC/Travel Agency]
      ,[Agency Account Id]
      ,[Indirect_18_digitID]
      ,[MatchAnalysis]
      ,[MatchAnalysisComments]
      ,s.[MNCustomerStatus]	 
	  from [CONCUR\MinalC].[Table__Outtask_Account_MatchAll_SFDC_MN_MASTER_NEW] a
	  join Metranet_BusinessCustomer_Status s on s.MNAccountName = a.Id
where company_id in(
select distinct a.company_id
from [CONCUR\MinalC].[Table__Outtask_Account_MatchAll_SFDC_MN_MASTER_NEW] a
where a.MatchAnalysis = '1'
group by a.company_id
having COUNT(a.Id)=1
)
and MatchAnalysis = '1'
and (Outtask_Entity_id = left (HMC_Entity__c, 12) or (Outtask_Entity_id = Entity_ID__c))
and SFDC_18_digitID != Id

)




