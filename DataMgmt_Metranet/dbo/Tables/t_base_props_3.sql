CREATE TABLE [dbo].[t_base_props] (
    [id_prop]         INT             NOT NULL,
    [n_kind]          INT             NOT NULL,
    [n_name]          INT             NULL,
    [n_desc]          INT             NULL,
    [nm_name]         NVARCHAR (255)  NULL,
    [nm_desc]         NVARCHAR (4000) NULL,
    [b_approved]      CHAR (1)        NULL,
    [b_archive]       CHAR (1)        NULL,
    [n_display_name]  INT             NULL,
    [nm_display_name] NVARCHAR (255)  NULL,
    CONSTRAINT [t_base_props_PK] PRIMARY KEY CLUSTERED ([id_prop] ASC)
);

