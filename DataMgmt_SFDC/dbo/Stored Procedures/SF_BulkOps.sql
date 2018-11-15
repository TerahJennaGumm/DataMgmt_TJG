

CREATE PROCEDURE [dbo].[SF_BulkOps]
	@operation nvarchar(50),
	@table_server sysname,
	@table_name sysname,
	@opt_param1	nvarchar(512) = ' ',
	@opt_param2 nvarchar(512) = ' '
AS
-- Parameters: @operation		- Operation to perform (Update, Insert, Delete)
--             @table_server           	- Salesforce Linked Server name (i.e. SALESFORCE)
--             @table_name             	- SQL Table containing ID's to delete

-- @ProgDir - Directory containing the DBAmp.exe. Defaults to the DBAmp program directory
-- If needed, modify this for your installation
declare @ProgDir   	varchar(250) 
set @ProgDir = 'C:\"Program Files"\DBAmp\'

declare @Result 	int
declare @Command 	nvarchar(4000)
declare @time_now	char(8)
declare @errorLines varchar(max)
set @errorLines = 'SF_BulkOps Error: '
set NOCOUNT ON

print '--- Starting SF_BulkOps for ' + @table_name + ' ' +  dbo.SF_Version()
declare @LogMessage nvarchar(max)
declare @SPName nvarchar(50)
set @SPName = 'SF_BulkOps:' + Convert(nvarchar(255), NEWID(), 20)
set @LogMessage = 'Parameters: ' + @operation + ' ' +@table_server + ' ' + @table_name + ' ' + ISNULL(@opt_param1, ' ') + ' ' + ISNULL(@opt_param2, ' ') + ' Version: ' +  dbo.SF_Version()
exec SF_Logger @SPName, N'Starting',@LogMessage

declare @server sysname
declare @database sysname


set @operation = lower(@operation)

if CHARINDEX('upsert',@operation) <> 0 and @opt_param1 = ' '
BEGIN
  	Select @time_now = (select Convert(char(8),CURRENT_TIMESTAMP, 8))
	print @time_now + ': Error: External Id Field Name was not provided.'
	set @LogMessage = 'Error: External Id Field Name was not provided.'
	exec SF_Logger @SPName, N'Message', @LogMessage
	set @errorLines = @errorLines + @time_now + ': Error: External Id Field Name was not provided.'
  	GOTO ERR_HANDLER
END
if CHARINDEX('upsert',@operation) <> 0 and @opt_param1 like '%,%'
BEGIN
  	Select @time_now = (select Convert(char(8),CURRENT_TIMESTAMP, 8))
	print @time_now + ': Error: External Id Field Name was not provided before the soap headers parameter.'
	set @LogMessage = 'Error: External Id Field Name was not provided before the soap headers parameter.'
	exec SF_Logger @SPName, N'Message', @LogMessage
	set @errorLines = @errorLines + @time_now + ': Error: External Id Field Name was not provided before the soap headers parameter.'
  	GOTO ERR_HANDLER
END

-- Retrieve current server name and database
select @server = @@servername, @database = DB_NAME()
SET @server = CAST(SERVERPROPERTY('ServerName') AS sysname) 

-- Execute a linked server query to wake up the provider
declare @noTimeZoneConversion char(5)
declare @sql nvarchar(4000)
declare @parmlist nvarchar(30)
select @sql = 'Select @TZOUT = NoTimeZoneConversion from ' 
select @sql = @sql + @table_server + '...sys_sfsession'
select @parmlist = '@TZOUT char(5) OUTPUT'
exec sp_executesql @sql,@parmlist, @TZOUT=@noTimeZoneConversion OUTPUT
IF (@@ERROR <> 0) GOTO ERR_HANDLER


-- Execute DBAmp.exe to bulk delete objects from Salesforce
Select @time_now = (select Convert(char(8),CURRENT_TIMESTAMP, 8))
print @time_now + ': Run the DBAmp.exe program.' 
set @LogMessage = 'Run the DBAmp.exe program.'
exec SF_Logger @SPName, N'Message', @LogMessage
set @Command = @ProgDir + 'DBAmp.exe ' + @operation + ' ' + @table_name 
set @Command = @Command + ' "' + @server + '" '
set @Command = @Command + ' "' + @database + '" '
set @Command = @Command + ' "' + @table_server + '" '
if CHARINDEX('upsert',@operation) <> 0
begin
	set @Command = @Command + ' "' + @opt_param1 + '" '
	set @Command = @Command + ' "' + @opt_param2 + '" '
end
else
begin
   set @Command = @Command + ' "' + @opt_param1 + '" '
end

-- Create temp table to hold output
declare @errorlog TABLE (line varchar(255))
insert into @errorlog
	exec @Result = master..xp_cmdshell @Command

-- print output to msgs
declare @line varchar(255)
declare @printCount int
set @printCount = 0
DECLARE tables_cursor CURSOR FOR SELECT line FROM @errorlog
OPEN tables_cursor
FETCH NEXT FROM tables_cursor INTO @line
WHILE (@@FETCH_STATUS <> -1)
BEGIN
   if @line is not null
	begin
   	print @line 
   	exec SF_Logger @SPName,N'Message', @line
   	set @errorLines = @errorLines + @line
   	set @printCount = @printCount +1	
	end
   FETCH NEXT FROM tables_cursor INTO @line
END
deallocate tables_cursor


if @Result = -1 or @printCount = 0
BEGIN
  	Select @time_now = (select Convert(char(8),CURRENT_TIMESTAMP, 8))
	print @time_now + ': Error: DBAmp.exe was unsuccessful.'
	set @LogMessage = 'Error: DBAmp.exe was unsuccessful.'
	exec SF_Logger @SPName, N'Message', @LogMessage
	print @time_now + ': Error: Command string is ' + @Command
	set @LogMessage = 'Error: Command string is ' + @Command
	exec SF_Logger @SPName, N'Message', @LogMessage
  	GOTO RESTORE_ERR_HANDLER
END

print '--- Ending SF_BulkOps. Operation successful.'
set @LogMessage = 'Ending - Operation Successful.' 
exec SF_Logger @SPName, N'Successful',@LogMessage
set NOCOUNT OFF
return 0

RESTORE_ERR_HANDLER:

print '--- Ending SF_BulkOps. Operation FAILED.'
set @LogMessage = 'Ending - Operation Failed.' 
exec SF_Logger @SPName,N'Failed', @LogMessage
set NOCOUNT OFF
RAISERROR (@errorLines,16,1)
return 1

ERR_HANDLER:

print '--- Ending SF_BulkOps. Operation FAILED.'
set @LogMessage = 'Ending - Operation Failed.' 
exec SF_Logger @SPName, N'Failed',@LogMessage
set NOCOUNT OFF
RAISERROR (@errorLines,16,1)
return 1

