﻿CREATE TABLE [dbo].[Product2] (
    [BigMachines__Part_Number__c]      NVARCHAR (255)  NULL,
    [CanUseQuantitySchedule]           VARCHAR (5)     NOT NULL,
    [CanUseRevenueSchedule]            VARCHAR (5)     NOT NULL,
    [Create_Projects_Modify__c]        VARCHAR (5)     NULL,
    [CreatedById]                      NCHAR (18)      NULL,
    [CreatedDate]                      DATETIME2 (7)   NOT NULL,
    [CurrencyIsoCode]                  NVARCHAR (3)    NOT NULL,
    [Description]                      NTEXT           NULL,
    [Do_Not_Create_Projects_Create__c] VARCHAR (5)     NULL,
    [Edition__c]                       NVARCHAR (128)  NULL,
    [Family]                           NVARCHAR (40)   NULL,
    [Gelco_Product_Id__c]              NVARCHAR (18)   NULL,
    [Id]                               NCHAR (18)      NOT NULL,
    [IsActive]                         VARCHAR (5)     NOT NULL,
    [IsDeleted]                        VARCHAR (5)     NOT NULL,
    [LastModifiedById]                 NCHAR (18)      NULL,
    [LastModifiedDate]                 DATETIME2 (7)   NOT NULL,
    [Marketing_Name__c]                NVARCHAR (255)  NULL,
    [Name]                             NVARCHAR (255)  NOT NULL,
    [Note__c]                          NTEXT           NULL,
    [NumberOfQuantityInstallments]     INT             NULL,
    [NumberOfRevenueInstallments]      INT             NULL,
    [PI_Item_Type__c]                  NVARCHAR (128)  NULL,
    [PO_Category__c]                   NVARCHAR (128)  NULL,
    [PO_Effective_End_Date__c]         DATETIME2 (7)   NULL,
    [PO_Effective_Start_Date__c]       DATETIME2 (7)   NULL,
    [PO_Name__c]                       NVARCHAR (128)  NULL,
    [Product_Type__c]                  NVARCHAR (255)  NULL,
    [ProductCode]                      NVARCHAR (255)  NULL,
    [pse__IsServicesProduct__c]        VARCHAR (5)     NULL,
    [QuantityInstallmentPeriod]        NVARCHAR (40)   NULL,
    [QuantityScheduleType]             NVARCHAR (40)   NULL,
    [RevenueInstallmentPeriod]         NVARCHAR (40)   NULL,
    [RevenueScheduleType]              NVARCHAR (40)   NULL,
    [SystemModstamp]                   DATETIME2 (7)   NOT NULL,
    [UOM__c]                           NVARCHAR (128)  NULL,
    [UOM_Block__c]                     DECIMAL (18)    NULL,
    [UOM_Type__c]                      NVARCHAR (128)  NULL,
    [Product_Category__c]              NVARCHAR (1300) NULL,
    CONSTRAINT [PK_Product2_Id] PRIMARY KEY CLUSTERED ([Id] ASC)
);

