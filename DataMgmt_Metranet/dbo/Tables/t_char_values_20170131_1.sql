CREATE TABLE [dbo].[t_char_values_20170131] (
    [id_scv]       INT           NOT NULL,
    [id_entity]    INT           NOT NULL,
    [nm_value]     NVARCHAR (20) NULL,
    [c_start_date] DATETIME      NOT NULL,
    [c_end_date]   DATETIME      NULL,
    [c_spec_name]  NVARCHAR (20) NOT NULL,
    [c_spec_type]  INT           NOT NULL
);

