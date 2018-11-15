CREATE VIEW [dbo].[vw_Outtask_Metranet_SFDC_TCid_Company_match]
	AS 
	(SELECT  vsaf.Name, a.company_name, a.nm_login_SecBusCust, a.nm_login_PrimaryBusCust, a.nm_login , vsaf.Id, DIFFERENCE(vsaf.Name, a.company_name) SFDCCompanyNameMatch
, rva.c_Company, DIFFERENCE(rva.c_Company, a.company_name) MNCompanyNameMatch, vsaf.type, vsaf.Travel_Org_Type__c
FROM 
(
SELECT  DISTINCT omcer.company_name
,  omcer.nm_login, omcer.travel_config_id, omcer.c_CBTravelConfigID, omcer.nm_login_SecBusCust, omcer.nm_login_PrimaryBusCust
FROM OuttaskMatching_contract_external_reference omcer
WHERE 
 CONCAT('0-',omcer.travel_config_id ) = omcer.nm_login
 ) a 
 
 LEFT JOIN [$(DataMgmt_Metranet)].dbo.rpt_v_account d ON CONCAT('0-',a.travel_config_id ) = d.nm_login
 LEFT JOIN [$(DataMgmt_Metranet)].dbo.rpt_v_accountcontact rva ON d.id_acc = rva.id_acc
 LEFT JOIN vw_Salesforce_Account_selectFields vsaf
 ON vsaf.name like rva.c_Company
 )
