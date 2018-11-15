CREATE TABLE [dbo].[OpportunitySplit] (
    [CreatedById]      NCHAR (18)      NULL,
    [CreatedDate]      DATETIME2 (7)   NOT NULL,
    [CurrencyIsoCode]  NVARCHAR (3)    NOT NULL,
    [Id]               NCHAR (18)      NOT NULL,
    [IsDeleted]        VARCHAR (5)     NOT NULL,
    [LastModifiedById] NCHAR (18)      NULL,
    [LastModifiedDate] DATETIME2 (7)   NOT NULL,
    [OpportunityId]    NCHAR (18)      NOT NULL,
    [Split]            NVARCHAR (255)  NULL,
    [SplitAmount]      DECIMAL (18, 2) NULL,
    [SplitNote]        NVARCHAR (255)  NULL,
    [SplitOwnerId]     NCHAR (18)      NOT NULL,
    [SplitPercentage]  DECIMAL (18, 2) NOT NULL,
    [SystemModstamp]   DATETIME2 (7)   NOT NULL,
    CONSTRAINT [PK_OpportunitySplit_Id] PRIMARY KEY CLUSTERED ([Id] ASC)
);

