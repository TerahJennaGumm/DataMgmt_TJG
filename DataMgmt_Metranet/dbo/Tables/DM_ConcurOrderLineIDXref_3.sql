CREATE TABLE [dbo].[DM_ConcurOrderLineIDXref] (
    [ConcurOrderLineID]          NVARCHAR (60)   NOT NULL,
    [ConcurOrderLineIDOldFormat] NVARCHAR (87)   NOT NULL,
    [ConcurOrderLineIDRaw]       NVARCHAR (2000) NULL,
    [DateCreated]                DATETIME        NULL,
    CONSTRAINT [PK_DM_ConcurOrderLineIDXref] PRIMARY KEY CLUSTERED ([ConcurOrderLineID] ASC, [ConcurOrderLineIDOldFormat] ASC)
);

