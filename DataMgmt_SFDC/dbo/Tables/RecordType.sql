CREATE TABLE [dbo].[RecordType] (
    [BusinessProcessId] NCHAR (18)     NULL,
    [CreatedById]       NCHAR (18)     NULL,
    [CreatedDate]       DATETIME2 (7)  NOT NULL,
    [Description]       NVARCHAR (255) NULL,
    [DeveloperName]     NVARCHAR (80)  NOT NULL,
    [Id]                NCHAR (18)     NOT NULL,
    [IsActive]          VARCHAR (5)    NOT NULL,
    [LastModifiedById]  NCHAR (18)     NULL,
    [LastModifiedDate]  DATETIME2 (7)  NOT NULL,
    [Name]              NVARCHAR (80)  NOT NULL,
    [NamespacePrefix]   NVARCHAR (15)  NULL,
    [SobjectType]       NVARCHAR (40)  NOT NULL,
    [SystemModstamp]    DATETIME2 (7)  NOT NULL,
    CONSTRAINT [PK_RecordType_Id] PRIMARY KEY CLUSTERED ([Id] ASC) WITH (FILLFACTOR = 100)
);

