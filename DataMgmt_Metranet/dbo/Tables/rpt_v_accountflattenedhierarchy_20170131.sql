CREATE TABLE [dbo].[rpt_v_accountflattenedhierarchy_20170131] (
    [root_acct_type]            VARCHAR (200)  NOT NULL,
    [num_generations]           INT            NOT NULL,
    [root_id_acc]               NVARCHAR (128) NULL,
    [business_id_acc]           NVARCHAR (128) NULL,
    [secondary_business_id_acc] NVARCHAR (128) NULL,
    [service_id_acc]            NVARCHAR (128) NULL,
    [billing_id_acc]            INT            NOT NULL
);

