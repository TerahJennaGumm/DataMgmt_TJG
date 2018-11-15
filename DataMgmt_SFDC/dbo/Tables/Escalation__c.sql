﻿CREATE TABLE [dbo].[Escalation__c] (
    [Id]                                   NCHAR (18)      NOT NULL,
    [Account__c]                           NCHAR (18)      NULL,
    [Case__c]                              NCHAR (18)      NULL,
    [Type__c]                              NVARCHAR (255)  NULL,
    [Start_date__c]                        DATETIME        NULL,
    [End_date__c]                          DATETIME        NULL,
    [SystemModstamp]                       DATETIME        NOT NULL,
    [Case_2__c]                            NCHAR (18)      NULL,
    [Case_3__c]                            NCHAR (18)      NULL,
    [Case_4__c]                            NCHAR (18)      NULL,
    [Case_5__c]                            NCHAR (18)      NULL,
    [Case_6__c]                            NCHAR (18)      NULL,
    [Escalation_Origin__c]                 NVARCHAR (255)  NULL,
    [Escalation_Status__c]                 NVARCHAR (255)  NULL,
    [Escalation_Tier__c]                   NVARCHAR (255)  NULL,
    [Primary_Reason_for_Tier_Elevation__c] NVARCHAR (255)  NULL,
    [Resolution_Approach__c]               NVARCHAR (255)  NULL,
    [CreatedById]                          NCHAR (18)      NULL,
    [CreatedDate]                          DATETIME        NOT NULL,
    [Escalation_Age_Days__c]               DECIMAL (18)    NULL,
    [Escalation_Owner__c]                  NCHAR (18)      NULL,
    [Executive_Name__c]                    NCHAR (18)      NULL,
    [LastModifiedById]                     NCHAR (18)      NULL,
    [LastModifiedDate]                     DATETIME        NOT NULL,
    [Name]                                 NVARCHAR (80)   NULL,
    [RecordTypeId]                         NCHAR (18)      NULL,
    [Root_Cause_Comment__c]                NVARCHAR (3000) NULL,
    [Service_Account_Team__c]              NVARCHAR (1300) NULL,
    [Service_Coordinator__c]               NVARCHAR (1300) NULL,
    [Escalation_Subject__c]                NVARCHAR (100)  NULL,
    [Escalation_Reason_2__c]               NVARCHAR (255)  NULL,
    [Escalation_Reason_3__c]               NVARCHAR (255)  NULL,
    [Escalation_Resolution_Category__c]    NVARCHAR (255)  NULL,
    CONSTRAINT [PK_Escalation__c_Id] PRIMARY KEY CLUSTERED ([Id] ASC)
);
