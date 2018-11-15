CREATE TABLE [dbo].[PricebookEntry] (
    [CreatedById]      NCHAR (18)      NULL,
    [CreatedDate]      DATETIME2 (7)   NOT NULL,
    [CurrencyIsoCode]  NVARCHAR (3)    NOT NULL,
    [Id]               NCHAR (18)      NOT NULL,
    [IsActive]         VARCHAR (5)     NOT NULL,
    [IsDeleted]        VARCHAR (5)     NOT NULL,
    [LastModifiedById] NCHAR (18)      NULL,
    [LastModifiedDate] DATETIME2 (7)   NOT NULL,
    [Name]             NVARCHAR (255)  NULL,
    [Pricebook2Id]     NCHAR (18)      NOT NULL,
    [Product2Id]       NCHAR (18)      NOT NULL,
    [ProductCode]      NVARCHAR (255)  NULL,
    [SystemModstamp]   DATETIME2 (7)   NOT NULL,
    [UnitPrice]        DECIMAL (18, 2) NOT NULL,
    [UseStandardPrice] VARCHAR (5)     NOT NULL,
    CONSTRAINT [PK_PricebookEntry_Id] PRIMARY KEY CLUSTERED ([Id] ASC)
);

