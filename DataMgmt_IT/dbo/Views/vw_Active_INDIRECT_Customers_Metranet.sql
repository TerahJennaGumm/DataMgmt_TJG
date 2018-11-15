

CREATE VIEW [dbo].[vw_Active_INDIRECT_Customers_Metranet]
AS
(SELECT DISTINCT
		rva.c_CBTravelConfigID
	   ,rva.c_CBSFAID
	   ,rva.c_CBCompanyID ---indirect CB id - main company site --may have multiple SFDC accounts based on implementation needs
	   ,rva.c_CBMasterAcct
	   ,rva.c_CBAgencyID ---TMCs CB id
	   ,rva.nm_login MNCustomerName
	   ,rva1.c_Company
	   ,tam.nm_login
	   ,tam.nm_space
	   ,rva.t_acccount_type__name
	   ,vmbcs.MNAccountName ActiveCustName
	FROM DataMgmt_Metranet.dbo.rpt_v_account rva
	JOIN DataMgmt_Metranet.dbo.rpt_v_accountcontact rva1
		ON rva.id_acc = rva1.id_acc
	JOIN DataMgmt_Metranet.dbo.t_account_mapper tam
		ON tam.id_acc = rva.id_acc
	JOIN DataMgmt_Metranet.dbo.vw_Metranet_BusinessCustomer_Status vmbcs
		ON vmbcs.MNAccountId = rva.id_acc
	WHERE rva.c_CBAgencyID IS NOT NULL AND c_CBTravelConfigID IS NOT NULL--- change to agency id is populated then they are indirect or TMC
--ORDER BY rva1.c_Company
)





