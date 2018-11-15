CREATE TABLE [dbo].[Outtask_Company_List_SA] (
    [company_id]                     NVARCHAR (8)   NOT NULL,
    [company_name]                   NVARCHAR (255) NULL,
    [address]                        NVARCHAR (255) NULL,
    [city]                           NVARCHAR (255) NULL,
    [state]                          NVARCHAR (255) NULL,
    [zip_code]                       NVARCHAR (255) NULL,
    [salesforce_account_id]          NVARCHAR (255) NULL,
    [entity_id]                      NVARCHAR (255) NULL,
    [salesforce_account_18digitid]   NVARCHAR (255) NULL,
    [CONTRACT_EXTERNAL_REFERENCE_ID] NVARCHAR (255) NULL
);

