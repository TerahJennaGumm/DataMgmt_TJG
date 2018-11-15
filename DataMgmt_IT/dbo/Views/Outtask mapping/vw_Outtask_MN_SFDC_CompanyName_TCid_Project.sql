CREATE VIEW [dbo].[vw_Outtask_MN_SFDC_Project_CompanyName_TCid]
	AS 
	(
	SELECT  
DISTINCT 
vsaf.Name, omcer.company_name, omcer.nm_login_SecBusCust, omcer.nm_login_PrimaryBusCust, omcer.nm_login 
, vsaf.Id, DIFFERENCE(vsaf.Name, omcer.company_name) SFDCCompanyNameMatch
, rva.c_Company, DIFFERENCE(rva.c_Company, omcer.company_name) MNCompanyNameMatch, vsaf.type, vsaf.Travel_Org_Type__c
, omcer.travel_config_id
FROM OuttaskMatching_contract_external_reference omcer
 LEFT JOIN [$(DataMgmt_Metranet)].dbo.rpt_v_account d ON CONCAT('0-',omcer.travel_config_id ) = d.nm_login
 LEFT JOIN [$(DataMgmt_Metranet)].dbo.rpt_v_accountcontact rva ON (d.id_acc = rva.id_acc OR rva.c_Company like omcer.company_name)
 LEFT JOIN vw_Salesforce_Account_selectFields vsaf  ON vsaf.name like rva.c_Company
 LEFT JOIN [$(DataMgmt_SFDC)].dbo.pse__proj__c ppc ON ppc.Account_ID__c = vsaf.Id ----SQL23 probbaly does not have all the prject fields 
 WHERE 
 DIFFERENCE(rva.c_Company, omcer.company_name)  IS NOT NULL 
 OR 
 DIFFERENCE(vsaf.Name, omcer.company_name) IS NOT NULL

 )
