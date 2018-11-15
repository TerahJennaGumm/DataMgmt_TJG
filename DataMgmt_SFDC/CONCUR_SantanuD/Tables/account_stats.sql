CREATE TABLE [CONCUR\SantanuD].[account_stats] (
    [Id]             BIGINT          IDENTITY (1, 1) NOT NULL,
    [AccountId]      CHAR (18)       NULL,
    [Attribute]      NVARCHAR (255)  NULL,
    [AttributeValue] NVARCHAR (1000) NULL,
    PRIMARY KEY CLUSTERED ([Id] ASC)
);


GO
CREATE NONCLUSTERED INDEX [idx_account_stats]
    ON [CONCUR\SantanuD].[account_stats]([AccountId] ASC);


GO
CREATE NONCLUSTERED INDEX [idx_account_stats_attribute]
    ON [CONCUR\SantanuD].[account_stats]([Attribute] ASC);

