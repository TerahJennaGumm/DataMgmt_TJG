CREATE TABLE [dbo].[rpt_v_Subscription_Compleat_GDSX] (
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
    [ConcurOrderLineID]          NVARCHAR (2000)  NULL,
    [c_CompanyCode]              INT              NULL,
    [c_CompanyDescription]       NVARCHAR (255)   NULL,
    [ConcurOrderLineIDRaw]       NVARCHAR (2000)  NULL,
    [CancelSubscription]         NVARCHAR (1)     NULL
);


GO
CREATE CLUSTERED INDEX [rpt_v_Subscription_Compleat_GDSX_pk]
    ON [dbo].[rpt_v_Subscription_Compleat_GDSX]([id_sub] ASC, [id_pi_instance] ASC, [id_sched] ASC, [n_order] ASC);


GO
CREATE NONCLUSTERED INDEX [idx_rpt_v_Subscription_Compleat_GDSX_id_sub_includes6]
    ON [dbo].[rpt_v_Subscription_Compleat_GDSX]([id_sub] ASC)
    INCLUDE([vt_start], [vt_end], [dt_start], [dt_end], [id_pi_instance], [n_order]);

