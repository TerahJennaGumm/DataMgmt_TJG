

CREATE VIEW [dbo].[Active_INDIRECT_Customers_Metranet] AS (
SELECT  DISTINCT rva.c_CBTravelConfigID, rva.c_CBSFAID, rva.c_CBCompanyID, rva.c_CBMasterAcct, rva.c_CBAgencyID, rva.nm_login MNCustomerName, rva1.c_Company, tam.nm_login, tam.nm_space
, rva.t_acccount_type__name, vmbcs.MNAccountName ActiveCustName
FROM DataMgmt_Metranet.dbo.rpt_v_account rva
JOIN rpt_v_accountcontact rva1 ON rva.id_acc = rva1.id_acc
JOIN t_account_mapper tam ON tam.id_acc = rva.id_acc
JOIN vw_Metranet_BusinessCustomer_Status vmbcs ON vmbcs.MNAccountId = rva.id_acc
WHERE rva.c_CBCompanyID IS NOT NULL
--ORDER BY rva1.c_Company
 )