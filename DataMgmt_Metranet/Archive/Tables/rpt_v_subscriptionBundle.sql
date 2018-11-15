CREATE TABLE [Archive].[rpt_v_subscriptionBundle] (
    [ArchiveID]  INT           NOT NULL,
    [c_IdSub]    INT           NULL,
    [c_IsMaster] NVARCHAR (99) NULL,
    [id_sched]   INT           NULL,
    [dt_start]   DATETIME      NULL,
    [dt_end]     DATETIME      NULL
);


GO
CREATE CLUSTERED INDEX [cx_rpt_v_subscriptionBundle]
    ON [Archive].[rpt_v_subscriptionBundle]([ArchiveID] ASC);

