CREATE TABLE [dbo].[OpportunityContactRole] (
    [ContactId]        NCHAR (18)    NOT NULL,
    [CreatedById]      NCHAR (18)    NULL,
    [CreatedDate]      DATETIME2 (7) NOT NULL,
    [Id]               NCHAR (18)    NOT NULL,
    [IsDeleted]        VARCHAR (5)   NOT NULL,
    [IsPrimary]        VARCHAR (5)   NOT NULL,
    [LastModifiedById] NCHAR (18)    NULL,
    [LastModifiedDate] DATETIME2 (7) NOT NULL,
    [OpportunityId]    NCHAR (18)    NOT NULL,
    [Role]             NVARCHAR (40) NULL,
    [SystemModstamp]   DATETIME2 (7) NOT NULL,
    CONSTRAINT [PK_OpportunityContactRole_Id] PRIMARY KEY NONCLUSTERED ([Id] ASC)
);

