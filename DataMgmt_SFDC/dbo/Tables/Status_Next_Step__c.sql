CREATE TABLE [dbo].[Status_Next_Step__c] (
    [Id]               NCHAR (18)      NOT NULL,
    [CreatedDate]      DATETIME        NOT NULL,
    [Next_Step__c]     NVARCHAR (2500) NULL,
    [SystemModstamp]   DATETIME        NOT NULL,
    [Opportunity__c]   NCHAR (18)      NULL,
    [Title_Acronym__c] NVARCHAR (80)   NULL,
    PRIMARY KEY CLUSTERED ([Id] ASC)
);

