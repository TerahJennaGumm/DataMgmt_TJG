CREATE TABLE [dbo].[mde_ml_account_stats] (
    [Id]             BIGINT          IDENTITY (1, 1) NOT NULL,
    [AccountId]      NCHAR (18)      NULL,
    [AttributeId]    INT             NULL,
    [AttributeValue] NVARCHAR (2000) NULL,
    [modifiedTS]     BIGINT          DEFAULT (CONVERT([bigint],replace(replace(replace(replace(CONVERT([char](23),getutcdate(),(121)),'-',''),':',''),'.',''),' ',''),0)) NULL,
    PRIMARY KEY CLUSTERED ([Id] ASC)
);


GO
CREATE NONCLUSTERED INDEX [idx_mde_ml_account_stats_att]
    ON [dbo].[mde_ml_account_stats]([AccountId] ASC, [AttributeId] ASC);

