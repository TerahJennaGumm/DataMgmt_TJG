﻿CREATE TABLE [dbo].[Competitor__c] (
    [Comments__c]                     NVARCHAR (255)  NULL,
    [Competitive_Strategy__c]         NVARCHAR (255)  NULL,
    [Competitor_Internal_Project__c]  NVARCHAR (255)  NULL,
    [Competitor_Status__c]            NVARCHAR (255)  NULL,
    [CreatedById]                     NCHAR (18)      NULL,
    [CreatedDate]                     DATETIME2 (7)   NOT NULL,
    [CurrencyIsoCode]                 NVARCHAR (3)    NULL,
    [font_color_red_b_NOTE_b_red__c]  NVARCHAR (1300) NULL,
    [Id]                              NCHAR (18)      NOT NULL,
    [IndexNumber__c]                  NVARCHAR (12)   NULL,
    [INSTRUCTIONS__c]                 NVARCHAR (300)  NULL,
    [IsDeleted]                       VARCHAR (5)     NOT NULL,
    [LastModifiedById]                NCHAR (18)      NULL,
    [LastModifiedDate]                DATETIME2 (7)   NOT NULL,
    [Name]                            NVARCHAR (80)   NULL,
    [Opportunity__c]                  NCHAR (18)      NULL,
    [RelatedStandardCompetitorId__c]  NVARCHAR (18)   NULL,
    [SystemModstamp]                  DATETIME2 (7)   NOT NULL,
    [Type__c]                         NVARCHAR (255)  NULL,
    [Why_will_the_competition_win__c] NVARCHAR (255)  NULL,
    [Primary__c]                      VARCHAR (5)     NULL,
    [Competitor_Category__c]          NVARCHAR (1300) NULL,
    [Competitor_Name__c]              NCHAR (18)      NULL,
    CONSTRAINT [PK_Competitor__c_Id] PRIMARY KEY CLUSTERED ([Id] ASC)
);
