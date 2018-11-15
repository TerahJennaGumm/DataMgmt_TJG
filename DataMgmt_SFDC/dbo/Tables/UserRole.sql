﻿CREATE TABLE [dbo].[UserRole] (
    [CaseAccessForAccountOwner]        NVARCHAR (40) NULL,
    [ContactAccessForAccountOwner]     NVARCHAR (40) NULL,
    [ForecastUserId]                   NCHAR (18)    NULL,
    [Id]                               NCHAR (18)    NOT NULL,
    [LastModifiedById]                 NCHAR (18)    NULL,
    [LastModifiedDate]                 DATETIME2 (7) NOT NULL,
    [MayForecastManagerShare]          VARCHAR (5)   NOT NULL,
    [Name]                             NVARCHAR (80) NOT NULL,
    [OpportunityAccessForAccountOwner] NVARCHAR (40) NOT NULL,
    [ParentRoleId]                     NCHAR (18)    NULL,
    [PortalAccountId]                  NCHAR (18)    NULL,
    [PortalAccountOwnerId]             NCHAR (18)    NULL,
    [PortalRole]                       NVARCHAR (40) NULL,
    [PortalType]                       NVARCHAR (40) NULL,
    [RollupDescription]                NVARCHAR (80) NULL,
    [SystemModstamp]                   DATETIME2 (7) NOT NULL,
    CONSTRAINT [PK_UserRole_Id] PRIMARY KEY CLUSTERED ([Id] ASC)
);

