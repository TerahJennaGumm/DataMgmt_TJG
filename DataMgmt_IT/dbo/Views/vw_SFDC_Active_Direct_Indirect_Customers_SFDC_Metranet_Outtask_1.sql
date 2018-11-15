

CREATE VIEW [dbo].[vw_SFDC_Active_Direct_Indirect_Customers_SFDC_Metranet_Outtask] AS (
SELECT s.*,   o.SAMatch_company_id, o.SAMatch_MN_Bus_Login, o.SAMatch_MN_Sec_Bus_Login, [SAMatch_HMCEntityID]
FROM [dbo].[Active_Direct_Indirect_Customers_SFDC_Metranet_Status]  s
LEFT JOIN [Metranet_BusinessCustomer_Status] ss ON ss.[MNAccountName] = s.id
LEFT JOIN [CONCUR\MinalC].[Table_Outtask_Account_MatchAll_And_SAs_SFDCjoin_MC] o ON ( s.id = SAMatch_MN_Bus_Login OR s.id = SAMatch_MN_Sec_Bus_Login) )

