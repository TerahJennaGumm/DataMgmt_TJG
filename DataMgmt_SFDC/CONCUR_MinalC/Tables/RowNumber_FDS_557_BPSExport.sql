CREATE TABLE [CONCUR\MinalC].[RowNumber_FDS_557_BPSExport] (
    [RowNum]           BIGINT         NULL,
    [OrganizationType] NVARCHAR (255) NULL,
    [Organization]     NVARCHAR (255) NULL,
    [Regidate]         NVARCHAR (255) NOT NULL,
    [RiskLevel]        NVARCHAR (255) NULL,
    [AddressId]        NVARCHAR (255) NULL,
    [ValidFrom]        NVARCHAR (255) NOT NULL,
    [CompanyName]      NVARCHAR (255) NOT NULL,
    [AKACompanyName]   VARCHAR (1)    NOT NULL,
    [Country]          NVARCHAR (255) NOT NULL,
    [PostCode]         NVARCHAR (255) NOT NULL,
    [City]             NVARCHAR (255) NOT NULL,
    [State]            NVARCHAR (255) NOT NULL,
    [Street]           NVARCHAR (255) NOT NULL,
    [Street2]          NVARCHAR (255) NOT NULL,
    [OrigCountry]      NVARCHAR (255) NOT NULL
);

