CREATE TABLE [Archive].[t_char_values] (
    [ArchiveID]    INT           NOT NULL,
    [id_scv]       INT           NULL,
    [id_entity]    INT           NULL,
    [nm_value]     NVARCHAR (20) NULL,
    [c_start_date] DATETIME      NULL,
    [c_end_date]   DATETIME      NULL,
    [c_spec_name]  NVARCHAR (20) NULL,
    [c_spec_type]  INT           NULL
);


GO
CREATE CLUSTERED INDEX [cx_t_char_values]
    ON [Archive].[t_char_values]([ArchiveID] ASC);

