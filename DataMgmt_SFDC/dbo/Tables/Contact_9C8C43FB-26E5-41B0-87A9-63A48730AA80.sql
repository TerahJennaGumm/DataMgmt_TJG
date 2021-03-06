﻿CREATE TABLE [dbo].[Contact_9C8C43FB-26E5-41B0-87A9-63A48730AA80] (
    [Id]                                               NCHAR (18)      NOT NULL,
    [Program_Admin__c]                                 NVARCHAR (255)  NULL,
    [pse__Action_Calculate_Utilization__c]             VARCHAR (5)     NULL,
    [pse__Action_Update_Current_Time_Period__c]        VARCHAR (5)     NULL,
    [pse__Allow_Timecards_Without_Assignment__c]       VARCHAR (5)     NULL,
    [pse__Billable_External_Hours__c]                  DECIMAL (18, 2) NULL,
    [pse__Billable_Internal_Hours__c]                  DECIMAL (18, 2) NULL,
    [pse__Billed__c]                                   DECIMAL (18, 2) NULL,
    [pse__Billings__c]                                 DECIMAL (18, 2) NULL,
    [pse__Bookings__c]                                 DECIMAL (18, 2) NULL,
    [pse__Credited_Non_Billable_Internal_Hours__c]     DECIMAL (18, 2) NULL,
    [pse__Current_Time_Period__c]                      NCHAR (18)      NULL,
    [pse__Current_Time_Period_End_Date__c]             DATETIME2 (7)   NULL,
    [pse__Daily_Default_Cost_Rate__c]                  VARCHAR (5)     NULL,
    [pse__Default_Cost_Rate__c]                        DECIMAL (18, 2) NULL,
    [pse__Exclude_From_Missing_Timecards__c]           VARCHAR (5)     NULL,
    [pse__Exclude_from_Resource_Planner__c]            VARCHAR (5)     NULL,
    [pse__Exclude_From_Time_Calculations__c]           VARCHAR (5)     NULL,
    [pse__Excluded_Hours__c]                           DECIMAL (18, 2) NULL,
    [pse__Expense_Budget__c]                           DECIMAL (18, 2) NULL,
    [pse__Expense_Costs__c]                            DECIMAL (18, 2) NULL,
    [pse__External_Costs__c]                           DECIMAL (18, 2) NULL,
    [pse__External_Resource__c]                        VARCHAR (5)     NULL,
    [pse__Group__c]                                    NCHAR (18)      NULL,
    [pse__Historical_Utilization__c]                   DECIMAL (18, 2) NULL,
    [pse__Historical_Utilization_Billable_Hours__c]    DECIMAL (18, 2) NULL,
    [pse__Historical_Utilization_Calendar_Hours__c]    DECIMAL (18, 2) NULL,
    [pse__Historical_Utilization_Target__c]            DECIMAL (18, 2) NULL,
    [pse__Historical_Utilization_Target_Attainment__c] DECIMAL (18, 2) NULL,
    [pse__Historical_Utilization_Target_Hours__c]      DECIMAL (18, 2) NULL,
    [pse__Internal_Budget__c]                          DECIMAL (18, 2) NULL,
    [pse__Internal_Costs__c]                           DECIMAL (18, 2) NULL,
    [pse__Invoiced__c]                                 DECIMAL (18, 2) NULL,
    [pse__Is_Resource__c]                              VARCHAR (5)     NULL,
    [pse__Is_Resource_Active__c]                       VARCHAR (5)     NULL,
    [pse__Last_Date__c]                                DATETIME2 (7)   NULL,
    [pse__Margin__c]                                   DECIMAL (18, 2) NULL,
    [pse__Non_Billable_External_Hours__c]              DECIMAL (18, 2) NULL,
    [pse__Non_Billable_Internal_Hours__c]              DECIMAL (18, 2) NULL,
    [pse__Other_Costs__c]                              DECIMAL (18, 2) NULL,
    [pse__Pass_Through_Billings__c]                    DECIMAL (18, 2) NULL,
    [pse__Practice__c]                                 NCHAR (18)      NULL,
    [pse__Pre_Billed__c]                               DECIMAL (18, 2) NULL,
    [pse__Region__c]                                   NCHAR (18)      NULL,
    [pse__Resource_Role__c]                            NVARCHAR (255)  NULL,
    [pse__Revenue__c]                                  DECIMAL (18, 2) NULL,
    [pse__Salesforce_User__c]                          NCHAR (18)      NULL,
    [pse__Scheduled_Utilization__c]                    DECIMAL (18, 2) NULL,
    [pse__Scheduled_Utilization_Billable_Hours__c]     DECIMAL (18, 2) NULL,
    [pse__Scheduled_Utilization_Calendar_Hours__c]     DECIMAL (18)    NULL,
    [pse__Scheduled_Utilization_Target__c]             DECIMAL (18, 2) NULL,
    [pse__Scheduled_Utilization_Target_Attainment__c]  DECIMAL (18, 2) NULL,
    [pse__Scheduled_Utilization_Target_Hours__c]       DECIMAL (18, 2) NULL,
    [pse__Start_Date__c]                               DATETIME2 (7)   NULL,
    [pse__Total_Costs__c]                              DECIMAL (18, 2) NULL,
    [pse__Total_Time_Period_Hours__c]                  DECIMAL (18, 2) NULL,
    [pse__Total_Utilization__c]                        DECIMAL (18, 2) NULL,
    [pse__Utilization__c]                              DECIMAL (18, 2) NULL,
    [pse__Utilization_Calculation_Date__c]             DATETIME2 (7)   NULL,
    [pse__Utilization_Elapsed_Hours__c]                DECIMAL (18, 2) NULL,
    [pse__Utilization_Full_Time_Period__c]             DECIMAL (18, 2) NULL,
    [pse__Utilization_Target__c]                       DECIMAL (18, 2) NULL,
    [pse__Utilization_Target_Attainment__c]            DECIMAL (18, 2) NULL,
    [pse__Utilization_Target_Average__c]               DECIMAL (18, 2) NULL,
    [pse__Utilization_Target_Hours__c]                 DECIMAL (18, 2) NULL,
    [pse__Work_Calendar__c]                            NCHAR (18)      NULL,
    [qual_level__c]                                    NVARCHAR (255)  NULL,
    [qual_score__c]                                    DECIMAL (18)    NULL,
    [QuickBooks_Certification_Designation__c]          NTEXT           NULL,
    [QuickBooks_ProAdvisor_Member__c]                  VARCHAR (5)     NULL,
    [Re_Engaged_MQL_Counter__c]                        DECIMAL (18)    NULL,
    [Reason_Won_Lost__c]                               NVARCHAR (255)  NULL,
    [RecordTypeId]                                     NCHAR (18)      NULL,
    [Recycle_Trash__c]                                 NVARCHAR (255)  NULL,
    [Reference_Recognized__c]                          VARCHAR (5)     NULL,
    [Referenceable_Contact__c]                         VARCHAR (5)     NULL,
    [Sage_Accountants_Network_Member__c]               VARCHAR (5)     NULL,
    [Sales_Reference_Contact__c]                       VARCHAR (5)     NULL,
    [Scoring_Last_Changed__c]                          DATETIME2 (7)   NULL,
    [Service_Model__c]                                 NVARCHAR (1300) NULL,
    [Source__c]                                        NVARCHAR (20)   NULL,
    [Source_ID__c]                                     NVARCHAR (20)   NULL,
    [Subscribe_to_Service_Alerts__c]                   VARCHAR (5)     NULL,
    [Success_Plan_Contact__c]                          VARCHAR (5)     NULL,
    [Support_Access__c]                                VARCHAR (5)     NULL,
    [SystemModstamp]                                   DATETIME2 (7)   NOT NULL,
    [Tier_Notifications__c]                            VARCHAR (5)     NULL,
    [Title]                                            NVARCHAR (128)  NULL,
    [Travel_on_per_diems__c]                           VARCHAR (5)     NULL,
    [X18_Digit_Contact_ID__c]                          NVARCHAR (1300) NULL,
    [Data_Source__c]                                   NVARCHAR (255)  NULL,
    [CUID__c]                                          NVARCHAR (40)   NULL,
    [Infer_Score_Mirror__c]                            DECIMAL (18)    NULL,
    [Legal_Opt_In__c]                                  VARCHAR (5)     NULL,
    [Marketo_Lead_ID__c]                               NVARCHAR (17)   NULL,
    [Account_Segmentation_String_Text__c]              NVARCHAR (255)  NULL,
    [marketoSyncField__c]                              VARCHAR (5)     NULL,
    [Segment__c]                                       NVARCHAR (1300) NULL,
    [Service_Account_Team__c]                          NCHAR (18)      NULL,
    [ReportstoID]                                      NCHAR (18)      NULL,
    [Resource_type__c]                                 NVARCHAR (255)  NULL,
    [Full_Name__c]                                     NVARCHAR (1300) NULL,
    [Original_Campaign_Name__c]                        NVARCHAR (150)  NULL,
    [Original_Lead_Source__c]                          NVARCHAR (50)   NULL,
    [Most_Recent_Campaign_Name__c]                     NVARCHAR (250)  NULL,
    [Most_Recent_Lead_Source__c]                       NVARCHAR (250)  NULL,
    [MD_Appointment_Date__c]                           DATETIME        NULL,
    CONSTRAINT [pk_Contact_9C8C43FB-26E5-41B0-87A9-63A48730AA80] PRIMARY KEY CLUSTERED ([Id] ASC) WITH (DATA_COMPRESSION = PAGE)
);

