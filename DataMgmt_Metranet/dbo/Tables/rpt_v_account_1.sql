CREATE TABLE [dbo].[rpt_v_account] (
    [id_acc]                       INT            NOT NULL,
    [nm_login]                     NVARCHAR (255) NOT NULL,
    [nm_space]                     NVARCHAR (40)  NOT NULL,
    [t_account__dt_crt]            DATETIME       NOT NULL,
    [t_acccount_type__name]        VARCHAR (200)  NOT NULL,
    [c_CompanySize]                INT            NULL,
    [c_CustomerVAT]                NVARCHAR (100) NULL,
    [c_EntityID]                   NVARCHAR (100) NULL,
    [c_SalesRep]                   NVARCHAR (100) NULL,
    [c_PurchaseOrderNum]           NVARCHAR (255) NULL,
    [c_ForceMonthlyBilling]        CHAR (1)       NULL,
    [c_ReferrerSFAID]              NVARCHAR (20)  NULL,
    [c_ReferringPartner]           NVARCHAR (100) NULL,
    [c_ReferralDate]               DATETIME       NULL,
    [c_LegacyEdition]              NVARCHAR (100) NULL,
    [c_ContractSource]             NVARCHAR (100) NULL,
    [c_ImplementationMethod]       NVARCHAR (100) NULL,
    [c_BMILastQuoteID]             NVARCHAR (155) NULL,
    [c_OrderEffectiveDate]         DATETIME       NULL,
    [c_DisableBMIAddons]           CHAR (1)       NULL,
    [c_TermNumMonths]              INT            NULL,
    [c_BusinessUnit]               NVARCHAR (255) NULL,
    [c_segment]                    NVARCHAR (255) NULL,
    [c_Market]                     NVARCHAR (255) NULL,
    [c_RevenueGroup]               NVARCHAR (255) NULL,
    [c_Region]                     NVARCHAR (255) NULL,
    [c_AccountChargeFrequency]     NVARCHAR (255) NULL,
    [c_SalesChannel]               NVARCHAR (255) NULL,
    [c_PaymentTerms]               NVARCHAR (255) NULL,
    [c_ReferralType]               NVARCHAR (255) NULL,
    [c_TaxExempt]                  CHAR (1)       NULL,
    [c_TaxExemptID]                NVARCHAR (255) NULL,
    [c_SecurityAnswer]             NVARCHAR (255) NULL,
    [c_StatusReasonOther]          NVARCHAR (255) NULL,
    [c_Currency]                   NVARCHAR (10)  NULL,
    [c_Billable]                   CHAR (1)       NULL,
    [c_TimezoneID]                 NVARCHAR (255) NULL,
    [c_PaymentMethod]              NVARCHAR (255) NULL,
    [c_SecurityQuestion]           NVARCHAR (255) NULL,
    [c_InvoiceMethod]              NVARCHAR (255) NULL,
    [c_UsageCycleType]             NVARCHAR (255) NULL,
    [c_Language]                   NVARCHAR (255) NULL,
    [c_StatusReason]               NVARCHAR (255) NULL,
    [t_account_state__status]      CHAR (2)       NOT NULL,
    [t_account_state__vt_start]    DATETIME       NOT NULL,
    [c_CBTravelConfigID]           NVARCHAR (255) NULL,
    [c_CBSFAID]                    NVARCHAR (255) NULL,
    [c_CBCompanyID]                NVARCHAR (255) NULL,
    [c_CBMasterAcct]               CHAR (1)       NULL,
    [c_CBAgencyID]                 NVARCHAR (255) NULL,
    [c_FutureAccountFrequency]     INT            NULL,
    [c_FutureAccountFrequencyDate] DATETIME       NULL,
    [c_S4BusinessPartnerID]        NVARCHAR (10)  NULL,
    [c_S4ContractAccountID]        NVARCHAR (12)  NULL,
    CONSTRAINT [rpt_v_account_pk] PRIMARY KEY CLUSTERED ([id_acc] ASC)
);


GO
CREATE NONCLUSTERED INDEX [rpt_v_account_n2]
    ON [dbo].[rpt_v_account]([nm_login] ASC);


GO
CREATE NONCLUSTERED INDEX [idx_Missing_IXNC_rpt_v_account_t_acccount_type__name_A089C]
    ON [dbo].[rpt_v_account]([t_acccount_type__name] ASC)
    INCLUDE([id_acc], [nm_login], [c_Currency]);


GO
CREATE NONCLUSTERED INDEX [rpt_v_account_n1]
    ON [dbo].[rpt_v_account]([t_acccount_type__name] ASC)
    INCLUDE([nm_login]);

