/*
SELECT 
--       top 10
       id,
       name,
	   type,
	   (SELECT count(*)
	      FROM datamgmt_sfdc.dbo.opportunity o
		 WHERE 1=1
		   AND o.account_id__c = a.id
	   ) opp_count,
	   (SELECT count(*)
	      FROM datamgmt_sfdc.dbo.contact c
		 WHERE 1=1
		   AND c.accountid = a.id
	   ) cont_count,
	   (SELECT count(*)
	      FROM datamgmt_sfdc.dbo.activityhistory ah
		 WHERE 1=1
		   AND ah.activityhistories_accountid = a.id
	   ) acvt_count
  FROM datamgmt_sfdc.dbo.account a






-- Find multi-byte accounts with opportunities
select a.id,
       a.type,
       a.name,
	   a.aka_company_name__c
--	   cast(name as VARCHAR(MAX)) m_name,
--	   case
--	     when cast(name as VARCHAR(MAX)) <> name then
--		    'Multi-Byte'
--		 else
--		    'No Multi-Byte'
--	   end Multi_Byte_Status
 from datamgmt_sfdc.dbo.account a
 where 1=1
 and cast(name as VARCHAR(MAX)) <> name
 and exists (select 1
               from datamgmt_sfdc.dbo.opportunity o
			  where 1=1
			    and o.account_id__c = a.id
		    )


-- 40,124
-- 2,737

select *
from
(
SELECT 
--       top 10
       id,
       name,
	   type,
	   (SELECT count(*)
	      FROM datamgmt_sfdc.dbo.opportunity o
		 WHERE 1=1
		   AND o.account_id__c = a.id
	   ) opp_count,
	   (SELECT count(*)
	      FROM datamgmt_sfdc.dbo.contact c
		 WHERE 1=1
		   AND c.accountid = a.id
	   ) cont_count,
	   (SELECT count(*)
	      FROM datamgmt_sfdc.dbo.activityhistory ah
		 WHERE 1=1
		   AND ah.activityhistories_accountid = a.id
	   ) acvt_count
  FROM datamgmt_sfdc.dbo.account a
) m
where 1=1
and m.opp_count = 0
and m.cont_count = 0
and m.acvt_count = 0
*/

--drop view VW_MultiByte_Accounts
--go

----- This is the Real Query to get Multi-Byte Accounts from Salesforce Account 

CREATE VIEW dbo.VW_MultiByte_Accounts AS
-- 40,124
SELECT -- Generic columns
       a.id                               Salesforce_ID,
       a.type                             Account_Type,
       a.name                             Account_Name,
	   a.aka_company_name__c              AKA_Name,
	   a.BPS_Status__c                    BPS_Status,
       -- Territory Columns
	   a.Acct_Owner_Business_Unit__c      Business_Unit,
	   a.Acct_Owner_Theater__c            Theater,
	   a.Acct_Owner_Market__c             Market,
	   a.Acct_Owner_Region__c             Region,
	   a.Acct_Owner_Team__c               Team,
	   -- Address columns
	   a.Billing_St__c                    Street1,
       a.Billing_St_Line_2__c             Street2,
	   a.Billing_City__c                  City,
	   a.Billing_County__c                County,
	   a.Billing_State_Province__c        State,
	   a.Billing_Zip_Postal__c            Postal_Code,
	   a.Billing_Country__c               Country,
       -- Measures
	   (SELECT count(*)
	      FROM datamgmt_sfdc.dbo.opportunity o
		 WHERE 1=1
		   AND o.account_id__c = a.id
	   )                                  opp_count,
	   (SELECT count(*)
	      FROM datamgmt_sfdc.dbo.contact c
		 WHERE 1=1
		   AND c.accountid = a.id
	   )                                  contact_count,
	   (SELECT count(*)
	      FROM datamgmt_sfdc.dbo.activityhistory ah
		 WHERE 1=1
		   AND ah.activityhistories_accountid = a.id
	   )                                  acvty_count,
       -- Record history
	   a.CreatedDate                      Created_Date,
	   u.name                             Created_By
 FROM datamgmt_sfdc.dbo.account a
 JOIN [datamgmt_sfdc].[dbo].[user] u
      ON (a.CreatedById = u.id)
 WHERE 1=1
 AND CAST(a.name as VARCHAR(MAX)) <> a.name