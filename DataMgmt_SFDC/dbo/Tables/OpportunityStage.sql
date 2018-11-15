CREATE TABLE [dbo].[OpportunityStage] (
    [CreatedById]          NCHAR (18)     NULL,
    [CreatedDate]          DATETIME2 (7)  NOT NULL,
    [DefaultProbability]   DECIMAL (18)   NULL,
    [Description]          NVARCHAR (255) NULL,
    [ForecastCategory]     NVARCHAR (40)  NOT NULL,
    [ForecastCategoryName] NVARCHAR (40)  NOT NULL,
    [Id]                   NCHAR (18)     NOT NULL,
    [IsActive]             VARCHAR (5)    NOT NULL,
    [IsClosed]             VARCHAR (5)    NOT NULL,
    [IsWon]                VARCHAR (5)    NOT NULL,
    [LastModifiedById]     NCHAR (18)     NULL,
    [LastModifiedDate]     DATETIME2 (7)  NOT NULL,
    [MasterLabel]          NVARCHAR (255) NULL,
    [SortOrder]            INT            NULL,
    [SystemModstamp]       DATETIME2 (7)  NOT NULL,
    CONSTRAINT [PK_OpportunityStage_Id] PRIMARY KEY CLUSTERED ([Id] ASC) WITH (FILLFACTOR = 100)
);

