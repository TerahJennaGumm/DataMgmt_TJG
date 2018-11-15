CREATE TABLE [dbo].[Conversations_SAPConcur_2Year] (
    [LeadTransitId]     FLOAT (53)     NULL,
    [Conversation Date] DATETIME       NULL,
    [User]              NVARCHAR (255) NULL,
    [TeamName]          NVARCHAR (255) NULL,
    [List Name]         NVARCHAR (255) NULL,
    [Category]          NVARCHAR (255) NULL,
    [First Name]        NVARCHAR (255) NULL,
    [Last Name]         NVARCHAR (255) NULL,
    [Company Name]      NVARCHAR (255) NULL,
    [Title]             NVARCHAR (255) NULL,
    [Email]             NVARCHAR (255) NULL,
    [Country]           NVARCHAR (255) NULL,
    [CrmUrl]            NVARCHAR (255) NULL,
    [CrmId]             NVARCHAR (255) NULL,
    [Priority]          NVARCHAR (255) NULL,
    [Disposition]       NVARCHAR (255) NULL,
    [Status]            NVARCHAR (255) NULL,
    [Next Call]         NVARCHAR (255) NULL,
    [Talk Time]         FLOAT (53)     NULL,
    [Wrap Time]         FLOAT (53)     NULL,
    [Session Type]      NVARCHAR (255) NULL,
    [Talk Time (Call)]  FLOAT (53)     NULL
);


GO
CREATE CLUSTERED INDEX [ClusteredIndex-20180427-150958]
    ON [dbo].[Conversations_SAPConcur_2Year]([CrmId] ASC);

