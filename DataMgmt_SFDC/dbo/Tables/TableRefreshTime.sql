CREATE TABLE [dbo].[TableRefreshTime] (
    [TblName]         NVARCHAR (255) NULL,
    [LastRefreshTime] DATETIME       DEFAULT (getdate()) NULL
);

