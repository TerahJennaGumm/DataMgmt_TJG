CREATE TABLE [dbo].[OuttaskMatching_contract_external_reference] (
    [uuid]                           VARCHAR (50) NULL,
    [internet_domain]                VARCHAR (50) NULL,
    [entity_id]                      VARCHAR (50) NULL,
    [contract_external_reference_id] VARCHAR (50) NULL,
    [concur_guid]                    VARCHAR (50) NULL,
    [company_name]                   VARCHAR (50) NULL,
    [travel_config_id]               VARCHAR (50) NULL,
    [company_id]                     VARCHAR (50) NULL,
    [is_billable]                    VARCHAR (50) NULL,
    [nm_login]                       VARCHAR (50) NULL,
    [Service_id_acc]                 VARCHAR (50) NULL,
    [t_acccount_type__name]          VARCHAR (50) NULL,
    [c_CBTravelConfigID]             VARCHAR (50) NULL,
    [c_CBSFAID]                      VARCHAR (50) NULL,
    [c_CBCompanyID]                  VARCHAR (50) NULL,
    [c_CBMasterAcct]                 VARCHAR (50) NULL,
    [c_CBAgencyID]                   VARCHAR (50) NULL,
    [root_acct_type]                 VARCHAR (50) NULL,
    [num_generations]                VARCHAR (50) NULL,
    [root_id_acc]                    VARCHAR (50) NULL,
    [business_id_acc]                VARCHAR (50) NULL,
    [secondary_business_id_acc]      VARCHAR (50) NULL,
    [billing_id_acc]                 VARCHAR (50) NULL,
    [nm_login_PrimaryBusCust]        VARCHAR (50) NULL,
    [nm_login_SecBusCust]            VARCHAR (50) NULL
);


GO
CREATE NONCLUSTERED INDEX [nm_login_companyname]
    ON [dbo].[OuttaskMatching_contract_external_reference]([nm_login] ASC)
    INCLUDE([company_name]);


GO
CREATE NONCLUSTERED INDEX [NonClusteredIndex-20181004-141217]
    ON [dbo].[OuttaskMatching_contract_external_reference]([company_id] ASC)
    INCLUDE([entity_id], [contract_external_reference_id], [travel_config_id], [nm_login], [Service_id_acc]);

