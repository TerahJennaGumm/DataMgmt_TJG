CREATE TABLE [dbo].[mde_ml_account_stats_2] (
    [Id]             BIGINT          IDENTITY (1, 1) NOT NULL,
    [AccountId]      CHAR (18)       NULL,
    [Attribute]      NVARCHAR (255)  NULL,
    [AttributeValue] NVARCHAR (1000) NULL,
    [AttributeId]    INT             NULL,
    PRIMARY KEY CLUSTERED ([Id] ASC)
);

