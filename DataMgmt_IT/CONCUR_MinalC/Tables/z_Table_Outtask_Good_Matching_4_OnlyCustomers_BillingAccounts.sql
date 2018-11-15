﻿CREATE TABLE [CONCUR\MinalC].[z_Table_Outtask_Good_Matching_4_OnlyCustomers_BillingAccounts] (
    [company_id]                     NVARCHAR (8)   NULL,
    [Outtask_service_id]             NVARCHAR (255) NULL,
    [MatchAll_SFDCId]                NCHAR (18)     NULL,
    [MatchAll_SFDCName]              NVARCHAR (255) NULL,
    [MatchAll_NameMatchValue]        INT            NULL,
    [MatchAll_SFDC_WONOpportunities] DECIMAL (18)   NULL,
    [MatchAll_SFDCsite]              NVARCHAR (80)  NULL,
    [MatchAll_SFDC_AcctType]         NVARCHAR (40)  NULL,
    [MatchAll_SFDCTravel_org]        NVARCHAR (255) NULL,
    [company_name]                   NVARCHAR (255) NULL,
    [salesforce_account_18digitid]   NVARCHAR (255) NULL,
    [SAMatch_MN_Bus_Login]           NVARCHAR (255) NULL,
    [SAMatch_SFDCName]               NVARCHAR (255) NULL,
    [SAMatch_NameMatchValue]         INT            NULL,
    [SAMatch_SFDC_WONOpportunities]  DECIMAL (18)   NULL,
    [SAMatch_SFDCsite]               NVARCHAR (80)  NULL,
    [SAMatch_SFDC_AcctType]          NVARCHAR (40)  NULL,
    [SAMatch_SFDCTravel_org]         NVARCHAR (255) NULL,
    [MatchSecBus_CB_SFAID]           NVARCHAR (255) NULL,
    [MatchSecBus_SFDCName]           NVARCHAR (255) NULL,
    [MatchSecBus_NameMatchValue]     INT            NULL,
    [MatchSecBus_WONOpportunities]   DECIMAL (18)   NULL,
    [MatchSecBus_SFDCsite]           NVARCHAR (80)  NULL,
    [MatchSecBus_SFDC_AcctType]      NVARCHAR (40)  NULL,
    [MatchSecBus_SFDCTravel_org]     NVARCHAR (255) NULL,
    [SAMatch_MN_Sec_Bus_Login]       NVARCHAR (255) NULL,
    [MatchSecBus_CBMasterAcct]       CHAR (1)       NULL
);
