CREATE TABLE [dbo].[rpt_v_Subscription] (
    [id_sub]                     INT              NOT NULL,
    [id_po]                      INT              NOT NULL,
    [id_acc]                     INT              NULL,
    [vt_start]                   DATETIME         NOT NULL,
    [vt_end]                     DATETIME         NOT NULL,
    [id_pricelist]               INT              NULL,
    [id_pi_instance]             INT              NULL,
    [b_advance]                  CHAR (1)         NULL,
    [nm_desc]                    NVARCHAR (4000)  NULL,
    [id_sched]                   INT              NOT NULL,
    [n_order]                    INT              NULL,
    [id_audit]                   INT              NULL,
    [c_Tier]                     INT              NULL,
    [c_ICBRateCustCurr]          NUMERIC (22, 10) NULL,
    [c_PORateCustCurr]           NUMERIC (22, 10) NULL,
    [c_PORateUSD]                NUMERIC (22, 10) NULL,
    [c_ICBRateUSD]               NUMERIC (22, 10) NULL,
    [tt_start]                   DATETIME         NULL,
    [tt_end]                     DATETIME         NULL,
    [dt_start]                   DATETIME         NULL,
    [dt_end]                     DATETIME         NULL,
    [c_RatingType]               VARCHAR (32)     NULL,
    [c_UsgQualGroup]             NVARCHAR (255)   NULL,
    [c_AcctQualGroup]            NVARCHAR (255)   NULL,
    [c_CommitmentAmount]         NUMERIC (22, 10) NULL,
    [c_MonthsInCommitmentPeriod] INT              NULL,
    [c_CLINRate]                 NVARCHAR (100)   NULL,
    [nm_instance_tablename]      VARCHAR (100)    NOT NULL,
    [ConcurOrderLineID]          NVARCHAR (60)    NULL,
    [c_CompanyCode]              INT              NULL,
    [c_CompanyDescription]       NVARCHAR (255)   NULL,
    [ConcurOrderLineIDRaw]       NVARCHAR (100)   NULL,
    [CancelSubscription]         NVARCHAR (1)     NULL
);


GO
CREATE CLUSTERED INDEX [rpt_v_Subscription_pk]
    ON [dbo].[rpt_v_Subscription]([id_sub] ASC, [id_pi_instance] ASC, [id_sched] ASC, [n_order] ASC);


GO
CREATE NONCLUSTERED INDEX [rpt_v_Subscription_n1]
    ON [dbo].[rpt_v_Subscription]([n_order] ASC)
    INCLUDE([id_sub], [id_po], [id_pi_instance], [c_Tier], [dt_start], [dt_end]);


GO
CREATE NONCLUSTERED INDEX [rpt_v_Subscription_n2]
    ON [dbo].[rpt_v_Subscription]([vt_end] ASC)
    INCLUDE([id_sub], [id_po], [id_acc], [vt_start], [id_pi_instance], [id_sched], [n_order], [c_PORateCustCurr], [dt_start], [dt_end], [c_UsgQualGroup]);


GO
CREATE NONCLUSTERED INDEX [rpt_v_Subscription_n3]
    ON [dbo].[rpt_v_Subscription]([id_po] ASC, [id_pi_instance] ASC, [vt_end] ASC)
    INCLUDE([id_acc]);


GO
CREATE NONCLUSTERED INDEX [idx_id_sub]
    ON [dbo].[rpt_v_Subscription]([id_sub] ASC)
    INCLUDE([vt_start], [vt_end], [dt_start], [dt_end], [id_pi_instance], [n_order]);


GO
CREATE NONCLUSTERED INDEX [rpt_v_Subscription_n4]
    ON [dbo].[rpt_v_Subscription]([id_acc] ASC, [id_pi_instance] ASC);


GO
CREATE NONCLUSTERED INDEX [rpt_v_Subscription_n5]
    ON [dbo].[rpt_v_Subscription]([id_pi_instance] ASC, [n_order] ASC)
    INCLUDE([id_sub], [id_po], [dt_start], [dt_end]);

