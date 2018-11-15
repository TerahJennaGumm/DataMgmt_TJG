CREATE TABLE [Archive].[ArchiveHistory] (
    [Id]                  INT      IDENTITY (1, 1) NOT NULL,
    [ArchiveDateTime]     DATETIME DEFAULT (getdate()) NULL,
    [LastRestoreDateTime] DATETIME NULL
);

