
CREATE PROCEDURE [dbo].[SF_Replicate3]
	@table_server sysname,
	@table_name sysname,
	@options nvarchar(255) = NULL
AS
-- Parameters: @table_server           - Salesforce Linked Server name (i.e. SALESFORCE)
--             @table_name             - Salesforce object to copy (i.e. Account)


declare @Result 	int
declare @Command 	nvarchar(4000)
declare @time_now	char(8)
set NOCOUNT ON

print '--- Starting SF_Replicate3 for ' + @table_name + ' ' +  dbo.SF_Version()
declare @delim_table_name sysname
declare @prev_table sysname
declare @delim_prev_table sysname
declare @server sysname
declare @database sysname
declare @LogMessage nvarchar(max)
declare @SPName nvarchar(50)
set @SPName = 'SF_Replicate3:' + CONVERT(nvarchar(255), NEWID(), 20)
set @LogMessage = 'Parameters: ' + @table_server + ' ' + @table_name + ' ' + ISNULL(@options, ' ') + ' Version: ' +  dbo.SF_Version()
exec SF_Logger @SPName, N'Starting', @LogMessage



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

-- Get the sessionId from DBAmp. This also tests connectivity to salesforce.com
declare @sql nvarchar(4000)
declare @parmlist nvarchar(512)

if @table_exist = 1
begin
	-- Make sure that the table doesn't have any keys defined
	IF EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS
    		   WHERE CONSTRAINT_TYPE = 'FOREIGN KEY' AND TABLE_NAME=@table_name)
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

exec ('Insert into ' + @delim_prev_table + ' select * from openquery(' + @table_server + ',''Select * from ' + @table_name + '  '')')
IF (@@ERROR <> 0) GOTO RESTORE_ERR_HANDLER

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

-- If the local table exists, drop it
Select @time_now = (select Convert(char(8),CURRENT_TIMESTAMP, 8))
print @time_now + ': Drop ' + @table_name + ' if it exists.'
set @LogMessage = 'Drop ' + @table_name + ' if it exists.'
exec SF_Logger @SPName, N'Message', @LogMessage
if (@table_exist = 1)
	exec ('Drop table ' + @delim_table_name)
IF (@@ERROR <> 0) GOTO ERR_HANDLER

-- Backup previous table into current
Select @time_now = (select Convert(char(8),CURRENT_TIMESTAMP, 8))
print @time_now + ': Rename previous table from ' + @prev_table + ' to ' + @table_name
set @LogMessage = 'Rename previous table from ' + @prev_table + ' to ' + @table_name
exec SF_Logger @SPName, N'Message', @LogMessage
exec sp_rename @prev_table, @table_name
IF (@@ERROR <> 0) GOTO ERR_HANDLER

declare @totalrows int 
set @totalrows = 0
select @sql = 'Select @rowscopiedOUT = count(ID) from ' + @delim_table_name
select @parmlist = '@rowscopiedOUT int OUTPUT'
exec sp_executesql @sql, @parmlist, @rowscopiedOUT = @totalrows OUTPUT

Select @time_now = (select Convert(char(8),CURRENT_TIMESTAMP, 8))
print @time_now + ': ' + Cast(@totalrows AS nvarchar(10)) + ' rows copied.'
set @LogMessage = @time_now + ': ' + Cast(@totalrows AS nvarchar(10)) + ' rows copied.'
exec SF_Logger @SPName, N'Message', @LogMessage

-- Recreate Primary Key is needed
Select @time_now = (select Convert(char(8),CURRENT_TIMESTAMP, 8))
print @time_now + ': Create primary key on ' + @table_name
set @LogMessage = 'Create primary key on ' + @table_name
exec SF_Logger @SPName, N'Message', @LogMessage
if (@primarykey_exists = 1)
   -- Add Id as Primary Key
   exec ('Alter table ' + @delim_table_name + ' Add Constraint PK_' + @table_name + '_Id Primary Key NONCLUSTERED (Id) ')
IF (@@ERROR <> 0) GOTO ERR_HANDLER

print '--- Ending SF_Replicate3. Operation successful.'
set @LogMessage = 'Ending - Operation Successful.'
exec SF_Logger @SPName, N'Successful', @LogMessage
set NOCOUNT OFF
return 0

RESTORE_ERR_HANDLER:
print('--- Ending SF_Replicate3. Operation FAILED.')
set @LogMessage = 'Ending - Operation Failed.'
exec SF_Logger @SPName, N'Failed', @LogMessage
RAISERROR ('--- Ending SF_Replicate3. Operation FAILED.',16,1)
set NOCOUNT OFF
return 1

ERR_HANDLER:
print('--- Ending SF_Replicate3. Operation FAILED.')
set @LogMessage = 'Ending - Operation Failed.'
exec SF_Logger @SPName, N'Failed', @LogMessage	
RAISERROR ('--- Ending SF_Replicate3. Operation FAILED.',16,1)
set NOCOUNT OFF
return 1

