
CREATE PROCEDURE [dbo].[SF_ReplicateLarge]
@table_server sysname,
@table_name sysname,
@batchsize int = 250000
 
AS
-- Parameters: @table_server           - Salesforce Linked Server name (i.e. SALESFORCE)
--             @table_name             - Salesforce object to copy (i.e. Account)
 
-- @ProgDir - Directory containing the DBAmp.exe. Defaults to the DBAmp program directory
-- If needed, modify this for your installation
declare @ProgDir   varchar(250) 
set @ProgDir = 'C:\"Program Files"\DBAmp\'
 
declare @bulkapi_option nvarchar(255)
declare @Result int
declare @Command nvarchar(4000)
declare @time_now char(8)
declare @sql nvarchar(max)
declare @sqlNoOffset nvarchar(max)
declare @parmlist nvarchar(4000)
set NOCOUNT ON
 
print '--- Starting SF_ReplicateLarge for ' + @table_name + ' ' +  dbo.SF_Version()
declare @LogMessage nvarchar(max)
declare @SPName nvarchar(50)
set @SPName = 'SF_ReplicateLarge:' + Convert(nvarchar(255), NEWID(), 20)
set @LogMessage = 'Parameters: ' + @table_server + ' ' + @table_name + ' ' + ISNULL(@bulkapi_option, ' ') + ' Version: ' +  dbo.SF_Version()
exec SF_Logger @SPName, N'Starting',@LogMessage
 
-- Check batchsize
 
if (@batchsize < 5000 or @batchsize > 250000)
begin
   Select @time_now = (select Convert(char(8),CURRENT_TIMESTAMP, 8))
  print @time_now + ': Error: Batchsize must be between 5000 and 250000.' 
  set @LogMessage = 'Error: Batchsize must be between 5000 and 250000.'
  exec SF_Logger @SPName, N'Message', @LogMessage 
  GOTO ERR_HANDLER
end
 
declare @delim_table_name sysname
declare @prev_table sysname
declare @delim_prev_table sysname
declare @server sysname
declare @database sysname
 
-- Is it a history or share table
-- If so, chunking occurs on the parent id
declare @isHistory int
declare @isShare int
declare @nameLength int
declare @base_object sysname
declare @parentId_name sysname
 
set @isHistory = 0
if LEN(@table_name) > 8
begin
if RIGHT(@table_name,7) = 'History'
  set @isHistory =1 
if RIGHT(@table_name,7) = 'history'
  set @isHistory =1
set @nameLength = LEN(@table_name) 
set @base_object = LEFT(@table_name, @nameLength - 7)
-- Handle exception for OpportunityFieldHistory
if LOWER(@base_object) = 'opportunityfield' set @base_object='Opportunity'
set @parentId_name = @base_object + 'Id'
 
if RIGHT(@base_object,2) = '__'
begin
  set @base_object = @base_object + 'c'
  set @parentId_name = 'ParentId'
end  
end
 
set @isShare = 0
if LEN(@table_name) > 6 and @isHistory = 0
begin
if RIGHT(@table_name,5) = 'Share'
  set @isShare =1 
if RIGHT(@table_name,5) = 'share'
  set @isShare =1
set @nameLength = LEN(@table_name) 
set @base_object = LEFT(@table_name, @nameLength - 5)
set @parentId_name = @base_object + 'Id'
 
if RIGHT(@base_object,2) = '__'
begin
  set @base_object = @base_object + 'c'
  set @parentId_name = 'ParentId'
end  
end 

-- Adjust batchsize if parent batching
if @batchsize = 250000 and (@isShare = 1 or @isHistory = 1)
begin
	set @batchsize = 25000
end

Select @time_now = (select Convert(char(8),CURRENT_TIMESTAMP, 8))  
print @time_now + ': Using batch size of '  + convert(nvarchar(25),@batchsize-1)  + ''')'
set @LogMessage = 'Using batch size of ' + convert(nvarchar(25), @batchsize-1) + ''')'
exec SF_Logger @SPName, N'Message', @LogMessage
 
-- Force bulkapi
if @bulkapi_option is null 
set @bulkapi_option = 'bulkapi'
else
set @bulkapi_option = 'bulkapi,' + @bulkapi_option 
 
 
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
 
declare @WhereClause nvarchar(512)
declare @StartId nvarchar(18)
declare @EndId nvarchar(18)
declare @AllDone int
set @StartId = '000000000000000'
set @AllDone = 0
 
LOOP:
-- Query for EndId
Select @time_now = (select Convert(char(8),CURRENT_TIMESTAMP, 8))
print @time_now + ': Running query to determine next Id boundary.'
set @LogMessage = 'Running query to determine next Id boundary.'
exec SF_Logger @SPName, N'Message', @LogMessage
set @EndId = null
select @sql = 'Select @ENDID_OUT = Id from openquery(' 
select @sql = @sql + @table_server + ',''select Id from '
if (@isHistory = 0 and @isShare = 0)
begin
select @sql = @sql + @table_name 
end
else
begin
select @sql = @sql + @base_object 
end
select @sql = @sql + '_QueryAll where Id > ' + '''''' + @StartId + ''''' order by Id asc limit 1 '
set @sqlNoOffset = @sql + ''')'

select @sql = @sql + 'offset ' + convert(nvarchar(25),@batchsize-1)  + ''')'
print @sql
select @parmlist = '@ENDID_OUT nvarchar(18) OUTPUT'
exec sp_executesql @sql,@parmlist, @ENDID_OUT=@EndId OUTPUT
IF (@@ERROR <> 0) GOTO ERR_HANDLER
if @EndId is null
begin
  set @AllDone = 1
  
  if (@StartId = '000000000000000')
  begin
    -- Need to determine prefix
    exec sp_executesql @sqlNoOffset,@parmlist, @ENDID_OUT=@EndId OUTPUT
    if @EndId is null
    Begin
		-- Zero records so just end
		--Select @time_now = (select Convert(char(8),CURRENT_TIMESTAMP, 8))
		--print @time_now + ': Error occurred, the table has no rows.'
		GOTO END_LOOP
	end	
	set @EndId = LEFT(@EndId,3)	
  end
  else  -- else StartId is NOT all zeros
  begin 
	set @EndId = LEFT(@StartId,3)
  end
  
  set @EndId = @EndId + 'zzzzzzzzzzzz'   
end
-- Execute DBAmp.exe to get these rows from sf
set @Command = @ProgDir + 'DBAmp.exe ExportBulk' 
set @Command = @Command + ':' + @bulkapi_option
set @Command = @Command + ' "' + @prev_table + '" '
set @Command = @Command + ' "' + @server + '" '
set @Command = @Command + ' "' + @database + '" '
set @Command = @Command + ' "' + @table_server + '" '
 
-- Add where clause
if (@isHistory = 0 and @isShare = 0)
begin
set @WhereClause = ' "where Id>'''
end
else
begin
set @WhereClause = ' "where ' + @parentId_name + '>'''
end
set @WhereClause = @WhereClause + @StartId
set @WhereClause = @WhereClause + ''''
if @EndId is not null
begin
if (@isHistory = 0 and @isShare = 0)
begin
set @WhereClause = @WhereClause + ' and Id<='''
end
else
begin
set @WhereClause = @WhereClause + ' and ' + @parentId_name + '<='''
end
set @WhereClause = @WhereClause + @EndId
set @WhereClause = @WhereClause + ''' "'
end
--print @WhereClause
set @Command = @Command + @WhereClause
Select @time_now = (select Convert(char(8),CURRENT_TIMESTAMP, 8))
print @time_now + ': Run the DBAmp.exe program for ' + @WhereClause
set @LogMessage = 'Run the DBAmp.exe program for ' + @WhereClause 
exec SF_Logger @SPName, N'Message', @LogMessage
 
-- Create temp table to hold output
declare @errorlog table (line varchar(255))
 
delete from @errorlog

-- Execute DBAmp.exe to get these rows from sf
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
if @AllDone = 0
begin 
set @StartId = @EndId
goto LOOP
end

END_LOOP:
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
 
print '--- Ending SF_ReplicateLarge. Operation successful.'
set @LogMessage = 'Ending - Operation Successful.' 
exec SF_Logger @SPName,N'Successful', @LogMessage
set NOCOUNT OFF
return 0
 
RESTORE_ERR_HANDLER:
print('--- Ending SF_ReplicateLarge. Operation FAILED.')
set @LogMessage = 'Ending - Operation Failed.' 
exec SF_Logger @SPName, N'Failed',@LogMessage
RAISERROR ('--- Ending SF_ReplicateLarge. Operation FAILED.',16,1)
set NOCOUNT OFF
return 1
 
ERR_HANDLER:
print('--- Ending SF_ReplicateLarge. Operation FAILED.')
set @LogMessage = 'Ending - Operation Failed.' 
exec SF_Logger @SPName,N'Failed', @LogMessage
RAISERROR ('--- Ending SF_ReplicateLarge. Operation FAILED.',16,1)
set NOCOUNT OFF
return 1
 


