


CREATE view [CONCUR\MinalC].[VW_Outtask_Analysis_SFDC_Accts_cleanUp]
as 
(
select  
  [MatchAnalysis]
      ,[MatchAnalysisComments]
	  , MNCustomerStatus MetranetCustomerStatus
      ,[company_id] [OUTTASK_company_id]
      ,[company_name] [OUTTASK_company_name]
      ,[SFDC_18_digitID] [OUTTASK_SFDC_18_digitID]
      ,[city] [OUTTASK_city]
      ,[Outtask_Entity_id] [OUTTASK_Entity_id]


	  ,[Id] [SFDC_Account_Id]
      ,[Name]   [SFDC_Account_Name]
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
      ,[Account ID] [IndirectAccount_ID]
      ,[Account Name] [SFDC_IndirectAccount_Name]
      ,[Company Id] [SFDC_IndirectAccount_CompanyId]
      ,[Agency Id] [SFDC_IndirectAccount_AgencyId]
      ,[TMC/Travel Agency] [SFDC_IndirectAccount_TravelAgency]
      ,[Agency Account Id] [SFDC_TravelAgencyAccount_ID]
      ,[Indirect_18_digitID] [SFDC_IndirectAccount_18ID]
    
     
from Table__Outtask_Account_MatchAll_SFDC_MN_MASTER_NEW c
left join [CONCUR\MinalC].[Metranet_BusinessCustomer_Status] s
on c.Id = s.MNAccountName
where (MatchAnalysis  = 'D'  or  MatchAnalysis =  'cleanup' or   MatchAnalysis =  '00')
)
