﻿CREATE TABLE [dbo].[Contact] (
    [Account_Manager__c]                               NVARCHAR (1300) NULL,
    [Account_Owner__c]                                 NVARCHAR (150)  NULL,
    [Account_Type__c]                                  NVARCHAR (1300) NULL,
    [AccountId]                                        NCHAR (18)      NULL,
    [Active_Concur_Star__c]                            VARCHAR (5)     NULL,
    [Activities_Since_Most_Recent_MQL__c]              DECIMAL (18)    NULL,
    [Analyst_Reference_Contact__c]                     VARCHAR (5)     NULL,
    [Are_you_a_Ceridian_customer__c]                   VARCHAR (5)     NULL,
    [Assigned_Account_MDR__c]                          NVARCHAR (1300) NULL,
    [AssistantName]                                    NVARCHAR (40)   NULL,
    [AssistantPhone]                                   NVARCHAR (40)   NULL,
    [Billing_City__c]                                  NVARCHAR (80)   NULL,
    [Billing_Country__c]                               NVARCHAR (255)  NULL,
    [Billing_St__c]                                    NVARCHAR (140)  NULL,
    [Billing_St_Line_2__c]                             NVARCHAR (140)  NULL,
    [Billing_State_Province__c]                        NVARCHAR (80)   NULL,
    [Billing_Zip_Postal__c]                            NVARCHAR (20)   NULL,
    [Breeze_CID__c]                                    NVARCHAR (100)  NULL,
    [Breeze_Last_CID__c]                               NVARCHAR (100)  NULL,
    [Breeze_Last_Lead_Source__c]                       NVARCHAR (100)  NULL,
    [Breeze_Lead_Source__c]                            NVARCHAR (100)  NULL,
    [Buying_Role__c]                                   NVARCHAR (255)  NULL,
    [Case_Study_Available__c]                          VARCHAR (5)     NULL,
    [Case_Study_Willing__c]                            VARCHAR (5)     NULL,
    [Certified__c]                                     NVARCHAR (255)  NULL,
    [CleanStatus]                                      NVARCHAR (40)   NULL,
    [Closed_Case_Survey_Opt_In__c]                     VARCHAR (5)     NULL,
    [Closed_Explanation__c]                            NVARCHAR (255)  NULL,
    [Closed_Not_Won_Reason__c]                         NVARCHAR (255)  NULL,
    [Cold_Call_Target__c]                              VARCHAR (5)     NULL,
    [Company__c]                                       NVARCHAR (1300) NULL,
    [Competitive_Loss_Explanation__c]                  NVARCHAR (255)  NULL,
    [Contact_Filter__c]                                NVARCHAR (100)  NULL,
    [Contact_Status__c]                                NVARCHAR (255)  NULL,
    [Contact_Title__c]                                 NVARCHAR (255)  NULL,
    [Corp_NPS_Completed__c]                            DECIMAL (18)    NULL,
    [Count_Contacts__c]                                DECIMAL (18)    NULL,
    [Created_by_Role__c]                               NVARCHAR (1300) NULL,
    [CreatedById]                                      NCHAR (18)      NULL,
    [CreatedDate]                                      DATETIME2 (7)   NOT NULL,
    [CRM__c]                                           NVARCHAR (1300) NULL,
    [Date_Stamp_Closed_Not_Won__c]                     DATETIME2 (7)   NULL,
    [Date_Stamp_Closed_Won__c]                         DATETIME2 (7)   NULL,
    [Date_Stamp_Closing__c]                            DATETIME2 (7)   NULL,
    [Date_Stamp_Demo_Proposal__c]                      DATETIME2 (7)   NULL,
    [Date_Stamp_Discovery__c]                          DATETIME2 (7)   NULL,
    [Date_Stamp_Inquiry__c]                            DATETIME2 (7)   NULL,
    [Date_Stamp_MDR_Working__c]                        DATETIME2 (7)   NULL,
    [Date_Stamp_Most_Recent_MQL__c]                    DATETIME2 (7)   NULL,
    [Date_Stamp_MQL__c]                                DATETIME2 (7)   NULL,
    [Date_Stamp_Recycle__c]                            DATETIME2 (7)   NULL,
    [Date_Stamp_Sales__c]                              DATETIME2 (7)   NULL,
    [Date_Stamp_Sales_Working__c]                      DATETIME2 (7)   NULL,
    [Date_Stamp_Suspect__c]                            DATETIME2 (7)   NULL,
    [Date_Stamp_Trash__c]                              DATETIME2 (7)   NULL,
    [Date_Stamp_VOC__c]                                DATETIME2 (7)   NULL,
    [Department]                                       NVARCHAR (80)   NULL,
    [Do_Not_Mail__c]                                   VARCHAR (5)     NULL,
    [Do_not_Solicit__c]                                VARCHAR (5)     NULL,
    [DoNotCall]                                        VARCHAR (5)     NOT NULL,
    [Email]                                            NVARCHAR (80)   NULL,
    [ET_Subscriber_Key__c]                             NVARCHAR (1300) NULL,
    [FirstName]                                        NVARCHAR (40)   NULL,
    [Functional_Role__c]                               NVARCHAR (255)  NULL,
    [HasOptedOutOfEmail]                               VARCHAR (5)     NOT NULL,
    [HasOptedOutOfFax]                                 VARCHAR (5)     NOT NULL,
    [HomePhone]                                        NVARCHAR (40)   NULL,
    [Id]                                               NCHAR (18)      NOT NULL,
    [int_level__c]                                     NVARCHAR (255)  NULL,
    [int_score__c]                                     DECIMAL (18)    NULL,
    [Is_Service_Authorized__c]                         VARCHAR (5)     NULL,
    [IsDeleted]                                        VARCHAR (5)     NOT NULL,
    [Last_Activity_Date_Since_MQL__c]                  DATETIME2 (7)   NULL,
    [Last_NPS_Completed_Date__c]                       DATETIME2 (7)   NULL,
    [Last_NPS_Score__c]                                DECIMAL (18)    NULL,
    [Last_NPS_Sent_Date__c]                            DATETIME2 (7)   NULL,
    [last_scored__c]                                   DATETIME2 (7)   NULL,
    [LastActivityDate]                                 DATETIME2 (7)   NULL,
    [LastModifiedById]                                 NCHAR (18)      NULL,
    [LastModifiedDate]                                 DATETIME2 (7)   NOT NULL,
    [LastName]                                         NVARCHAR (80)   NOT NULL,
    [lead_score__c]                                    NVARCHAR (255)  NULL,
    [LeadSource]                                       NVARCHAR (40)   NULL,
    [LinkedIn_User_Group_Join_Date__c]                 DATETIME2 (7)   NULL,
    [MasterRecordId]                                   NCHAR (18)      NULL,
    [MD_Comments__c]                                   NVARCHAR (1300) NULL,
    [MDR_Working_Nurture_Removal__c]                   NVARCHAR (255)  NULL,
    [Media_Use__c]                                     VARCHAR (5)     NULL,
    [Member_ID__c]                                     NVARCHAR (18)   NULL,
    [Member_Type__c]                                   NVARCHAR (255)  NULL,
    [Name]                                             NVARCHAR (121)  NOT NULL,
    [NPS_Contact__c]                                   VARCHAR (5)     NULL,
    [NPS_Frequency__c]                                 NVARCHAR (255)  NULL,
    [NPS_Opt_Out__c]                                   VARCHAR (5)     NULL,
    [Opportunities_Account__c]                         DECIMAL (18)    NULL,
    [Opportunities_Open_Account__c]                    DECIMAL (18)    NULL,
    [Original_CID__c]                                  NVARCHAR (100)  NULL,
    [Original_PID__c]                                  NVARCHAR (100)  NULL,
    [OwnerId]                                          NCHAR (18)      NOT NULL,
    [Phone]                                            NVARCHAR (40)   NULL,
    [PortalUserType__c]                                NVARCHAR (255)  NULL,
    [Preferred_Contact_Method__c]                      NVARCHAR (255)  NULL,
    [Press_Reference__c]                               VARCHAR (5)     NULL,
    [Primary_Buyer_Expense__c]                         VARCHAR (5)     NULL,
    [Primary_Buyer_Invoice__c]                         VARCHAR (5)     NULL,
    [Primary_Buyer_Travel__c]                          VARCHAR (5)     NULL,
    [Product_Updates_Notifications__c]                 VARCHAR (5)     NULL,
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
    CONSTRAINT [PK_Contact] PRIMARY KEY CLUSTERED ([Id] ASC)
);


GO
CREATE NONCLUSTERED INDEX [NonClusteredIndex-20180427-153902]
    ON [dbo].[Contact]([AccountId] ASC);


GO
CREATE NONCLUSTERED INDEX [<Name of Missing Index, sysname,>]
    ON [dbo].[Contact]([Contact_Status__c] ASC)
    INCLUDE([AccountId], [Email], [LastName]);

