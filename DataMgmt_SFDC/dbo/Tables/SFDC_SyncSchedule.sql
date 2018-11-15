CREATE TABLE [dbo].[SFDC_SyncSchedule] (
    [TblName]            NVARCHAR (205) NOT NULL,
    [LastRefreshTime]    DATETIME       NULL,
    [LastFormulaRefresh] DATETIME       NULL,
    [Schedule]           CHAR (1)       NULL
);

