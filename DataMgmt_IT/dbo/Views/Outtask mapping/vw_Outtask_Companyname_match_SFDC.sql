CREATE VIEW [dbo].[vw_Outtask_Companyname_match_SFDC]
	AS 
	(
	SELECT DISTINCT vsaf.Name, a.company_name, a.nm_login_SecBusCust, a.nm_login_PrimaryBusCust, a.nm_login , vsaf.Id
FROM 
(
SELECT  DISTINCT omcer.company_name
,  omcer.nm_login, omcer.travel_config_id, omcer.c_CBTravelConfigID, omcer.nm_login_SecBusCust, omcer.nm_login_PrimaryBusCust
FROM OuttaskMatching_contract_external_reference omcer
WHERE 
 CONCAT('0-',omcer.travel_config_id ) = omcer.nm_login
 ) a JOIN vw_Salesforce_Account_selectFields vsaf
 ON a.company_name like vsaf.Name
 ) 