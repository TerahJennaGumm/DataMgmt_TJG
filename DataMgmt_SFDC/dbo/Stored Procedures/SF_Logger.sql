CREATE PROCEDURE [dbo].[SF_Logger]
	@SPName sysname,
	@Status nvarchar(20),
	@Message nvarchar(max)
AS

declare @log_table sysname
declare @delim_log_table sysname
declare @sql nvarchar(max)
declare @logCount int
declare @logMaxCount int
-- Comment this line to turn logging on
return 0

-- Put delimeters around names 
set @log_table = 'DBAmp_Log'
set @delim_log_table = '[' + @log_table + ']'

declare @log_exist int

set @log_exist = 0
IF EXISTS (SELECT 1
    FROM INFORMATION_SCHEMA.TABLES
    WHERE TABLE_TYPE='BASE TABLE' 
    AND TABLE_NAME=@log_table)
        set @log_exist = 1
IF (@@ERROR <> 0) return 0

if (@log_exist = 0)
begin
   exec ('Create Table ' + @log_table + ' (SPName sysname null, Status nvarchar(20) null, Message nvarchar(max),LogTime datetime null default CURRENT_TIMESTAMP) ')
   IF (@@ERROR <> 0) return 0
end
else
begin
	-- Check for log wrap
	-- If the log is too big, delete half of it
	set @logMaxCount = 50000
	Select @sql = 'DELETE FROM ' + @log_table + ' WHERE LogTime NOT IN (SELECT TOP '
	select @sql = @sql + CONVERT(nvarchar(10),@logMaxCount/2) + ' LogTime FROM '
	Select @sql = @sql + @log_table + ' ORDER BY LogTime desc) and (Select COUNT(LogTime) from '
	select @sql = @sql + @log_table + ') > ' + CONVERT(nvarchar(10),@logMaxCount)
	exec sp_executesql @sql
end

-- Add a messge to the log
SET @Message = REPLACE(@Message,'''','''''')  -- Fix issue with single quotes
select @sql = 'insert into ' + @log_table + '(SPName,Status, Message) '
select @sql = @sql + 'Values( ''' + Cast(@SPName as nvarchar(256)) + '''' +
							','''+ @Status + '''' +
							','''+ @Message + ''')'
exec sp_executesql @sql
return 0

