﻿CREATE TABLE [dbo].[rpt_v_accountcontact] (
    [id_acc]               INT            NOT NULL,
    [c_ContactType]        NVARCHAR (99)  NULL,
    [c_Company]            NVARCHAR (255) NULL,
    [c_FirstName]          NVARCHAR (160) NULL,
    [c_LastName]           NVARCHAR (160) NULL,
    [c_Email]              NVARCHAR (100) NULL,
    [c_PhoneNumber]        NVARCHAR (40)  NULL,
    [c_Address1]           NVARCHAR (100) NULL,
    [c_Address2]           NVARCHAR (100) NULL,
    [c_Address3]           NVARCHAR (100) NULL,
    [c_Address4]           NVARCHAR (100) NULL,
    [c_City]               NVARCHAR (40)  NULL,
    [c_Zip]                NVARCHAR (40)  NULL,
    [c_State]              NVARCHAR (40)  NULL,
    [c_Country]            NVARCHAR (255) NULL,
    [c_CompanyCode]        INT            NULL,
    [c_CompanyDescription] NVARCHAR (255) NULL
);


GO
CREATE NONCLUSTERED INDEX [rpt_v_accountcontact_n1]
    ON [dbo].[rpt_v_accountcontact]([id_acc] ASC)
    INCLUDE([c_ContactType], [c_Company]);

