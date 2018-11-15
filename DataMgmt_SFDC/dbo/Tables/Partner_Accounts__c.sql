CREATE TABLE [dbo].[Partner_Accounts__c] (
    [CreatedById]      NCHAR (18)    NULL,
    [CreatedDate]      DATETIME2 (7) NOT NULL,
    [CurrencyIsoCode]  NVARCHAR (3)  NULL,
    [Id]               NCHAR (18)    NOT NULL,
    [IsDeleted]        VARCHAR (5)   NOT NULL,
    [LastActivityDate] DATETIME2 (7) NULL,
    [LastModifiedById] NCHAR (18)    NULL,
    [LastModifiedDate] DATETIME2 (7) NOT NULL,
    [Name]             NVARCHAR (80) NULL,
    [OwnerId]          NCHAR (18)    NOT NULL,
    [SystemModstamp]   DATETIME2 (7) NOT NULL,
    CONSTRAINT [PK_Partner_Accounts__c_Id] PRIMARY KEY NONCLUSTERED ([Id] ASC)
);

