
CREATE VIEW [dbo].[View_SFDC_Concur_GDSX_Customers] AS(
SELECT  a.Id, a.Type, a.Site, a.Name, s.MNAccountId, s.MNAccountName, s.MNCustomerStatus, rva.nm_login, rva.id_acc, rva.c_ReferralType 
--h.*, s.*,a.* 
FROM 
dbo.rpt_v_account rva 
LEFT JOIN [dbo].[rpt_v_accountflattenedhierarchy] h ON rva.id_acc = service_id_acc
LEFT JOIN [dbo].[vw_Metranet_BusinessCustomer_Status] s ON s.[MNAccountId] = h.business_id_acc
LEFT JOIN DataMgmt_IT.[dbo].[AccountID_NAME_TYPE_BillingSite] a ON s.MNAccountName = a.id
WHERE rva.nm_login LIKE 'GDSX_compleat_%' )


