CREATE TABLE [dbo].[rpt_v_accountflattenedhierarchy] (
    [root_acct_type]            VARCHAR (200)  NOT NULL,
    [num_generations]           INT            NOT NULL,
    [root_id_acc]               NVARCHAR (128) NULL,
    [business_id_acc]           NVARCHAR (128) NULL,
    [secondary_business_id_acc] NVARCHAR (128) NULL,
    [service_id_acc]            NVARCHAR (128) NULL,
    [billing_id_acc]            INT            NOT NULL
);


GO
CREATE NONCLUSTERED INDEX [rpt_v_accountflattenedhierarchy_n1]
    ON [dbo].[rpt_v_accountflattenedhierarchy]([service_id_acc] ASC)
    INCLUDE([business_id_acc], [billing_id_acc]);


GO
ALTER INDEX [rpt_v_accountflattenedhierarchy_n1]
    ON [dbo].[rpt_v_accountflattenedhierarchy] DISABLE;


GO
CREATE NONCLUSTERED INDEX [IDX_business_id_acc]
    ON [dbo].[rpt_v_accountflattenedhierarchy]([business_id_acc] ASC)
    INCLUDE([secondary_business_id_acc]);

