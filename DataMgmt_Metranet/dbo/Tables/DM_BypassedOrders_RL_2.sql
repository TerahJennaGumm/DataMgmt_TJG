CREATE TABLE [dbo].[DM_BypassedOrders_RL] (
    [ImportQueueID]   FLOAT (53)     NULL,
    [ConcurOrderID]   NVARCHAR (255) NULL,
    [Operation]       NVARCHAR (255) NULL,
    [ImportStatus]    NVARCHAR (255) NULL,
    [ImportPriority]  FLOAT (53)     NULL,
    [RetryCount]      NVARCHAR (255) NULL,
    [QueueAddedDate]  DATETIME       NULL,
    [Active]          FLOAT (53)     NULL,
    [ImportMessage]   NVARCHAR (255) NULL,
    [LastUpdatedDate] NVARCHAR (255) NULL,
    [LastUpdatedBy]   NVARCHAR (255) NULL,
    [F12]             NVARCHAR (255) NULL
);

