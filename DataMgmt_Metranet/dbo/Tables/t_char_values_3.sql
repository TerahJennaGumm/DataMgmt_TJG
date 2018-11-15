CREATE TABLE [dbo].[t_char_values] (
    [id_scv]       INT           NOT NULL,
    [id_entity]    INT           NOT NULL,
    [nm_value]     NVARCHAR (20) NULL,
    [c_start_date] DATETIME      NOT NULL,
    [c_end_date]   DATETIME      NULL,
    [c_spec_name]  NVARCHAR (20) NOT NULL,
    [c_spec_type]  INT           NOT NULL,
    PRIMARY KEY CLUSTERED ([id_scv] ASC, [id_entity] ASC)
);


GO
CREATE NONCLUSTERED INDEX [idx_Missing_IXNC_t_char_values_c_spec_name_FD88A]
    ON [dbo].[t_char_values]([c_spec_name] ASC)
    INCLUDE([id_scv], [id_entity], [nm_value], [c_start_date], [c_end_date], [c_spec_type]);


GO
CREATE NONCLUSTERED INDEX [t_char_values_N1]
    ON [dbo].[t_char_values]([c_spec_name] ASC, [id_entity] ASC)
    INCLUDE([c_start_date], [nm_value]);


GO
CREATE NONCLUSTERED INDEX [t_char_values_N2]
    ON [dbo].[t_char_values]([id_entity] ASC)
    INCLUDE([c_spec_name], [c_start_date], [nm_value]);


GO
CREATE NONCLUSTERED INDEX [t_char_values_N3]
    ON [dbo].[t_char_values]([nm_value] ASC, [c_spec_name] ASC);

