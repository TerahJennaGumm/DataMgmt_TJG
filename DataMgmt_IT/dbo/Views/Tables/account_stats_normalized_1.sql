CREATE TABLE [dbo].[account_stats_normalized] (
    [ProcessDate]                     VARCHAR (23)    NOT NULL,
    [accountId]                       NCHAR (18)      NULL,
    [acct_industry]                   NVARCHAR (2000) NULL,
    [acct_territory]                  NVARCHAR (2000) NULL,
    [annual_revenue]                  NVARCHAR (2000) NULL,
    [buying_horizon]                  NVARCHAR (2000) NULL,
    [contact_title_last_cnw]          NVARCHAR (2000) NULL,
    [current_expense_solution]        NVARCHAR (2000) NULL,
    [current_financial_system]        NVARCHAR (2000) NULL,
    [current_invoice_solution]        NVARCHAR (2000) NULL,
    [current_payroll]                 NVARCHAR (2000) NULL,
    [current_primary_card]            NVARCHAR (2000) NULL,
    [days_since_last_cnw]             NVARCHAR (2000) NULL,
    [expense_volume_month]            NVARCHAR (2000) NULL,
    [invoice_volument_month]          NVARCHAR (2000) NULL,
    [nbr_calls]                       NVARCHAR (2000) NULL,
    [nbr_campaign_contacts]           NVARCHAR (2000) NULL,
    [nbr_cnw_competitive_loss]        NVARCHAR (2000) NULL,
    [nbr_cnw_discovery_demo_stage]    NVARCHAR (2000) NULL,
    [nbr_cnw_lack_of_budget]          NVARCHAR (2000) NULL,
    [nbr_cnw_sql_stage]               NVARCHAR (2000) NULL,
    [nbr_cnw_voc_closing_stage]       NVARCHAR (2000) NULL,
    [nbr_contacts_older_than_6months] NVARCHAR (2000) NULL,
    [nbr_contacts_past_6months]       NVARCHAR (2000) NULL,
    [nbr_emails_rcd]                  NVARCHAR (2000) NULL,
    [nbr_emails_sent]                 NVARCHAR (2000) NULL,
    [nbr_emp_location]                NVARCHAR (2000) NULL,
    [nbr_emp_worldwide]               NVARCHAR (2000) NULL,
    [profile_acct_score]              NVARCHAR (2000) NULL,
    [sum_int_score]                   NVARCHAR (2000) NULL,
    [text_call_notes]                 NVARCHAR (2000) NULL,
    [text_emails]                     NVARCHAR (2000) NULL,
    [text_last_next_step]             NVARCHAR (2000) NULL,
    [total_call_time]                 NVARCHAR (2000) NULL,
    [word_count_call_notes]           NVARCHAR (2000) NULL,
    [word_count_emails_rcd]           NVARCHAR (2000) NULL,
    [word_count_last_next_step]       NVARCHAR (2000) NULL
);


GO
CREATE UNIQUE NONCLUSTERED INDEX [Accountid]
    ON [dbo].[account_stats_normalized]([accountId] ASC);

