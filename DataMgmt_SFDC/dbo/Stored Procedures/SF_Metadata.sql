

CREATE PROCEDURE [dbo].[SF_Metadata]
    @operation  nvarchar(255),
	@table_server sysname,
	@table_name sysname

AS
-- Parameters: @table_server           - Salesforce Linked Server name (i.e. SALESFORCE)
--             @table_name             - Table containing metadata

-- @ProgDir - Directory containing the DBAmpNet.exe. Defaults to the DBAmp program directory
-- If needed, modify this for your installation
declare @ProgDir   	varchar(250) 
set @ProgDir = 'C:\"Program Files"\DBAmp\'

declare @Result 	int
declare @Command 	nvarchar(4000)
declare @time_now	char(8)
set NOCOUNT ON

print '--- Starting SF_Metadata for ' + @table_name + ' ' +  dbo.SF_Version()
declare @LogMessage nvarchar(max)
declare @SPName nvarchar(50)
set @SPName = 'SF_Metadata:' + Convert(nvarchar(255), NEWID(), 20)
set @LogMessage = 'Parameters: ' + @operation + ' ' + @table_server + ' ' + @table_name + ' ' + ' Version: ' +  dbo.SF_Version()
exec SF_Logger @SPName, N'Starting',@LogMessage

declare @delim_table_name sysname
declare @server sysname
declare @database sysname

-- Execute a linked server query to wake up the provider
declare @noTimeZoneConversion char(5)
declare @sql nvarchar(4000)
declare @parmlist nvarchar(30)
select @sql = 'Select @TZOUT = NoTimeZoneConversion from ' 
select @sql = @sql + @table_server + '...sys_sfsession'
select @parmlist = '@TZOUT char(5) OUTPUT'
exec sp_executesql @sql,@parmlist, @TZOUT=@noTimeZoneConversion OUTPUT
IF (@@ERROR <> 0) GOTO ERR_HANDLER


-- Put delimeters around names so we can name tables User, etc...
set @delim_table_name = '[' + @table_name + ']'

-- Determine whether the local table exist
declare @table_exist int

set @table_exist = 0
IF EXISTS (SELECT 1
    FROM INFORMATION_SCHEMA.TABLES
    WHERE TABLE_TYPE='BASE TABLE' 
    AND TABLE_NAME=@table_name)
        set @table_exist = 1
IF (@@ERROR <> 0) GOTO ERR_HANDLER

-- Retrieve current server name and database
select @server = @@servername, @database = DB_NAME()
SET @server = CAST(SERVERPROPERTY('ServerName') AS sysname) 

-- Execute DBAmpNet.exe to load table from Salesforce
Select @time_now = (select Convert(char(8),CURRENT_TIMESTAMP, 8))
print @time_now + ': Run the DBAmpNet.exe program.' 
set @LogMessage = 'Run the DBAmpNet.exe program.'
exec SF_Logger @SPName, N'Message', @LogMessage
set @Command = @ProgDir + 'DBAmpNet.exe ' 
if (@operation is not null)
begin
	set @Command = @Command + @operation
end
set @Command = @Command + ' "' + @table_name + '" '
set @Command = @Command + ' "' + @server + '" '
set @Command = @Command + ' "' + @database + '" '
set @Command = @Command + ' "' + @table_server + '" '

-- Create temp table to hold output
declare @errorlog table (line varchar(255))

begin try
insert into @errorlog
	exec @Result = master..xp_cmdshell @Command
end try
begin catch
   print 'Error occurred running the DBAmpNet.exe program'	
	Select @time_now = (select Convert(char(8),CURRENT_TIMESTAMP, 8))
	print @time_now + ': Error occurred running the DBAmp.exe program'	
	set @LogMessage = 'Error occurred running the DBAmp.exe program'
	exec SF_Logger @SPName, N'Message', @LogMessage
	print @time_now +
		': Error: ' + ERROR_MESSAGE();
		set @LogMessage = 'Error: ' + ERROR_MESSAGE()
		exec SF_Logger @SPName, N'Message', @LogMessage
		
     -- Roll back any active or uncommittable transactions before
     -- inserting information in the ErrorLog.
     IF XACT_STATE() <> 0
     BEGIN
         ROLLBACK TRANSACTION;
     END
    
  set @Result = -1
end catch

if @@ERROR <> 0
   set @Result = -1

-- print output to msgs
declare @line varchar(255)
declare @printCount int
Set @printCount = 0

DECLARE tables_cursor CURSOR FOR SELECT line FROM @errorlog
OPEN tables_cursor
FETCH NEXT FROM tables_cursor INTO @line
WHILE (@@FETCH_STATUS <> -1)
BEGIN
   if @line is not null 
	begin
	print @line
	exec SF_Logger @SPName,N'Message', @line
	Set @printCount = @printCount + 1
	end
   FETCH NEXT FROM tables_cursor INTO @line
END
deallocate tables_cursor

if @Result = -1 or @printCount = 0
BEGIN
  	Select @time_now = (select Convert(char(8),CURRENT_TIMESTAMP, 8))
	print @time_now + ': Error: DBAmpNet.exe was unsuccessful.'
	set @LogMessage = 'Error: DBAmpNet.exe was unsuccessful.'
	exec SF_Logger @SPName, N'Message', @LogMessage
	print @time_now + ': Error: Command string is ' + @Command
	set @LogMessage = 'Error: Command string is ' + @Command
	exec SF_Logger @SPName, N'Message', @LogMessage
  	GOTO RESTORE_ERR_HANDLER
END

print '--- Ending SF_Metadata. Operation successful.'
set @LogMessage = 'Ending - Operation Successful.' 
exec SF_Logger @SPName,N'Successful', @LogMessage
set NOCOUNT OFF
return 0

RESTORE_ERR_HANDLER:
print('--- Ending SF_Metadata. Operation FAILED.')
set @LogMessage = 'Ending - Operation Failed.' 
exec SF_Logger @SPName, N'Failed',@LogMessage
RAISERROR ('--- Ending SF_Metadata. Operation FAILED.',16,1)
set NOCOUNT OFF
return 1

ERR_HANDLER:
print('--- Ending SF_Metadata. Operation FAILED.')
set @LogMessage = 'Ending - Operation Failed.' 
exec SF_Logger @SPName,N'Failed', @LogMessage
RAISERROR ('--- Ending SF_Metadata. Operation FAILED.',16,1)
set NOCOUNT OFF
return 1


