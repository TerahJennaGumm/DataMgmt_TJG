CREATE TABLE [dbo].[CampaignMember] (
    [Account_Business_Unit__c]       NVARCHAR (1300) NULL,
    [Account_ID__c]                  NVARCHAR (1300) NULL,
    [Account_Type__c]                NVARCHAR (1300) NULL,
    [Acct_Owner_Division__c]         NVARCHAR (1300) NULL,
    [Acct_Owner_Market__c]           NVARCHAR (1300) NULL,
    [Acct_Owner_Region__c]           NVARCHAR (1300) NULL,
    [Acct_Owner_Team__c]             NVARCHAR (1300) NULL,
    [Assigned_Account_MDR__c]        NVARCHAR (1300) NULL,
    [Campaign_Time_Stamp__c]         DATETIME2 (7)   NULL,
    [CampaignId]                     NCHAR (18)      NOT NULL,
    [Client_Executive__c]            NVARCHAR (1300) NULL,
    [ContactId]                      NCHAR (18)      NULL,
    [Created_By__c]                  NVARCHAR (1300) NULL,
    [CreatedById]                    NCHAR (18)      NULL,
    [CreatedDate]                    DATETIME2 (7)   NOT NULL,
    [CurrencyIsoCode]                NVARCHAR (3)    NULL,
    [ExternalID__c]                  NVARCHAR (20)   NULL,
    [FirstRespondedDate]             DATETIME2 (7)   NULL,
    [HasResponded]                   VARCHAR (5)     NOT NULL,
    [Id]                             NCHAR (18)      NOT NULL,
    [Is_My_Account_2nd_Acc_Owner__c] VARCHAR (5)     NULL,
    [Is_My_Account_Acc_MDR__c]       VARCHAR (5)     NULL,
    [Is_My_Account_Acc_Owner__c]     VARCHAR (5)     NULL,
    [IsDeleted]                      VARCHAR (5)     NOT NULL,
    [Last_Modified_By__c]            NVARCHAR (1300) NULL,
    [LastModifiedById]               NCHAR (18)      NULL,
    [LastModifiedDate]               DATETIME2 (7)   NOT NULL,
    [LeadId]                         NCHAR (18)      NULL,
    [Localized_Site_Region__c]       NVARCHAR (10)   NULL,
    [Most_Recent_Advertising_CID__c] NVARCHAR (100)  NULL,
    [Most_Recent_Lead_Source_PID__c] NVARCHAR (100)  NULL,
    [Name]                           NVARCHAR (255)  NULL,
    [Status]                         NVARCHAR (40)   NULL,
    [SystemModstamp]                 DATETIME2 (7)   NOT NULL,
    CONSTRAINT [PK_CampaignMember_Id] PRIMARY KEY NONCLUSTERED ([Id] ASC)
);


GO
CREATE NONCLUSTERED INDEX [CampaignMember_COntactId]
    ON [dbo].[CampaignMember]([ContactId] ASC)
    INCLUDE([CampaignId]);

