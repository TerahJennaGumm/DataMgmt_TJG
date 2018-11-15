CREATE TABLE [dbo].[rpt_v_subscription_props] (
    [id_entity]            INT           NULL,
    [c_start_date]         DATETIME      NULL,
    [c_end_date]           DATETIME      NULL,
    [ConcurOrderID]        NVARCHAR (20) NULL,
    [SFDCOpportunityID]    NVARCHAR (20) NULL,
    [OriginalOrderType]    NVARCHAR (20) NULL,
    [DateCreate]           NVARCHAR (20) NULL,
    [InitialConcurOrderID] NVARCHAR (20) NULL,
    [ConcurOrderTERMID]    NVARCHAR (20) NULL,
    [LASTBMIACTION]        NVARCHAR (20) NULL,
    [LASTDATESUBMITTOSAP]  NVARCHAR (20) NULL,
    [LastUserSubmit]       NVARCHAR (20) NULL,
    [S4ProviderContractID] NVARCHAR (20) NULL,
    [ContractTermEndDate]  NVARCHAR (20) NULL,
    [ContractRenewalDate]  NVARCHAR (20) NULL,
    [OEDate]               NVARCHAR (20) NULL,
    [TermNumMonths]        NVARCHAR (20) NULL,
    [TermNoteDays]         NVARCHAR (20) NULL,
    [TimeAndMaterials]     NVARCHAR (20) NULL
);

