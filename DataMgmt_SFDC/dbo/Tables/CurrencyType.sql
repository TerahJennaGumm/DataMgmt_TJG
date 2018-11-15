CREATE TABLE [dbo].[CurrencyType] (
    [ConversionRate]   DECIMAL (18, 6) NOT NULL,
    [CreatedById]      NCHAR (18)      NULL,
    [CreatedDate]      DATETIME2 (7)   NOT NULL,
    [DecimalPlaces]    INT             NOT NULL,
    [Id]               NCHAR (18)      NOT NULL,
    [IsActive]         VARCHAR (5)     NOT NULL,
    [IsCorporate]      VARCHAR (5)     NOT NULL,
    [IsoCode]          NVARCHAR (40)   NOT NULL,
    [LastModifiedById] NCHAR (18)      NULL,
    [LastModifiedDate] DATETIME2 (7)   NOT NULL,
    [SystemModstamp]   DATETIME2 (7)   NOT NULL,
    CONSTRAINT [PK_CurrencyType_Id] PRIMARY KEY CLUSTERED ([Id] ASC)
);

