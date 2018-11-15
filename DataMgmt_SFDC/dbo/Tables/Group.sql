CREATE TABLE [dbo].[Group] (
    [CreatedById]            NCHAR (18)     NULL,
    [CreatedDate]            DATETIME2 (7)  NOT NULL,
    [DeveloperName]          NVARCHAR (80)  NULL,
    [DoesIncludeBosses]      VARCHAR (5)    NOT NULL,
    [DoesSendEmailToMembers] VARCHAR (5)    NOT NULL,
    [Email]                  NVARCHAR (255) NULL,
    [Id]                     NCHAR (18)     NOT NULL,
    [LastModifiedById]       NCHAR (18)     NULL,
    [LastModifiedDate]       DATETIME2 (7)  NOT NULL,
    [Name]                   NVARCHAR (40)  NULL,
    [OwnerId]                NCHAR (18)     NOT NULL,
    [RelatedId]              NCHAR (18)     NULL,
    [SystemModstamp]         DATETIME2 (7)  NOT NULL,
    [Type]                   NVARCHAR (40)  NOT NULL,
    CONSTRAINT [PK_Group_Id] PRIMARY KEY NONCLUSTERED ([Id] ASC)
);

