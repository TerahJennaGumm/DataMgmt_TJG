﻿CREATE TABLE [dbo].[BigMachines__Quote_Product__c] (
    [Action__c]                            NVARCHAR (255)  NULL,
    [Additional_Sales_Credit__c]           DECIMAL (18, 2) NULL,
    [Adjustment_to_ARR__c]                 DECIMAL (18, 2) NULL,
    [ARR__c]                               DECIMAL (18, 2) NULL,
    [ARR_by_Product__c]                    DECIMAL (18, 2) NULL,
    [Asset_ID__c]                          NVARCHAR (50)   NULL,
    [Base_Fee__c]                          DECIMAL (18, 2) NULL,
    [BigMachines__Description__c]          NVARCHAR (255)  NULL,
    [BigMachines__External_Id__c]          NVARCHAR (255)  NULL,
    [BigMachines__Prep_Delete__c]          VARCHAR (5)     NULL,
    [BigMachines__Product__c]              NCHAR (18)      NULL,
    [BigMachines__Quantity__c]             DECIMAL (18, 2) NULL,
    [BigMachines__Quote__c]                NCHAR (18)      NULL,
    [BigMachines__Sales_Price__c]          DECIMAL (18, 2) NULL,
    [BigMachines__Synchronization_Id__c]   NVARCHAR (255)  NULL,
    [BigMachines__Total_Price__c]          DECIMAL (18, 2) NULL,
    [BMI_Existing_ARR__c]                  DECIMAL (18, 2) NULL,
    [BMI_Net_New_ARR__c]                   DECIMAL (18, 2) NULL,
    [BMI_Sales_ARR__c]                     DECIMAL (18, 2) NULL,
    [BMI_Total_ARR__c]                     DECIMAL (18, 2) NULL,
    [Bundle_ID__c]                         NVARCHAR (35)   NULL,
    [Bundled__c]                           VARCHAR (5)     NULL,
    [Commissions_Product_ARR__c]           DECIMAL (18, 2) NULL,
    [Converted_to_Asset__c]                VARCHAR (5)     NULL,
    [Core_Offering__c]                     NVARCHAR (100)  NULL,
    [CreatedById]                          NCHAR (18)      NULL,
    [CreatedDate]                          DATETIME2 (7)   NOT NULL,
    [CurrencyIsoCode]                      NVARCHAR (3)    NULL,
    [Customer_Currency_Rev_Rec_Monthly__c] DECIMAL (18, 2) NULL,
    [Discount__c]                          DECIMAL (18, 2) NULL,
    [Ext_Net_Price_Non_Unified_USD__c]     DECIMAL (18, 2) NULL,
    [Extended_List_Price_Monthly__c]       DECIMAL (18, 2) NULL,
    [Extended_Net_Price_Monthly__c]        DECIMAL (18, 2) NULL,
    [Id]                                   NCHAR (18)      NOT NULL,
    [Implementation_Method__c]             NVARCHAR (100)  NULL,
    [Incremental_Fee__c]                   DECIMAL (18, 2) NULL,
    [Is_part_of_package__c]                VARCHAR (5)     NULL,
    [IsDeleted]                            VARCHAR (5)     NOT NULL,
    [Item_Type__c]                         NVARCHAR (255)  NULL,
    [LastModifiedById]                     NCHAR (18)      NULL,
    [LastModifiedDate]                     DATETIME2 (7)   NOT NULL,
    [List_Price_Monthly__c]                DECIMAL (18, 2) NULL,
    [Marketing_Name__c]                    NVARCHAR (100)  NULL,
    [MN_PI_ID__c]                          NVARCHAR (30)   NULL,
    [MN_PO_ID__c]                          NVARCHAR (30)   NULL,
    [MN_Subscription_ID__c]                NVARCHAR (30)   NULL,
    [Name]                                 NVARCHAR (80)   NULL,
    [Net_Price_Monthly__c]                 DECIMAL (18, 2) NULL,
    [Num_of_Committed_Transactions__c]     DECIMAL (18)    NULL,
    [Package__c]                           NVARCHAR (30)   NULL,
    [Parent_Doc_ID__c]                     NVARCHAR (25)   NULL,
    [PO_Category__c]                       NVARCHAR (255)  NULL,
    [Pre_Production_Fee__c]                DECIMAL (18, 2) NULL,
    [Promotion_Code_1__c]                  NCHAR (18)      NULL,
    [Promotion_Code_2__c]                  NCHAR (18)      NULL,
    [Promotion_Code_3__c]                  NCHAR (18)      NULL,
    [Promotion_Code_4__c]                  NCHAR (18)      NULL,
    [Promotion_Code_5__c]                  NCHAR (18)      NULL,
    [Promotion_Code__c]                    NVARCHAR (255)  NULL,
    [Quote_Product_PO_ID__c]               NVARCHAR (16)   NULL,
    [Ramp_Plan_Set__c]                     NCHAR (18)      NULL,
    [RecordTypeId]                         NCHAR (18)      NULL,
    [Sales_ARR__c]                         DECIMAL (18, 2) NULL,
    [Service_Acct_ID__c]                   NVARCHAR (100)  NULL,
    [Setup_Fee__c]                         DECIMAL (18, 2) NULL,
    [SystemModstamp]                       DATETIME2 (7)   NOT NULL,
    [Tier_Change__c]                       VARCHAR (5)     NULL,
    [Total_Price_New__c]                   DECIMAL (18, 2) NULL,
    [Unique_Key__c]                        NVARCHAR (1300) NULL,
    CONSTRAINT [PK_BigMachines__Quote_Product__c_Id] PRIMARY KEY NONCLUSTERED ([Id] ASC)
);

