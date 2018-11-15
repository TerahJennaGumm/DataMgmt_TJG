CREATE TABLE [Archive].[rpt_v_Subscription_Compleat_GDSX] (
    [ArchiveID]                  INT              NOT NULL,
    [id_sub]                     INT              NULL,
    [id_po]                      INT              NULL,
    [id_acc]                     INT              NULL,
    [vt_start]                   DATETIME         NULL,
    [vt_end]                     DATETIME         NULL,
    [id_pricelist]               INT              NULL,
    [id_pi_instance]             INT              NULL,
    [b_advance]                  CHAR (1)         NULL,
    [nm_desc]                    NVARCHAR (4000)  NULL,
    [id_sched]                   INT              NULL,
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
    [nm_instance_tablename]      VARCHAR (100)    NULL,
    [ConcurOrderLineID]          NVARCHAR (2000)  NULL,
    [c_CompanyCode]              INT              NULL,
    [c_CompanyDescription]       NVARCHAR (255)   NULL,
    [ConcurOrderLineIDRaw]       NVARCHAR (2000)  NULL,
    [CancelSubscription]         NVARCHAR (1)     NULL
);


GO
CREATE CLUSTERED INDEX [cx_rpt_v_subscription_compleat_gdsx]
    ON [Archive].[rpt_v_Subscription_Compleat_GDSX]([ArchiveID] ASC);

