

CREATE VIEW [dbo].[View_SFDC_Concur_GDSX_Customers] AS
(
SELECT  a.Id, a.Type, a.Site, a.Name, s.MNAccountId, s.MNAccountName, s.MNCustomerStatus, rva.nm_login, rva.id_acc, rva.c_ReferralType 
--h.*, s.*,a.* 
FROM 
[$(DataMgmt_Metranet)].dbo.rpt_v_account rva 
LEFT JOIN [$(DataMgmt_Metranet)].[dbo].[rpt_v_accountflattenedhierarchy] h ON rva.id_acc = service_id_acc
LEFT JOIN [vw_Metranet_BusinessCustomer_Status] s ON s.[MNAccountId] = h.business_id_acc
LEFT JOIN [AccountID_NAME_TYPE_BillingSite] a ON s.MNAccountName = a.id
WHERE rva.nm_login LIKE 'GDSX_compleat_%' )




