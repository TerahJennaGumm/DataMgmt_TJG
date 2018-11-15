CREATE TABLE [dbo].[t_account_mapper] (
    [nm_login] NVARCHAR (255) NOT NULL,
    [nm_space] NVARCHAR (40)  NOT NULL,
    [id_acc]   INT            NOT NULL
);


GO
CREATE NONCLUSTERED INDEX [IDX_mapper_id]
    ON [dbo].[t_account_mapper]([id_acc] ASC);

