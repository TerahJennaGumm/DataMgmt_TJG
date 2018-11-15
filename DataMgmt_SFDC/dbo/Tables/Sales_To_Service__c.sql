﻿CREATE TABLE [dbo].[Sales_To_Service__c] (
    [Account__c]                                  NVARCHAR (1300) NULL,
    [Account_Email_Template__c]                   NVARCHAR (1300) NULL,
    [Address__c]                                  NVARCHAR (1300) NULL,
    [Address_Line_1__c]                           NVARCHAR (1300) NULL,
    [Adv_Serv_to_implement_before_core_serv__c]   NVARCHAR (1000) NULL,
    [Anticipated_Travel_Launch__c]                NVARCHAR (255)  NULL,
    [AP_organization_uses__c]                     NVARCHAR (255)  NULL,
    [Associated_with_roll_out_of_new_country__c]  NVARCHAR (255)  NULL,
    [Aware_of_client_purchasing_Partner_App__c]   NVARCHAR (255)  NULL,
    [Bank_and_Card_Type__c]                       NVARCHAR (255)  NULL,
    [Billing_Manager__c]                          NCHAR (18)      NULL,
    [Billing_Manager_E_mail__c]                   NVARCHAR (80)   NULL,
    [Billing_Manager_First_Last_Name__c]          NVARCHAR (50)   NULL,
    [Billing_Manager_Phone__c]                    NVARCHAR (40)   NULL,
    [Card_Program__c]                             NVARCHAR (255)  NULL,
    [Card_Region__c]                              NVARCHAR (255)  NULL,
    [City__c]                                     NVARCHAR (50)   NULL,
    [Client_Current_Payroll_System__c]            NVARCHAR (255)  NULL,
    [Client_has_acquired_VAT_Reclaim_Service__c]  NVARCHAR (255)  NULL,
    [Client_impl_any_other_Concur_services__c]    NVARCHAR (255)  NULL,
    [Client_Pay_IB_CP_Card_Via_Concur_Expense__c] NVARCHAR (255)  NULL,
    [Client_Project_Lead__c]                      NCHAR (18)      NULL,
    [Client_Project_Lead_E_mail__c]               NVARCHAR (80)   NULL,
    [Client_Project_Lead_Email__c]                NVARCHAR (1300) NULL,
    [Client_Project_Lead_First_Name__c]           NVARCHAR (50)   NULL,
    [Client_Project_Lead_Last_Name__c]            NVARCHAR (50)   NULL,
    [Client_Project_Lead_Phone__c]                NVARCHAR (40)   NULL,
    [Client_requests_Auth_Request_config_only__c] NVARCHAR (255)  NULL,
    [Client_s_corporate_credit_card_s__c]         NVARCHAR (100)  NULL,
    [Client_s_current_expense_system__c]          NVARCHAR (125)  NULL,
    [Client_s_current_financial_s_ERP_Account__c] NVARCHAR (1300) NULL,
    [Client_s_current_financial_system_ERP__c]    NVARCHAR (255)  NULL,
    [Client_s_desired_project_start_date__c]      NVARCHAR (250)  NULL,
    [Client_s_TMC_Contact_E_mail__c]              NVARCHAR (80)   NULL,
    [Client_s_TMC_Contact_First_Last_Name__c]     NVARCHAR (50)   NULL,
    [Client_s_TMC_Contact_Phone__c]               NVARCHAR (40)   NULL,
    [Client_TMC_Contact__c]                       NCHAR (18)      NULL,
    [Clients_core_project_teams_location__c]      NVARCHAR (255)  NULL,
    [Clients_Current_Payroll_System_Account__c]   NVARCHAR (1300) NULL,
    [Clients_desired_live_date__c]                DATETIME2 (7)   NULL,
    [Clients_project_team_time_zone_location__c]  NVARCHAR (255)  NULL,
    [ConcurPaymentSchedule_Process_discussed__c]  NVARCHAR (255)  NULL,
    [Connector__c]                                NVARCHAR (255)  NULL,
    [Connector_Plus__c]                           NVARCHAR (255)  NULL,
    [Consult_Session_Site_Review_to_focus_on__c]  NVARCHAR (255)  NULL,
    [Conversion__c]                               NVARCHAR (255)  NULL,
    [Converting_from__c]                          NVARCHAR (255)  NULL,
    [Countries_included_in_SOF__c]                NVARCHAR (255)  NULL,
    [Country_ies_included_in_SOF__c]              NTEXT           NULL,
    [CreatedById]                                 NCHAR (18)      NULL,
    [CreatedDate]                                 DATETIME2 (7)   NOT NULL,
    [CurrencyIsoCode]                             NVARCHAR (3)    NULL,
    [Cust_ERP_HR_system_interfacing_from__c]      NVARCHAR (250)  NULL,
    [Cust_has_scanning_facilities_for_CIC__c]     NVARCHAR (255)  NULL,
    [Customer__c]                                 NVARCHAR (1300) NULL,
    [Customer_introduced_to_OB10__c]              NVARCHAR (255)  NULL,
    [Customer_will_utilize_IntelligentCapture__c] NVARCHAR (255)  NULL,
    [Data_Center__c]                              NVARCHAR (255)  NULL,
    [Date_Feed_Needed__c]                         DATETIME2 (7)   NULL,
    [Describe_what_client_is_trying_to_do__c]     NTEXT           NULL,
    [Detail__c]                                   NTEXT           NULL,
    [Did_client_purchase_Invoice_Capture__c]      NVARCHAR (255)  NULL,
    [Discussed_time_to_certify_corp_card__c]      NVARCHAR (255)  NULL,
    [Does_the_customer_use_project_accounting__c] NVARCHAR (255)  NULL,
    [EMEA_Deployment_Method__c]                   NVARCHAR (255)  NULL,
    [Engaged_Solution_Consultant_to_add_card__c]  NVARCHAR (255)  NULL,
    [Entity_ID__c]                                NVARCHAR (1300) NULL,
    [Entity_ID_old__c]                            NVARCHAR (12)   NULL,
    [ERP_HR_sys_integrating_into_from__c]         NVARCHAR (250)  NULL,
    [Executive_Sponsor__c]                        NCHAR (18)      NULL,
    [Executive_Sponsor_E_mail__c]                 NVARCHAR (80)   NULL,
    [Executive_Sponsor_First_Last_Name__c]        NVARCHAR (50)   NULL,
    [Executive_Sponsor_Phone__c]                  NVARCHAR (40)   NULL,
    [Expected_launch_date__c]                     DATETIME2 (7)   NULL,
    [Expense_Invoice_impl_by_same_team__c]        NVARCHAR (255)  NULL,
    [Expense_to_be_implemented_first__c]          NVARCHAR (255)  NULL,
    [ExpenseLink__c]                              VARCHAR (5)     NULL,
    [Fulfillment__c]                              NVARCHAR (255)  NULL,
    [Gov_t_agency_contractor_or_Education__c]     NVARCHAR (255)  NULL,
    [Great_Plains__c]                             VARCHAR (5)     NULL,
    [Has_the_customer_signed_an_agreement_wit__c] NVARCHAR (255)  NULL,
    [How_many_autonomous_business_units_are_t__c] NVARCHAR (255)  NULL,
    [Id]                                          NCHAR (18)      NOT NULL,
    [If_Concurforce_type_of_deal__c]              NVARCHAR (255)  NULL,
    [If_On_Premise_version_used__c]               NVARCHAR (50)   NULL,
    [If_TMC_is_selected_above_please_indicat__c]  NVARCHAR (255)  NULL,
    [If_you_selected_other_above_list_TMC__c]     NVARCHAR (255)  NULL,
    [Includes_Central_Bill_Accounts__c]           NVARCHAR (255)  NULL,
    [IsDeleted]                                   VARCHAR (5)     NOT NULL,
    [Issuing_Bank__c]                             NVARCHAR (255)  NULL,
    [Issuing_Bank_Other__c]                       NVARCHAR (150)  NULL,
    [Language_requirements__c]                    NVARCHAR (255)  NULL,
    [LastActivityDate]                            DATETIME2 (7)   NULL,
    [LastModifiedById]                            NCHAR (18)      NULL,
    [LastModifiedDate]                            DATETIME2 (7)   NOT NULL,
    [List_client_s_reimbursement_currencies__c]   NVARCHAR (255)  NULL,
    [List_Impl_Advantage_manager_you_worked__c]   NVARCHAR (255)  NULL,
    [List_impl_order_for_new_services__c]         NVARCHAR (250)  NULL,
    [List_the_Domestic_VAT_countries_to_setup__c] NVARCHAR (255)  NULL,
    [List_Travel_Allowance_countries_in_SOF__c]   NVARCHAR (255)  NULL,
    [Manager_E_mail__c]                           NVARCHAR (1300) NULL,
    [Manager_First_Last_Name__c]                  NVARCHAR (1300) NULL,
    [Manager_Phone__c]                            NVARCHAR (1300) NULL,
    [Name]                                        NVARCHAR (80)   NULL,
    [NASD__c]                                     NVARCHAR (255)  NULL,
    [Navision__c]                                 VARCHAR (5)     NULL,
    [New_Concurforce_Client__c]                   NVARCHAR (255)  NULL,
    [Notes_Please_include_discovery_notes__c]     NTEXT           NULL,
    [Opportunity__c]                              NCHAR (18)      NULL,
    [Other__c]                                    VARCHAR (5)     NULL,
    [Other_ERP_or_HR_System__c]                   NVARCHAR (255)  NULL,
    [Payment_Type_Name__c]                        NVARCHAR (255)  NULL,
    [Postal_Code__c]                              NVARCHAR (15)   NULL,
    [Pre_Sales_Rep_E_mail__c]                     NVARCHAR (1300) NULL,
    [Pre_Sales_Rep_First_Last_Name__c]            NCHAR (18)      NULL,
    [Primary_ERP__c]                              NVARCHAR (255)  NULL,
    [Primary_HR_System__c]                        NVARCHAR (255)  NULL,
    [Primary_Quote__c]                            NCHAR (18)      NULL,
    [Pro_Conversion__c]                           VARCHAR (5)     NULL,
    [Program_Type__c]                             NVARCHAR (255)  NULL,
    [Purchased_WebService_Connector_Extract__c]   NVARCHAR (255)  NULL,
    [QuickBooks__c]                               VARCHAR (5)     NULL,
    [Record_Type_Group__c]                        NVARCHAR (1300) NULL,
    [RecordTypeId]                                NCHAR (18)      NULL,
    [Remit_payment_to_client_card_provider__c]    NVARCHAR (255)  NULL,
    [RSE_Client_Dev_First_Last_Name__c]           NCHAR (18)      NULL,
    [RSE_E_mail__c]                               NVARCHAR (1300) NULL,
    [RSE_First_Last_Name_2__c]                    NVARCHAR (1300) NULL,
    [RSE_First_Last_Name_WF__c]                   NVARCHAR (50)   NULL,
    [RSE_Phone__c]                                NVARCHAR (1300) NULL,
    [RSE_Region1__c]                              NVARCHAR (1300) NULL,
    [RSE_Region__c]                               NVARCHAR (255)  NULL,
    [RSE_Segment__c]                              NVARCHAR (1300) NULL,
    [Select_the_best_option_for_Audit__c]         NVARCHAR (255)  NULL,
    [Service_Descrip__c]                          NVARCHAR (255)  NULL,
    [Services_in_impl_est_prod_date__c]           NVARCHAR (255)  NULL,
    [Services_to_be_impl_country_rolled_out__c]   NVARCHAR (255)  NULL,
    [State_Province__c]                           NVARCHAR (50)   NULL,
    [Support_for_SEPA_B2B_Direct_Debit_Scheme__c] NVARCHAR (255)  NULL,
    [SystemModstamp]                              DATETIME2 (7)   NOT NULL,
    [Target_Countries_Additional_Identifie__c]    NVARCHAR (60)   NULL,
    [Tier_increase_realted_to_this_project__c]    NVARCHAR (255)  NULL,
    [TMC__c]                                      NVARCHAR (255)  NULL,
    [Total_no_of_employees_in_company__c]         DECIMAL (18)    NULL,
    [Travel_countries_client_to_roll_out__c]      NTEXT           NULL,
    [Travel_countries_cust_plans_to_roll_out__c]  NVARCHAR (255)  NULL,
    [Travel_Manager__c]                           NCHAR (18)      NULL,
    [Travel_Manager_E_mail__c]                    NVARCHAR (80)   NULL,
    [Travel_Manager_First_Last_Name__c]           NVARCHAR (50)   NULL,
    [Travel_Manager_Phone__c]                     NVARCHAR (40)   NULL,
    [Type_of_Card__c]                             NVARCHAR (255)  NULL,
    [Type_of_Concurforce_Deal__c]                 NVARCHAR (255)  NULL,
    [Type_of_Corporate_Card__c]                   NTEXT           NULL,
    [Using_Cliqbook_through_Concur_or_a_TMC__c]   NVARCHAR (255)  NULL,
    [VAT_Compliance_Brochure_Sent__c]             NVARCHAR (255)  NULL,
    [VAT_Compliance_Required__c]                  NVARCHAR (255)  NULL,
    [Verfied_support_for_client_s_corp_card__c]   NVARCHAR (255)  NULL,
    [Was_the_standard_scope_reviewed_during_t__c] NVARCHAR (255)  NULL,
    [Which_standard_workflow_was_selected__c]     NVARCHAR (255)  NULL,
    [Will_any_services_require_on_site_visits__c] NVARCHAR (255)  NULL,
    [Will_new_Countries_include_Cliqbook__c]      NVARCHAR (255)  NULL,
    [You_need_not_enter_data_for_Tier_Changes__c] NVARCHAR (255)  NULL,
    CONSTRAINT [PK_Sales_To_Service__c_Id] PRIMARY KEY CLUSTERED ([Id] ASC)
);

