﻿
CREATE VIEW vw_Salesforce_Account_selectFields AS (
SELECT [AccountStatus__c]
      ,[AccountNumber]
      ,[Billing_City__c]
      ,[Billing_Contact__c]
      ,[Billing_Country__c]
      ,[Billing_County__c]
      ,[Billing_Cycle__c]
      ,[Billing_Email__c]
      ,[Billing_First_Name__c]
      ,[Billing_Last_Name__c]
      ,[Billing_St__c]
      ,[Billing_St_Line_2__c]
      ,[Billing_State_Province__c]
      ,[Billing_Zip_Postal__c]
      ,[Business_Unit__c]
      ,[Categorization__c]
      ,[Cliqbook_Reseller__c]
      ,[Contract_Effective_Date__c]
      ,[Contract_Renewal_Date__c]

      ,[Contract_Termination_Date__c]
      ,[Contracting_Entity__c]
      ,[Country_Scope__c]
      ,[CRM__c]
      ,[Customer_Currency__c]
      ,[Customer_Region__c]
      ,[Customer_Since__c]
      ,[DunsParentAccount__c]
      ,[DunsUltimateParentAccount__c]
      ,[Entity_ID__c]
      ,[Global_Parent_Account__c]


      ,[Immediate_Parent_DUNS__c]
      ,[Id]
      ,[Implementation_Status__c]
      ,[NAICS_Code__c]
      ,[NAICS_Description__c]
      ,[Name]
  
      ,[Notice_Address_City__c]
      ,[Notice_Address_Country__c]
      ,[Notice_Address_County__c]
      ,[Notice_Address_State__c]
      ,[Notice_Address_Street_1__c]
      ,[Notice_Address_Street_2__c]
      ,[Notice_Address_Zip__c]
      ,[Notice_Email__c]
      ,[Notice_Fax__c]
      ,[Notice_First_Name__c]
      ,[Notice_Last_Name__c]
      ,[Notice_Telephone__c]
      ,[Open_Won__c]
      ,[Opportunities__c]
      ,[Opportunities_Open__c]
      ,[Opportunities_Won__c]
      ,[Payment_Method__c]
      ,[Payment_Terms__c]
      ,[Payment_Type__c]
      ,[Pre_Production__c]
      ,[Concur_Primary_Account__c]
      ,[Preferred_SAP_Account_Contact__c]
      ,[SAP_Account_ID__c]
      ,[SAP_Account_Type__c]
      ,[SAP_Financial_Customer__c]
      ,[SAP_Internal_Account_Classification__c]
      --,[SAP_Global_Ultimate_Account__c]
      --,[SAP_Named_Global_Ultimate__c]
      ,[SAP_Segment_Alignment__c]
      ,[SAP_Global_Ultimate_Roll_Up__c]
   
      ,[SAP_Global_Ultimate_Account_ID__c]
      ,[SAP_Data_Verified_Date__c]
      --,[Sap_Max_tAttention__c]

      ,[SAP_Business_Partner_Id__c]
      ,[SAP_Planning_PE_Locked__c]
      ,[SAP_Previous_Year_PE_ID_Locked__c]
      ,[SAP_Planning_Entity_Account_ID__c]
      ,[Service_Address_City__c]
      ,[Service_Address_Country__c]
      ,[Service_Address_County__c]
      ,[Service_Address_State__c]
      ,[Service_Address_Street_1__c]
      ,[Service_Address_Street_2__c]
      ,[Service_Address_Zip__c]
      ,[Service_First_Name__c]
      ,[Service_Last_Name__c]
      ,[Service_Email__c]
      ,[Tax_Exemption_Claimed__c]
      ,[Tax_ID_Number__c]
      --,[Termination_for_Convenience__c]
      ,[Termination_Notice_Period__c]
      ,[TMC_Travel_Agency__c]
      ,[TMC_Travel_Agency_Contract_Exp_Date__c]
      ,[TMC_Travel_Agency_Other__c]
      --,[TMCs__c]
      ,[Travel_Org_Type__c]
      ,[TripIt_for_Business__c]
      ,[TripIt_For_Business_Subscription_ID__c]
      --,[TripIt_Users__c]
      --,[TripIt_Group_Name__c]
      --,[TripIt_Pro__c]
      ,[Type]
      ,[Vertical_Grouping__c]
      ,[Acct_Owner_Business_Unit__c]
      ,[Acct_Owner_Division__c]
      ,[Acct_Owner_Market__c]
      ,[Acct_Owner_Region__c]
      ,[Acct_Owner_Team__c]
      ,[Acct_Owner_Revenue_Group__c]
      ,[Acct_Owner_Theater__c]
      ,[HMC_Entity__c]
      ,[Edition__c]
      ,[Global_Account__c]
      ,[Revenue_Category__c]
      ,[Size_category__c]
      ,[D_B_Employees_at_Location__c]
      ,[D_B_Employees_Worldwide__c]
      ,[Global_Ultimate_Duns_Number__c]
      ,[Named_Partner__c]
      ,[DunsNumber]
      ,[Outtask_ID__c]
      ,[Data_Center__c]
  FROM [$(DataMgmt_SFDC)].dbo.account )
