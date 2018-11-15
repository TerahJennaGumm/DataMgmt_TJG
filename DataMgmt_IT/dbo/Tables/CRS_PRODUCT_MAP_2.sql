CREATE TABLE [dbo].[CRS_PRODUCT_MAP] (
    [ID]                INT           IDENTITY (1, 1) NOT NULL,
    [MN_ID]             VARCHAR (255) NULL,
    [MN_PI_NAME]        VARCHAR (255) NULL,
    [MN_ITEM_TYPE]      VARCHAR (255) NULL,
    [MN_PO]             VARCHAR (255) NULL,
    [MN_PO_NAME]        VARCHAR (255) NULL,
    [MN_NAME]           VARCHAR (255) NULL,
    [MN_SUB]            DATETIME      NULL,
    [MN_BILL]           DATETIME      NULL,
    [MN_CREATED]        DATETIME      NULL,
    [SF_ID]             VARCHAR (255) NULL,
    [SF_NAME]           VARCHAR (255) NULL,
    [SF_MARKETING_NAME] VARCHAR (255) NULL,
    [STATUS]            VARCHAR (255) NULL,
    [GOV_CLIN]          VARCHAR (255) NULL,
    [GOV_NAME]          VARCHAR (255) NULL,
    [GOV_PERIOD]        VARCHAR (255) NULL,
    [GOV_PERIOD_START]  DATETIME      NULL,
    [GOV_PERIOD_END]    DATETIME      NULL
);

