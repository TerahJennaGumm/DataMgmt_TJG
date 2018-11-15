CREATE TABLE [dbo].[company_list_2018_03_09] (
    [company_id]      FLOAT (53)     NULL,
    [company_name]    NVARCHAR (255) NULL,
    [address]         NVARCHAR (255) NULL,
    [city]            NVARCHAR (255) NULL,
    [state]           NVARCHAR (255) NULL,
    [zip_code]        NVARCHAR (255) NULL,
    [country_code]    NVARCHAR (255) NULL,
    [metranet]        NVARCHAR (255) NULL,
    [salesforce id]   NVARCHAR (255) NULL,
    [entity_id]       NVARCHAR (255) NULL,
    [SFDC_18_digitID] VARCHAR (30)   NULL
);


GO
CREATE NONCLUSTERED INDEX [entity_id]
    ON [dbo].[company_list_2018_03_09]([entity_id] ASC, [company_id] ASC, [company_name] ASC, [SFDC_18_digitID] ASC);

