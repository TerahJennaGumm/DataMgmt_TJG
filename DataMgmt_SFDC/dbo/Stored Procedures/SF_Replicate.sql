
CREATE PROCEDURE [dbo].[SF_Replicate]
	@table_server sysname,
	@table_name sysname,
	@options	nvarchar(255) = NULL

AS
-- Parameters: @table_server           - Salesforce Linked Server name (i.e. SALESFORCE)
--             @table_name             - Salesforce object to copy (i.e. Account)

-- @ProgDir - Directory containing the DBAmp.exe. Defaults to the DBAmp program directory
-- If needed, modify this for your installation
declare @ProgDir   	varchar(250) 
set @ProgDir = 'C:\"Program Files"\DBAmp\'

declare @Result 	int
declare @Command 	nvarchar(4000)
declare @time_now	char(8)
set NOCOUNT ON

print '--- Starting SF_Replicate for ' + @table_name + ' ' +  dbo.SF_Version()
declare @LogMessage nvarchar(max)
declare @SPName nvarchar(50)
set @SPName = 'SF_Replicate:' + Convert(nvarchar(255), NEWID(), 20)
set @LogMessage = 'Parameters: ' + @table_server + ' ' + @table_name + ' ' + ISNULL(@options, ' ') + ' Version: ' +  dbo.SF_Version()
exec SF_Logger @SPName, N'Starting',@LogMessage

declare @delim_table_name sysname
declare @prev_table sysname
declare @delim_prev_table sysname
declare @server sysname
declare @database sysname



-- Put delimeters around names so we can name tables User, etc...
set @delim_table_name = '[' + @table_name + ']'
set @prev_table = @table_name + '_Previous'
set @delim_prev_table = '[' + @prev_table + ']'

-- Determine whether the local table and the previous copy exist
declare @table_exist int
declare @prev_exist int

set @table_exist = 0
set @prev_exist = 0;
IF EXISTS (SELECT 1
    FROM INFORMATION_SCHEMA.TABLES
    WHERE TABLE_TYPE='BASE TABLE' 
    AND TABLE_NAME=@table_name)
        set @table_exist = 1
IF (@@ERROR <> 0) GOTO ERR_HANDLER

IF EXISTS (SELECT 1
    FROM INFORMATION_SCHEMA.TABLES
    WHERE TABLE_TYPE='BASE TABLE' 
    AND TABLE_NAME=@prev_table)
        set @prev_exist = 1
IF (@@ERROR <> 0) GOTO ERR_HANDLER

if @table_exist = 1
begin
	-- Make sure that the table doesn't have any keys defined
	IF EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS
    		   WHERE CONSTRAINT_TYPE = 'FOREIGN KEY' AND TABLE_NAME=@table_name )
        begin
 	   Select @time_now = (select Convert(char(8),CURRENT_TIMESTAMP, 8))
	   print @time_now + ': Error: The table contains foreign keys and cannot be replicated.' 
	   set @LogMessage = 'Error: The table contains foreign keys and cannot be replicated.'
	   exec SF_Logger @SPName, N'Message', @LogMessage
	   GOTO ERR_HANDLER
	end
end

-- If the previous table exists, drop it
Select @time_now = (select Convert(char(8),CURRENT_TIMESTAMP, 8))
print @time_now + ': Drop ' + @prev_table + ' if it exists.'
set @LogMessage = 'Drop ' + @prev_table + ' if it exists.'
exec SF_Logger @SPName, N'Message', @LogMessage
if (@prev_exist = 1)
        exec ('Drop table ' + @delim_prev_table)
IF (@@ERROR <> 0) GOTO ERR_HANDLER

-- Create an empty local table with the current structure of the Salesforce object
Select @time_now = (select Convert(char(8),CURRENT_TIMESTAMP, 8))
print @time_now + ': Create ' + @prev_table + ' with new structure.'
set @LogMessage = 'Create ' + @prev_table + ' with new structure.'
exec SF_Logger @SPName, N'Message', @LogMessage

begin try
exec ('Select Top 0 * into ' + @delim_prev_table + ' from ' + @table_server + '...' + @delim_table_name )
end try
begin catch
	Select @time_now = (select Convert(char(8),CURRENT_TIMESTAMP, 8))
	print @time_now + ': Error: Salesforce table does not exist: ' + @table_name
	set @LogMessage = 'Error: Salesforce table does not exist: ' + @table_name
	exec SF_Logger @SPName, N'Message', @LogMessage
	print @time_now +
		': Error: ' + ERROR_MESSAGE();
	set @LogMessage = 'Error: ' + ERROR_MESSAGE()
	exec SF_Logger @SPName, N'Message', @LogMessage
	GOTO ERR_HANDLER
end catch

-- Retrieve current server name and database
select @server = @@servername, @database = DB_NAME()
SET @server = CAST(SERVERPROPERTY('ServerName') AS sysname) 

-- Execute DBAmp.exe to load table from Salesforce
Select @time_now = (select Convert(char(8),CURRENT_TIMESTAMP, 8))
print @time_now + ': Run the DBAmp.exe program.' 
set @LogMessage = 'Run the DBAmp.exe program.'
exec SF_Logger @SPName, N'Message', @LogMessage
set @Command = @ProgDir + 'DBAmp.exe Export' 
if (@options is not null)
begin
	set @Command = @Command + ':' + @options
end
set @Command = @Command + ' "' + @prev_table + '" '
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
   print 'Error occurred running the DBAmp.exe program'	
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


if @Result = -1 or @printCount = 0 or @printCount = 1
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

declare @primarykey_exists as int
set @primarykey_exists = 0

if @table_exist = 1
begin
	-- Check to see if the table had a primary key defined
	IF EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS
    		   WHERE CONSTRAINT_TYPE = 'PRIMARY KEY' AND TABLE_NAME=@table_name )
    begin
		Set @primarykey_exists = 1
	end
end

-- Change for V2.14.2:  Always create primary key
Set @primarykey_exists = 1

if Lower(@table_name) = 'oauthtoken' set @primarykey_exists = 0
if Lower(@table_name) = 'recentlyviewed' set @primarykey_exists = 0
if Lower(@table_name) = 'datatype' set @primarykey_exists = 0

BEGIN TRY
    BEGIN TRANSACTION;
	-- If the local table exists, drop it
	Select @time_now = (select Convert(char(8),CURRENT_TIMESTAMP, 8))
	print @time_now + ': Drop ' + @table_name + ' if it exists.'
	set @LogMessage = 'Drop ' + @table_name + ' if it exists.'
	exec SF_Logger @SPName, N'Message', @LogMessage
	if (@table_exist = 1)
		exec ('Drop table ' + @delim_table_name)

	-- Backup previous table into current
	Select @time_now = (select Convert(char(8),CURRENT_TIMESTAMP, 8))
	print @time_now + ': Rename previous table from ' + @prev_table + ' to ' + @table_name
	set @LogMessage = 'Rename previous table from ' + @prev_table + ' to ' + @table_name
	exec SF_Logger @SPName, N'Message', @LogMessage
	exec sp_rename @prev_table, @table_name

    -- If the DDL statement succeeds, commit the transaction.
    COMMIT TRANSACTION;
END TRY
BEGIN CATCH
	Select @time_now = (select Convert(char(8),CURRENT_TIMESTAMP, 8))
	print @time_now + ': Error occurred dropping and renaming the table.'
	set @LogMessage = 'Error occurred dropping and renaming the table.'
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
     goto ERR_HANDLER
END CATCH

-- Recreate Primary Key is needed
BEGIN TRY
	Select @time_now = (select Convert(char(8),CURRENT_TIMESTAMP, 8))
	print @time_now + ': Create primary key on ' + @table_name
	set @LogMessage = 'Create primary key on ' + @table_name
	exec SF_Logger @SPName, N'Message', @LogMessage
	if (@primarykey_exists = 1)
	   -- Add Id as Primary Key
	   exec ('Alter table ' + @delim_table_name + ' Add Constraint PK_' + @table_name + '_Id Primary Key NONCLUSTERED (Id) ')
END TRY
BEGIN CATCH
	Select @time_now = (select Convert(char(8),CURRENT_TIMESTAMP, 8))
	print @time_now + ': Error occurred creating primary key for table.'
	set @LogMessage = 'Error occurred creating primary key for table.'
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
     goto ERR_HANDLER
END CATCH

print '--- Ending SF_Replicate. Operation successful.'
set @LogMessage = 'Ending - Operation Successful.' 
exec SF_Logger @SPName,N'Successful', @LogMessage
set NOCOUNT OFF
return 0

RESTORE_ERR_HANDLER:
print('--- Ending SF_Replicate. Operation FAILED.')
set @LogMessage = 'Ending - Operation Failed.' 
exec SF_Logger @SPName, N'Failed',@LogMessage
RAISERROR ('--- Ending SF_Replicate. Operation FAILED.',16,1)
set NOCOUNT OFF
return 1

ERR_HANDLER:
print('--- Ending SF_Replicate. Operation FAILED.')
set @LogMessage = 'Ending - Operation Failed.' 
exec SF_Logger @SPName,N'Failed', @LogMessage
RAISERROR ('--- Ending SF_Replicate. Operation FAILED.',16,1)
set NOCOUNT OFF
return 1

