CREATE VIEW [dbo].[vw_Metranet_Active_TMCs]
	AS (
	SELECT DISTINCT rva1.nm_login, id, Type, Travel_Org_Type__c , vmbcs.MNCustomerStatus, rva2.c_Company
FROM [$(DataMgmt_Metranet)].dbo.rpt_v_accountflattenedhierarchy rva
JOIN [$(DataMgmt_Metranet)].dbo.rpt_v_account rva1 ON rva1.id_acc = rva.business_id_acc
JOIN [$(DataMgmt_SFDC)].dbo.account ON rva1.nm_login = Id
JOIN vw_Metranet_BusinessCustomer_Status vmbcs ON vmbcs.MNAccountId = rva.business_id_acc 
LEFT JOIN [$(DataMgmt_Metranet)].dbo.rpt_v_accountcontact rva2 ON rva1.id_acc = rva2.id_acc
WHERE rva.num_generations = 4
--ORDER BY Travel_Org_Type__c
)