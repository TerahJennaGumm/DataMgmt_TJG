CREATE VIEW vw_table_Outtask_Companyname_match_SFDC_MN AS (
SELECT  rva.c_CBSFAID, rva.c_CBCompanyID, rva.c_CBAgencyID , o.*, vsaf.Acct_Owner_Business_Unit__c, vsaf.Type, vsaf.Travel_Org_Type__c, vsaf1.type PrimaryAcctType, vsaf1.Acct_Owner_Business_Unit__c PrimaryAcctBU
FROM [dbo].[Table_Outtask_Companyname_match_SFDC] o
LEFT JOIN [$(DataMgmt_Metranet)].dbo.rpt_v_account rva
ON rva.nm_login = o.[nm_login]
LEFT JOIN vw_Salesforce_Account_selectFields vsaf ON o.Id = vsaf.id
LEFT JOIN vw_Salesforce_Account_selectFields vsaf1 ON o.nm_login_PrimaryBusCust = vsaf1.id
WHERE rva.nm_login LIKE '0-%'
AND rva.c_CBSFAID != ''
AND rva.c_CBSFAID != o.Id
AND rva.c_CBCompanyID = 1534
AND vsaf.Type NOT IN ( 'Former Customer' , 'Prospect')
AND vsaf.Opportunities_Won__c > 0
--ORDER BY o.nm_login_PrimaryBusCust, o.nm_login 
)