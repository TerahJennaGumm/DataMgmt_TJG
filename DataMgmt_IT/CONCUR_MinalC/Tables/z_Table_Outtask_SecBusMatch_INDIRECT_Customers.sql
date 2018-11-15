CREATE TABLE [CONCUR\MinalC].[z_Table_Outtask_SecBusMatch_INDIRECT_Customers] (
    [company_id]                   NVARCHAR (8)   NULL,
    [company_name]                 NVARCHAR (255) NULL,
    [MatchSecBus_SFDCName]         NVARCHAR (255) NULL,
    [salesforce_account_18digitid] NVARCHAR (255) NULL,
    [MatchSecBus_SFDCsite]         NVARCHAR (80)  NULL,
    [MatchSecBus_SFDC_AcctType]    NVARCHAR (40)  NULL,
    [MatchSecBus_CB_SFAID]         NVARCHAR (255) NULL,
    [MatchSecBus_NameMatchValue]   INT            NULL,
    [MatchSecBus_WONOpportunities] DECIMAL (18)   NULL,
    [MatchSecBus_SFDCTravel_org]   NVARCHAR (255) NULL,
    [MatchSecBus_CBMasterAcct]     CHAR (1)       NULL
);

