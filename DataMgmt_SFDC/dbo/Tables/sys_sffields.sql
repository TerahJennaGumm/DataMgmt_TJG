CREATE TABLE [dbo].[sys_sffields] (
    [ObjectName]         NVARCHAR (128) NOT NULL,
    [Name]               NVARCHAR (128) NOT NULL,
    [Type]               NVARCHAR (32)  NOT NULL,
    [Label]              NVARCHAR (128) NOT NULL,
    [SQLDefinition]      NVARCHAR (128) NOT NULL,
    [Calculated]         VARCHAR (5)    NOT NULL,
    [Createable]         VARCHAR (5)    NOT NULL,
    [DefaultedOnCreate]  VARCHAR (5)    NOT NULL,
    [Filterable]         VARCHAR (5)    NOT NULL,
    [NameField]          VARCHAR (5)    NOT NULL,
    [Nillable]           VARCHAR (5)    NOT NULL,
    [Sortable]           VARCHAR (5)    NOT NULL,
    [Unique]             VARCHAR (5)    NOT NULL,
    [Updateable]         VARCHAR (5)    NOT NULL,
    [AutoNumber]         VARCHAR (5)    NOT NULL,
    [RestrictedPicklist] VARCHAR (5)    NOT NULL,
    [ExternalID]         VARCHAR (5)    NOT NULL,
    [RelationshipName]   NVARCHAR (128) NOT NULL,
    [HelpText]           NVARCHAR (257) NOT NULL,
    CONSTRAINT [pk_sys_sffields] PRIMARY KEY CLUSTERED ([ObjectName] ASC, [Name] ASC)
);

