CREATE TABLE [dbo].[Invoice_Details__c] (
    [Bill_Rate_per_Hour__c] DECIMAL (18, 2) NULL,
    [CreatedById]           NCHAR (18)      NULL,
    [CreatedDate]           DATETIME        NOT NULL,
    [CurrencyIsoCode]       NVARCHAR (3)    NULL,
    [Employee__c]           NCHAR (18)      NULL,
    [Expense_Amount__c]     DECIMAL (18, 2) NULL,
    [Expense_Code__c]       NVARCHAR (20)   NULL,
    [Hours__c]              DECIMAL (18, 2) NULL,
    [Id]                    NCHAR (18)      NOT NULL,
    [Invoice__c]            NCHAR (18)      NOT NULL,
    [IsDeleted]             VARCHAR (5)     NOT NULL,
    [LastModifiedById]      NCHAR (18)      NULL,
    [LastModifiedDate]      DATETIME        NOT NULL,
    [Name]                  NVARCHAR (80)   NULL,
    [RecordTypeId]          NCHAR (18)      NULL,
    [SystemModstamp]        DATETIME        NOT NULL,
    [Task_Code__c]          NVARCHAR (20)   NULL,
    [Work_Date__c]          DATETIME        NULL,
    CONSTRAINT [PK_Invoice_Details__c] PRIMARY KEY CLUSTERED ([Id] ASC)
);

