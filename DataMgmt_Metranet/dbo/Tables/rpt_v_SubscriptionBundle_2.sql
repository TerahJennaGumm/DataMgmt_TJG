CREATE TABLE [dbo].[rpt_v_SubscriptionBundle] (
    [c_IdSub]    INT           NULL,
    [c_IsMaster] NVARCHAR (99) NULL,
    [id_sched]   INT           NOT NULL,
    [dt_start]   DATETIME      NULL,
    [dt_end]     DATETIME      NULL
);


GO
CREATE NONCLUSTERED INDEX [rpt_v_SubscriptionBundle_n1]
    ON [dbo].[rpt_v_SubscriptionBundle]([c_IdSub] ASC)
    INCLUDE([id_sched], [c_IsMaster], [dt_start], [dt_end]);

