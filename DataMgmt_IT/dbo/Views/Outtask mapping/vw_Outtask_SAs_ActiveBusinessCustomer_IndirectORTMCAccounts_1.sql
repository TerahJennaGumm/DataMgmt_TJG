
CREATE VIEW dbo.[vw_Outtask_SAs_ActiveBusinessCustomer_IndirectORTMCAccounts]
AS(
SELECT DISTINCT ac.id_acc,  ac.nm_login,c.business_login --, c.secondary_biz_login
, ac.c_CBSFAID, ac.c_CBAgencyID, c_CBMasterAcct
, ocls.*
FROM [$(DataMgmt_Metranet)].dbo.rpt_v_account ac
JOIN [dbo].[vw_MN_CustAccount] c ON (c_CBSFAID = c.secondary_biz_login OR c_CBSFAID = c.business_login )
RIGHT JOIN dbo.Outtask_Company_List_SA ocls ON (ac.nm_login = ocls.CONTRACT_EXTERNAL_REFERENCE_ID)
WHERE 
 ac.c_CBAgencyID IS NOT NULL OR
(ac.c_CBAgencyID IS  NULL AND ac.c_CBMasterAcct = 1)
AND ac.c_CBSFAID IS NULL
--ORDER BY ac.nm_login 
)





