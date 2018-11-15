CREATE TABLE [dbo].[sys_sfobjects] (
    [Name]           NVARCHAR (128)  NOT NULL,
    [Createable]     VARCHAR (5)     NOT NULL,
    [Deletable]      VARCHAR (5)     NOT NULL,
    [Queryable]      VARCHAR (5)     NOT NULL,
    [Replicateable]  VARCHAR (5)     NOT NULL,
    [URLDetail]      NVARCHAR (2048) NOT NULL,
    [URLEdit]        NVARCHAR (2048) NOT NULL,
    [URLNew]         NVARCHAR (2048) NOT NULL,
    [TimestampField] NVARCHAR (128)  NOT NULL,
    CONSTRAINT [pk_sys_sfobjects] PRIMARY KEY CLUSTERED ([Name] ASC)
);

