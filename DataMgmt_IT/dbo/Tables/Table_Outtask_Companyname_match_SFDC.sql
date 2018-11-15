CREATE TABLE [dbo].[Table_Outtask_Companyname_match_SFDC] (
    [Name]                    VARCHAR (50) NULL,
    [company_name]            VARCHAR (50) NULL,
    [nm_login_SecBusCust]     VARCHAR (50) NULL,
    [nm_login_PrimaryBusCust] VARCHAR (50) NULL,
    [nm_login]                VARCHAR (50) NULL,
    [Id]                      VARCHAR (50) NULL
);


GO
CREATE NONCLUSTERED INDEX [NonClusteredIndex-20181005-120044]
    ON [dbo].[Table_Outtask_Companyname_match_SFDC]([Name] ASC, [nm_login] ASC, [Id] ASC);

