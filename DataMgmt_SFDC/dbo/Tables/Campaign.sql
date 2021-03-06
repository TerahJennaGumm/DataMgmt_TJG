﻿CREATE TABLE [dbo].[Campaign] (
    [ActualCost]                 DECIMAL (18)    NULL,
    [AmountAllOpportunities]     DECIMAL (18)    NOT NULL,
    [AmountWonOpportunities]     DECIMAL (18)    NOT NULL,
    [BudgetedCost]               DECIMAL (18)    NULL,
    [Call_to_Action_Type__c]     NVARCHAR (255)  NULL,
    [Campaign_BU__c]             NVARCHAR (255)  NULL,
    [Campaign_Channel__c]        NVARCHAR (255)  NULL,
    [Campaign_Code__c]           NVARCHAR (25)   NULL,
    [Campaign_ID_18__c]          NVARCHAR (1300) NULL,
    [Campaign_ID__c]             NVARCHAR (1300) NULL,
    [Campaign_Region__c]         NVARCHAR (255)  NULL,
    [CampaignMemberRecordTypeId] NCHAR (18)      NULL,
    [ConcurParent__c]            NCHAR (18)      NULL,
    [Cost_per_response__c]       DECIMAL (18)    NULL,
    [CreatedById]                NCHAR (18)      NULL,
    [CreatedDate]                DATETIME2 (7)   NOT NULL,
    [CurrencyIsoCode]            NVARCHAR (3)    NOT NULL,
    [Default_PID__c]             NVARCHAR (255)  NULL,
    [Description]                NTEXT           NULL,
    [EndDate]                    DATETIME2 (7)   NULL,
    [Event_Rating__c]            DECIMAL (18, 1) NULL,
    [ExpectedResponse]           DECIMAL (18, 2) NULL,
    [ExpectedRevenue]            DECIMAL (18)    NULL,
    [Id]                         NCHAR (18)      NOT NULL,
    [IsActive]                   VARCHAR (5)     NOT NULL,
    [IsDeleted]                  VARCHAR (5)     NOT NULL,
    [Kapost_Content_ID__c]       DECIMAL (18)    NULL,
    [LastActivityDate]           DATETIME2 (7)   NULL,
    [LastModifiedById]           NCHAR (18)      NULL,
    [LastModifiedDate]           DATETIME2 (7)   NOT NULL,
    [LastReferencedDate]         DATETIME2 (7)   NULL,
    [LastViewedDate]             DATETIME2 (7)   NULL,
    [Lead_Source__c]             NVARCHAR (255)  NULL,
    [Location__c]                NVARCHAR (255)  NULL,
    [Marketing_Closet__c]        NVARCHAR (255)  NULL,
    [Name]                       NVARCHAR (80)   NOT NULL,
    [NumberOfContacts]           INT             NOT NULL,
    [NumberOfConvertedLeads]     INT             NOT NULL,
    [NumberOfLeads]              INT             NOT NULL,
    [NumberOfOpportunities]      INT             NOT NULL,
    [NumberOfResponses]          INT             NOT NULL,
    [NumberOfWonOpportunities]   INT             NOT NULL,
    [NumberSent]                 DECIMAL (18)    NULL,
    [OwnerId]                    NCHAR (18)      NOT NULL,
    [ParentId]                   NCHAR (18)      NULL,
    [StartDate]                  DATETIME2 (7)   NULL,
    [Status]                     NVARCHAR (40)   NULL,
    [SystemModstamp]             DATETIME2 (7)   NOT NULL,
    [Type]                       NVARCHAR (40)   NULL,
    CONSTRAINT [PK_Campaign_Id] PRIMARY KEY NONCLUSTERED ([Id] ASC)
);

