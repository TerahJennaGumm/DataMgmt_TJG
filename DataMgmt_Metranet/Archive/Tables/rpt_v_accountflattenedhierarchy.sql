CREATE TABLE [Archive].[rpt_v_accountflattenedhierarchy] (
    [ArchiveID]                 INT            NOT NULL,
    [root_acct_type]            VARCHAR (200)  NULL,
    [num_generations]           INT            NULL,
    [root_id_acc]               NVARCHAR (128) NULL,
    [business_id_acc]           NVARCHAR (128) NULL,
    [secondary_business_id_acc] NVARCHAR (128) NULL,
    [service_id_acc]            NVARCHAR (128) NULL,
    [billing_id_acc]            INT            NULL
);


GO
CREATE CLUSTERED INDEX [cx_rpt_v_accountflattenedhierarchy]
    ON [Archive].[rpt_v_accountflattenedhierarchy]([ArchiveID] ASC);

