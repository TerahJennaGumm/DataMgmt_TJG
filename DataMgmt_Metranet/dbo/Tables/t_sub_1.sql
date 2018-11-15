CREATE TABLE [dbo].[t_sub] (
    [id_sub]     INT            NOT NULL,
    [id_sub_ext] VARBINARY (16) NOT NULL,
    [id_acc]     INT            NULL,
    [id_po]      INT            NOT NULL,
    [dt_crt]     DATETIME       NULL,
    [vt_start]   DATETIME       NOT NULL,
    [vt_end]     DATETIME       NOT NULL,
    [id_group]   INT            NULL
);

