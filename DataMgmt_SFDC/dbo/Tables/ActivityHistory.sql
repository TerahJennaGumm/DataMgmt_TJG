CREATE TABLE [dbo].[ActivityHistory] (
    [Id]                                                     NCHAR (18)      NULL,
    [ActivityHistories_AccountId]                            NCHAR (18)      NULL,
    [ActivityHistories_Id]                                   NCHAR (18)      NULL,
    [ActivityHistories_CreatedDate]                          DATETIME2 (7)   NULL,
    [ActivityHistories_ActivityDate]                         DATETIME2 (7)   NULL,
    [ActivityHistories_IsDeleted]                            VARCHAR (5)     NULL,
    [ActivityHistories_LastModifiedById]                     NCHAR (18)      NULL,
    [ActivityHistories_LastModifiedDate]                     DATETIME2 (7)   NULL,
    [ActivityHistories_WhoId]                                NCHAR (18)      NULL,
    [ActivityHistories_Status]                               NVARCHAR (40)   NULL,
    [ActivityHistories_Subject]                              NVARCHAR (80)   NULL,
    [ActivityHistories_ActivityType]                         NVARCHAR (40)   NULL,
    [ActivityHistories_Completed_Date__c]                    DATETIME2 (7)   NULL,
    [ActivityHistories_Completed_by__c]                      NVARCHAR (255)  NULL,
    [ActivityHistories_CallDurationInSeconds]                INT             NULL,
    [ActivityHistories_ringdna__Abandoned_Call__c]           VARCHAR (5)     NULL,
    [ActivityHistories_ringdna__Automated_Voicemail__c]      VARCHAR (5)     NULL,
    [ActivityHistories_ringdna__Automated_Voicemail_Used__c] NVARCHAR (255)  NULL,
    [ActivityHistories_ringdna__Call_Connected__c]           VARCHAR (5)     NULL,
    [ActivityHistories_ringdna__Call_Direction__c]           NVARCHAR (255)  NULL,
    [ActivityHistories_ringdna__Call_Disposition__c]         NVARCHAR (255)  NULL,
    [ActivityHistories_ringdna__Call_Duration__c]            DECIMAL (18)    NULL,
    [ActivityHistories_ringdna__Call_Duration_min__c]        DECIMAL (18, 2) NULL,
    [ActivityHistories_ringdna__Call_Hour_Of_Day_Local__c]   DECIMAL (18)    NULL,
    [ActivityHistories_ringdna__Call_Rating__c]              DECIMAL (18)    NULL,
    [ActivityHistories_ringdna__Call_Recording__c]           NVARCHAR (1300) NULL,
    [ActivityHistories_ringdna__Call_Recording_URL__c]       NVARCHAR (255)  NULL,
    [ActivityHistories_ringdna__Called_Back__c]              VARCHAR (5)     NULL,
    [ActivityHistories_ringdna__Created_by_RingDNA__c]       VARCHAR (5)     NULL,
    [ActivityHistories_ringdna__Local_Presence__c]           VARCHAR (5)     NULL,
    [ActivityHistories_ringdna__Local_Presence_Num__c]       NVARCHAR (40)   NULL,
    [ActivityHistories_ringdna__Queue__c]                    NVARCHAR (255)  NULL,
    [ActivityHistories_ringdna__Queue_Hold_Time__c]          DECIMAL (18)    NULL,
    [ActivityHistories_ringdna__Supervisor_Notes__c]         NVARCHAR (255)  NULL,
    [ActivityHistories_ringdna__Voicemail__c]                VARCHAR (5)     NULL
);


GO
CREATE NONCLUSTERED INDEX [activityhistory_n1]
    ON [dbo].[ActivityHistory]([ActivityHistories_AccountId] ASC);


GO
CREATE NONCLUSTERED INDEX [IDX_AH]
    ON [dbo].[ActivityHistory]([ActivityHistories_AccountId] ASC, [ActivityHistories_CreatedDate] ASC);


GO
CREATE NONCLUSTERED INDEX [ActivityHistories_ActivityType_AcctId]
    ON [dbo].[ActivityHistory]([ActivityHistories_ActivityType] ASC)
    INCLUDE([Id], [ActivityHistories_AccountId]);


GO
CREATE NONCLUSTERED INDEX [ActivityHistories_ActivityType]
    ON [dbo].[ActivityHistory]([ActivityHistories_ActivityType] ASC)
    INCLUDE([ActivityHistories_AccountId], [ActivityHistories_Subject]);

