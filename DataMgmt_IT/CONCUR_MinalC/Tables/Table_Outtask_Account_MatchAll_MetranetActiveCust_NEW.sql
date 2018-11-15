﻿CREATE TABLE [CONCUR\MinalC].[Table_Outtask_Account_MatchAll_MetranetActiveCust_NEW] (
    [company_id]                        FLOAT (53)     NULL,
    [company_name]                      NVARCHAR (255) NULL,
    [SFDC_18_digitID]                   VARCHAR (30)   NULL,
    [city]                              NVARCHAR (255) NULL,
    [id]                                NCHAR (18)     NOT NULL,
    [Outtask_Entity_id]                 NVARCHAR (255) NULL,
    [Name]                              NVARCHAR (255) NOT NULL,
    [Entity_ID__c]                      NVARCHAR (45)  NULL,
    [HMC_Entity__c]                     NVARCHAR (80)  NULL,
    [Outtask_ID__c]                     NVARCHAR (8)   NULL,
    [NameMatchValue]                    INT            NULL,
    [Type]                              NVARCHAR (40)  NULL,
    [business_login]                    NVARCHAR (255) NULL,
    [Billing_Country__c]                NVARCHAR (255) NULL,
    [Billing_City__c]                   NVARCHAR (80)  NULL,
    [DunsNumber]                        VARCHAR (9)    NULL,
    [Global_Ultimate_Duns_Number__c]    NVARCHAR (10)  NULL,
    [SAP_Planning_Entity_Account_ID__c] NVARCHAR (55)  NULL,
    [SAP_Account_ID__c]                 NVARCHAR (15)  NULL,
    [Opportunities__c]                  DECIMAL (18)   NULL,
    [Opportunities_Won__c]              DECIMAL (18)   NULL,
    [SAP_Business_Partner_Id__c]        NVARCHAR (10)  NULL,
    [Site]                              NVARCHAR (80)  NULL,
    [Travel_Org_Type__c]                NVARCHAR (255) NULL
);
