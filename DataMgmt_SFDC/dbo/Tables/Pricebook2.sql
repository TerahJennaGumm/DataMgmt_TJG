CREATE TABLE [dbo].[Pricebook2] (
    [CreatedById]      NCHAR (18)     NULL,
    [CreatedDate]      DATETIME2 (7)  NOT NULL,
    [CurrencyIsoCode]  NVARCHAR (3)   NULL,
    [Description]      NVARCHAR (255) NULL,
    [Id]               NCHAR (18)     NOT NULL,
    [IsActive]         VARCHAR (5)    NOT NULL,
    [IsDeleted]        VARCHAR (5)    NOT NULL,
    [IsStandard]       VARCHAR (5)    NOT NULL,
    [LastModifiedById] NCHAR (18)     NULL,
    [LastModifiedDate] DATETIME2 (7)  NOT NULL,
    [Name]             NVARCHAR (255) NOT NULL,
    [SystemModstamp]   DATETIME2 (7)  NOT NULL,
    CONSTRAINT [PK_Pricebook2_Id] PRIMARY KEY CLUSTERED ([Id] ASC) WITH (FILLFACTOR = 100)
);

