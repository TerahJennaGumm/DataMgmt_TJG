﻿CREATE TABLE [dbo].[Asset] (
    [AccountId]                                  NCHAR (18)      NULL,
    [Accounting_System__c]                       NVARCHAR (255)  NULL,
    [Accounting_System_Desc__c]                  NVARCHAR (50)   NULL,
    [Accounting_System_Version__c]               NVARCHAR (50)   NULL,
    [Action__c]                                  NVARCHAR (255)  NULL,
    [Adjustment_to_ARR__c]                       DECIMAL (18, 2) NULL,
    [Annual_Cost__c]                             DECIMAL (18, 2) NULL,
    [Annual_Total_Transactions__c]               DECIMAL (18)    NULL,
    [Asset_Begin_Date__c]                        DATETIME2 (7)   NULL,
    [Billing_Cycle__c]                           NVARCHAR (255)  NULL,
    [Billing_ID__c]                              NVARCHAR (45)   NULL,
    [Billing_is_within_ramps__c]                 VARCHAR (5)     NULL,
    [Browser_TYpe__c]                            NTEXT           NULL,
    [Browser_Version__c]                         NVARCHAR (50)   NULL,
    [Bundle_ID__c]                               NVARCHAR (35)   NULL,
    [Bundled__c]                                 VARCHAR (5)     NULL,
    [Client__c]                                  NVARCHAR (255)  NULL,
    [ContactId]                                  NCHAR (18)      NULL,
    [Core_Solution__c]                           NVARCHAR (255)  NULL,
    [CreatedById]                                NCHAR (18)      NULL,
    [CreatedDate]                                DATETIME2 (7)   NOT NULL,
    [CurrencyIsoCode]                            NVARCHAR (3)    NULL,
    [Customer_Currency__c]                       NVARCHAR (255)  NULL,
    [Customer_Currency_Rev_Rec__c]               DECIMAL (18, 2) NULL,
    [Customer_Currency_Rev_Rec_Monthly__c]       DECIMAL (18, 2) NULL,
    [Database_Configuration__c]                  NVARCHAR (255)  NULL,
    [Database_Type__c]                           NVARCHAR (255)  NULL,
    [Database_Version__c]                        NVARCHAR (50)   NULL,
    [Description]                                NTEXT           NULL,
    [Discount__c]                                DECIMAL (18, 2) NULL,
    [DP_of_Vouchers__c]                          DECIMAL (18)    NULL,
    [EP_of_Vouchers__c]                          DECIMAL (18)    NULL,
    [Extended_List_Price_Monthly__c]             DECIMAL (18, 2) NULL,
    [Extended_Net_Price__c]                      DECIMAL (18, 2) NULL,
    [Extended_Tier_Price_Monthly__c]             DECIMAL (18, 2) NULL,
    [Gelco_Asset_Id__c]                          NVARCHAR (20)   NULL,
    [Id]                                         NCHAR (18)      NOT NULL,
    [ID_18_Char__c]                              NVARCHAR (1300) NULL,
    [Implementation_Method__c]                   NVARCHAR (255)  NULL,
    [Initial_Term_Date__c]                       DATETIME2 (7)   NULL,
    [Installation_Type__c]                       NVARCHAR (255)  NULL,
    [InstallDate]                                DATETIME2 (7)   NULL,
    [Internet_of_Vouchers__c]                    DECIMAL (18)    NULL,
    [IsCompetitorProduct]                        VARCHAR (5)     NOT NULL,
    [IsDeleted]                                  VARCHAR (5)     NOT NULL,
    [Item_Type__c]                               NVARCHAR (255)  NULL,
    [Last_Tier_Change__c]                        DATETIME2 (7)   NULL,
    [LastModifiedById]                           NCHAR (18)      NULL,
    [LastModifiedDate]                           DATETIME2 (7)   NOT NULL,
    [Legacy_Product__c]                          NVARCHAR (255)  NULL,
    [List_Price_Monthly__c]                      DECIMAL (18, 2) NULL,
    [Marketing_Name__c]                          NVARCHAR (255)  NULL,
    [Messenging_Agent__c]                        NVARCHAR (255)  NULL,
    [MN_PI_ID__c]                                NVARCHAR (30)   NULL,
    [MN_PO_ID__c]                                NVARCHAR (30)   NULL,
    [MN_Subscription_ID__c]                      NVARCHAR (30)   NULL,
    [MN_Update_ID__c]                            NVARCHAR (40)   NULL,
    [Monthly_Expense_Report_Count__c]            DECIMAL (18)    NULL,
    [Name]                                       NVARCHAR (255)  NOT NULL,
    [Net_Price__c]                               DECIMAL (18, 2) NULL,
    [Next_Bill_Date__c]                          DATETIME2 (7)   NULL,
    [Number_of_Committed_Trnxs__c]               DECIMAL (18)    NULL,
    [Number_of_Committed_Trnxs_Billing_Cycle__c] DECIMAL (18)    NULL,
    [Number_of_Committed_Trnxs_Monthly__c]       DECIMAL (18)    NULL,
    [Online_Booking_Tool__c]                     NVARCHAR (255)  NULL,
    [Online_Booking_Tool_Desc__c]                NVARCHAR (50)   NULL,
    [Operating_System__c]                        NTEXT           NULL,
    [Operating_System_Desc__c]                   NVARCHAR (50)   NULL,
    [Operating_System_Version__c]                NVARCHAR (50)   NULL,
    [Opportunity__c]                             NCHAR (18)      NULL,
    [Opportunity_Product_ID__c]                  NVARCHAR (25)   NULL,
    [Opportunity_Type__c]                        NVARCHAR (255)  NULL,
    [Price]                                      DECIMAL (18)    NULL,
    [Product2Id]                                 NCHAR (18)      NULL,
    [Promo_Code__c]                              NVARCHAR (30)   NULL,
    [Promo_Label__c]                             NVARCHAR (100)  NULL,
    [Purchase_Quote__c]                          NVARCHAR (80)   NULL,
    [PurchaseDate]                               DATETIME2 (7)   NULL,
    [Quantity]                                   DECIMAL (18, 2) NULL,
    [Ramp_Plan_Set__c]                           NCHAR (18)      NULL,
    [SerialNumber]                               NVARCHAR (80)   NULL,
    [Service_Acct_ID__c]                         NVARCHAR (255)  NULL,
    [Solution_Type__c]                           NVARCHAR (255)  NULL,
    [Solution_Version_Service_Pack__c]           NVARCHAR (20)   NULL,
    [Status]                                     NVARCHAR (40)   NULL,
    [SystemModstamp]                             DATETIME2 (7)   NOT NULL,
    [Term_no_of_months__c]                       NVARCHAR (255)  NULL,
    [Tier_Change__c]                             VARCHAR (5)     NULL,
    [Tier_Price__c]                              DECIMAL (18, 2) NULL,
    [Travel_Office__c]                           NVARCHAR (255)  NULL,
    [Travel_Office_Desc__c]                      NVARCHAR (50)   NULL,
    [UsageEndDate]                               DATETIME2 (7)   NULL,
    CONSTRAINT [PK_Asset] PRIMARY KEY CLUSTERED ([Id] ASC)
);


GO
CREATE NONCLUSTERED INDEX [Asset_Oppty_c]
    ON [dbo].[Asset]([Opportunity__c] ASC);

