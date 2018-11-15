﻿CREATE TABLE [dbo].[t_av_Concur] (
    [id_acc]                         INT            NOT NULL,
    [c_BusinessUnit]                 INT            NOT NULL,
    [c_CompanySize]                  INT            NULL,
    [c_PaymentMethodStartDate]       DATETIME       NULL,
    [c_PaymentMethodEndDate]         DATETIME       NULL,
    [c_CustomerVAT]                  NVARCHAR (100) NULL,
    [c_EntityID]                     NVARCHAR (100) NULL,
    [c_SalesRep]                     NVARCHAR (100) NULL,
    [c_Affiliation]                  NVARCHAR (100) NULL,
    [c_Segment]                      INT            NULL,
    [c_Market]                       INT            NULL,
    [c_RevenueGroup]                 INT            NULL,
    [c_Region]                       INT            NULL,
    [c_AccountChargeFrequency]       INT            NOT NULL,
    [c_SalesChannel]                 INT            NULL,
    [c_PaymentTerms]                 INT            NULL,
    [c_PurchaseOrderNum]             NVARCHAR (255) NULL,
    [c_ForceMonthlyBilling]          CHAR (1)       NULL,
    [c_InitialTermDate]              DATETIME       NULL,
    [c_ReferrerSFAID]                NVARCHAR (20)  NULL,
    [c_ReferralType]                 INT            NULL,
    [c_SpecialTerms]                 CHAR (1)       NULL,
    [c_RecordType]                   INT            NULL,
    [c_ReferringPartner2]            NVARCHAR (100) NULL,
    [c_ReferralType2]                NVARCHAR (100) NULL,
    [c_LegacyEdition]                NVARCHAR (100) NULL,
    [c_ContractSource]               NVARCHAR (100) NULL,
    [c_ImplementationMethod]         NVARCHAR (100) NULL,
    [c_ReferringPartner]             NVARCHAR (100) NULL,
    [c_ReferralDate]                 DATETIME       NULL,
    [c_ReferralSalesRepName]         NVARCHAR (100) NULL,
    [c_PartnerSegment]               NVARCHAR (100) NULL,
    [c_BMILastQuoteID]               NVARCHAR (155) NULL,
    [c_OrderEffectiveDate]           DATETIME       NULL,
    [c_DisableBMIAddons]             CHAR (1)       NULL,
    [c_ReferringPartnerCategory]     NVARCHAR (100) NULL,
    [c_TravelDataCenter]             NVARCHAR (100) NULL,
    [c_TermNumMonths]                INT            NULL,
    [c_FutureAccountFrequency]       INT            NULL,
    [c_FutureAccountFrequencyDate]   DATETIME       NULL,
    [c_SFDCOpportunityID]            NVARCHAR (100) NULL,
    [c_InvoiceAggregationFlag]       CHAR (1)       NULL,
    [c_OrigCompanyName]              NVARCHAR (200) NULL,
    [c_Theater]                      NVARCHAR (255) NULL,
    [c_Comments]                     NVARCHAR (240) NULL,
    [c_CommentEndDate]               DATETIME       NULL,
    [c_AlternatePurchaseOrderNum]    NVARCHAR (255) NULL,
    [c_BMIOrderforAlternatePONumber] NVARCHAR (255) NULL,
    [c_S4BusinessPartnerID]          NVARCHAR (10)  NULL,
    [c_S4ContractAccountID]          NVARCHAR (12)  NULL,
    [c_CompanyDescription]           INT            NULL,
    [c_CompanyCode]                  INT            NULL,
    [c_HoldOrderFlag]                CHAR (1)       NULL,
    [c_BillingExceptionFlag]         CHAR (1)       NULL,
    [c_CorporateSubsidiaryBilling]   INT            NULL
);
