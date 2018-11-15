CREATE TABLE [dbo].[Credit_Memo_Quota__c] (
    [Active__c]        VARCHAR (5)     NOT NULL,
    [Business_Unit__c] NVARCHAR (255)  NULL,
    [CreatedById]      NCHAR (18)      NULL,
    [CreatedDate]      DATETIME        NOT NULL,
    [CurrencyIsoCode]  NVARCHAR (3)    NULL,
    [Fiscal_Period__c] NVARCHAR (10)   NULL,
    [Id]               NCHAR (18)      NOT NULL,
    [ID_Name__c]       NVARCHAR (255)  NULL,
    [IsDeleted]        VARCHAR (5)     NOT NULL,
    [LastModifiedById] NCHAR (18)      NULL,
    [LastModifiedDate] DATETIME        NOT NULL,
    [Month__c]         NVARCHAR (255)  NULL,
    [Name]             NVARCHAR (80)   NULL,
    [OwnerId]          NCHAR (18)      NOT NULL,
    [Quarter__c]       NVARCHAR (255)  NULL,
    [Quota__c]         DECIMAL (18, 2) NULL,
    [SystemModstamp]   DATETIME        NOT NULL,
    [Year__c]          NVARCHAR (4)    NULL,
    CONSTRAINT [PK_Credit_Memo_Quota__c] PRIMARY KEY CLUSTERED ([Id] ASC)
);

