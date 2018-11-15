CREATE TABLE [dbo].[mde_ml_account_stats_1] (
    [Id]             BIGINT          IDENTITY (1, 1) NOT NULL,
    [AccountId]      CHAR (18)       NULL,
    [Attribute]      NVARCHAR (255)  NULL,
    [AttributeValue] NVARCHAR (1000) NULL,
    [AttributeId]    INT             NULL,
    PRIMARY KEY CLUSTERED ([Id] ASC)
);


GO
CREATE NONCLUSTERED INDEX [idx_account_stats]
    ON [dbo].[mde_ml_account_stats_1]([AccountId] ASC);


GO
CREATE NONCLUSTERED INDEX [idx_account_stats_attribute]
    ON [dbo].[mde_ml_account_stats_1]([Attribute] ASC);

