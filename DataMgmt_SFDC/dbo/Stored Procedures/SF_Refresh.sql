
CREATE PROCEDURE [dbo].[SF_Refresh]
	@table_server sysname,
	@table_name sysname,
	@schema_error_action varchar(100) = 'no',
	@verify_action varchar(100) = 'no',
	@bulkapi_option varchar(100) = null
AS
-- NOTE: This stored procedure will not work on SQL 2000.
--
-- Parameters: @table_server           - Salesforce Linked Server name (i.e. SALESFORCE)
--             @table_name             - Salesforce object to copy (i.e. Account)
--             @schema_error_action    - Controls the action for a schema change 
--                                     -    'No' : FAIL on a schema change
--                                     -    'Yes' : The table will be replicated instead
--                                     -    'Subset' : The new columns are ignored and the current
--                                                     subset of local table columns are refreshed.
--                                     -               Columns deleted on salesforce ARE NOT deleted locally. 
--                                     -    'SubsetDelete' : The new columns are ignored and the current
--                                                     subset of local table columns are refreshed.
--                                     -               Columns deleted on salesforce ARE deleted locally. 
--									   -    'Repair' :  The Max(SystemModStamp of the local table is used and 
--                                                      alternate method of handling deletes is used (slower)
--             @verify_action		   - Controls the row count compare behavior
--                                     -    'No' : Do not compare row counts
--                                     -    'Warn' : Compare row counts and issue warning if different
--                                     -    'Fail' : Compare row counts and fail the proc if different
--             @bulkapi_option  		- Options for using the bulkapi for the delta table
--    

-- @ProgDir - Directory containing the DBAmp.exe. Defaults to the DBAmp program directory
-- If needed, modify this for your installation
declare @ProgDir   	varchar(250) 
set @ProgDir = 'C:\"Program Files"\DBAmp\'

declare @Command 	nvarchar(4000)
declare @Result 	int
declare @sql		nvarchar(max)
declare @parmlist	nvarchar(4000)
declare @columnList nvarchar(max)
declare @deletecolumnList nvarchar(max)
declare @colname	nvarchar(500)
declare @time_now	char(8)
set NOCOUNT ON

print '--- Starting SF_Refresh for ' + @table_name + ' ' +  dbo.SF_Version()
declare @LogMessage nvarchar(max)
declare @SPName nvarchar(50)
set @SPName = 'SF_Refresh:' + Convert(nvarchar(255), NEWID(), 20)
set @LogMessage = 'Parameters: ' + @table_server + ' ' + @table_name + ' '+ @schema_error_action + ' ' 
set @LogMessage = @LogMessage + ' ' + @verify_action + ' '+ ISNULL(@bulkapi_option, ' ') + ' Version: ' +  dbo.SF_Version()
exec SF_Logger @SPName, N'Starting', @LogMessage

declare @delim_table_name sysname
declare @refresh_table sysname
declare @delim_refresh_table sysname
declare @delta_table sysname
declare @delim_delta_table sysname
declare @deleted_table sysname
declare @deleted_table_ts sysname
declare @delim_deleted_table sysname

declare @server sysname
declare @database sysname
declare @timestamp_col_name nvarchar(2000)
declare @is_history_table int
declare @diff_schema_count int



set @schema_error_action = Lower(@schema_error_action)
set @verify_action = Lower(@verify_action)
Select @time_now = (select Convert(char(8),CURRENT_TIMESTAMP, 8))

-- Validate parameters
if  @schema_error_action is null
   begin
	  print @time_now + ': Error: Invalid Schema Action Parameter: Cannot be Null ' 
	  set @LogMessage = 'Error: Invalid Schema Action Parameter: Cannot be Null'
	  exec SF_Logger @SPName, N'Message', @LogMessage
  	  GOTO ERR_HANDLER
   end
if  @schema_error_action <> 'yes' and
    @schema_error_action <> 'no' and
     @schema_error_action <> 'subset' and
     @schema_error_action <> 'repair' and
      @schema_error_action <> 'subsetdelete' 
   begin
	  print @time_now + ': Error: Invalid Schema Action Parameter: ' + @schema_error_action
	  set @LogMessage = 'Error: Invalid Schema Action Parameter: ' + @schema_error_action
	  exec SF_Logger @SPName, N'Message', @LogMessage
  	  GOTO ERR_HANDLER
   end
   
if @schema_error_action <> 'no'
begin
	print @time_now + ': Using Schema Error Action of ' + @schema_error_action
	set @LogMessage = 'Using Schema Error Action of ' + @schema_error_action
	exec SF_Logger @SPName, N'Message', @LogMessage
end

if  @verify_action <> 'no' and
    @verify_action <> 'warn' and
     @verify_action <> 'fail' 
   begin
	  print @time_now + ': Error: Invalid Verify Action Parameter: ' + @verify_action
	  set @LogMessage = 'Error: Invalid Verify Action Parameter: ' + @verify_action
	  exec SF_Logger @SPName, N'Message', @LogMessage
  	  GOTO ERR_HANDLER
   end

-- Put delimeters around names so we can name tables User, etc...
set @delim_table_name = '[' + @table_name + ']'
set @refresh_table = 'TableRefreshTime'
set @delim_refresh_table = '[' + @refresh_table + ']'
set @delta_table = @table_name + '_Delta' + CONVERT(nvarchar(30), GETDATE(), 126) 
set @delim_delta_table = '[' + @delta_table + ']'
set @deleted_table = @table_name + '_Deleted'
set @deleted_table_ts = @deleted_table + CONVERT(nvarchar(30), GETDATE(), 126)
set @delim_deleted_table = '[' + @deleted_table_ts + ']'


-- Determine whether the local table and the previous copy exist
declare @table_exist int
declare @refresh_exist int
declare @delta_exist int
declare @deleted_exist int
declare @char_count varchar(10)

set @table_exist = 0
IF EXISTS (SELECT 1
    FROM INFORMATION_SCHEMA.TABLES
    WHERE TABLE_TYPE='BASE TABLE' 
    AND TABLE_NAME=@table_name)
        set @table_exist = 1
IF (@@ERROR <> 0) GOTO ERR_HANDLER

-- Create table to track refresh times
set @refresh_exist = 0
IF EXISTS (SELECT 1
    FROM INFORMATION_SCHEMA.TABLES
    WHERE TABLE_TYPE='BASE TABLE' 
    AND TABLE_NAME=@refresh_table)
        set @refresh_exist = 1
IF (@@ERROR <> 0) GOTO ERR_HANDLER
if (@refresh_exist = 0)
begin
   exec ('Create Table ' + @refresh_table + ' (TblName nvarchar(255) null, LastRefreshTime datetime null default CURRENT_TIMESTAMP) ')
   IF (@@ERROR <> 0) GOTO ERR_HANDLER
end

--Validate if object exists on Salesforce
declare @sf_obj_exists int
exec @sf_obj_exists =  SF_IsValidSFObject @table_server,@table_name
if @sf_obj_exists = 0
Begin
	Select @time_now = (select Convert(char(8),CURRENT_TIMESTAMP, 8))
	print @time_now + ': Error: Salesforce table does not exist: ' + @table_name
	set @LogMessage = 'Error: Salesforce table does not exist: ' + @table_name
	exec SF_Logger @SPName, N'Message', @LogMessage
	GOTO ERR_HANDLER
End


-- If table does not exist then replicate it
if (@table_exist = 0)
begin
	Select @time_now = (select Convert(char(8),CURRENT_TIMESTAMP, 8))
	print @time_now + ': Local table does not exist. Using SF_Replicate to create the local table.'
	set @LogMessage = 'Local table does not exist. Using SF_Replicate to create the local table.'
	exec SF_Logger @SPName, N'Message', @LogMessage
	goto REPLICATE_EXIT
end

-- Get the flags from DBAmp for this table
declare @replicateable char(5)
declare @deletable char(5)
select @sql = 'Select @DFOUT = Deletable, @RFOUT = Replicateable,@TSOUT = TimestampField from ' 
select @sql = @sql + @table_server + '...sys_sfobjects where Name ='''
select @sql = @sql + @table_name + ''''
select @parmlist = '@DFOUT char(5) OUTPUT, @RFOUT char(5) OUTPUT, @TSOUT char(50) OUTPUT'
exec sp_executesql @sql,@parmlist, @DFOUT = @deletable OUTPUT, @RFOUT=@replicateable OUTPUT,@TSOUT=@timestamp_col_name OUTPUT
IF (@@ERROR <> 0) GOTO ERR_HANDLER

--print @timestamp_col_name
if (@timestamp_col_name = 'CreatedDate') 
begin
	set @is_history_table = 1
end
else if (@timestamp_col_name = 'SystemModstamp')
begin
	set @is_history_table = 0
end
else
begin
	-- Cannot do a normal refresh because the table has no timestamp column
  	Select @time_now = (select Convert(char(8),CURRENT_TIMESTAMP, 8))
	print @time_now + ': Table does not contain a timestamp column needed to refresh. Using SF_Replicate to create table.'
	set @LogMessage = 'Table does not contain a timestamp column needed to refresh. Using SF_Replicate to create table.'
	exec SF_Logger @SPName, N'Message', @LogMessage
	goto REPLICATE_EXIT
end

-- Get the last refresh time from the refresh table
-- This serves as the 'last run' time for the refresh
-- We subtract 30 mins to allow for long units of work on the salesforce side
declare @last_time smalldatetime
declare @table_crtime smalldatetime

-- Get create time of the base table. This is the last replicate time
select @table_crtime = DATEADD(mi,-30,crdate) FROM sysobjects WHERE name = @table_name and xtype='U'

-- Get the latest timestamp from the Refresh table
select @sql = 'Select @LastTimeOUT = DATEADD(mi,-30,LastRefreshTime) from ' + @refresh_table 
select @sql = @sql + ' where TblName= ''' + @table_name + ''''
select @parmlist = '@LastTimeOUT datetime OUTPUT'
exec sp_executesql @sql,@parmlist, @LastTimeOUT=@last_time OUTPUT
IF (@@ERROR <> 0 OR @last_time is null)
begin
	set @last_time = @table_crtime
end

if (@schema_error_action = 'repair')
begin
	-- Get the latest timestamp from the local table itself
	select @sql = 'Select @LastTimeOUT = DATEADD(mi,-30,MAX(' + @timestamp_col_name + ')) from ' + @delim_table_name 
	select @parmlist = '@LastTimeOUT datetime OUTPUT'
	--print @sql
	exec sp_executesql @sql,@parmlist, @LastTimeOUT=@last_time OUTPUT
	IF (@@ERROR <> 0 OR @last_time is null)
	begin
		set @last_time = @table_crtime
	end
end


-- if the last refresh time was before the last replicate time, use the last replicate time instead
if (@last_time < @table_crtime) and (@schema_error_action != 'repair')
   set @last_time = @table_crtime

-- Get the NoTimeZoneConversion flag from DBAmp
declare @noTimeZoneConversion char(5)
select @sql = 'Select @TZOUT = NoTimeZoneConversion from ' 
select @sql = @sql + @table_server + '...sys_sfsession'
select @parmlist = '@TZOUT char(5) OUTPUT'
exec sp_executesql @sql,@parmlist, @TZOUT=@noTimeZoneConversion OUTPUT
IF (@@ERROR <> 0) GOTO ERR_HANDLER

-- If NoTimeZoneConversion is true then convert last_time to GMT
if (@noTimeZoneConversion = 'true')
begin
  	Select @time_now = (select Convert(char(8),CURRENT_TIMESTAMP, 8))
	print @time_now + ': DBAmp is using GMT for all datetime calculations.'
	SET @last_time = DATEADD(Hour, DATEDIFF(Hour, GETDATE(), GETUTCDATE()), @last_time)
end

Select @time_now = (select Convert(char(8),CURRENT_TIMESTAMP, 8))
print @time_now + ': Using last run time of ' + Convert(nvarchar(24),@last_time,120)
set @LogMessage = 'Using last run time of ' + Convert(nvarchar(24),@last_time,120) 
exec SF_Logger @SPName,N'Message', @LogMessage

-- If the delta table exists, drop it
set @delta_exist = 0;
IF EXISTS (SELECT 1
    FROM INFORMATION_SCHEMA.TABLES
    WHERE TABLE_TYPE='BASE TABLE'
    AND TABLE_NAME=@delta_table)
        set @delta_exist = 1
IF (@@ERROR <> 0) GOTO ERR_HANDLER

if (@delta_exist = 1)
        exec ('Drop table ' + @delim_delta_table)
IF (@@ERROR <> 0) GOTO ERR_HANDLER

-- Retrieve current server name and database
select @server = @@servername, @database = DB_NAME()
SET @server = CAST(SERVERPROPERTY('ServerName') AS sysname) 


-- Create an empty local table with the current structure of the Salesforce object
Select @time_now = (select Convert(char(8),CURRENT_TIMESTAMP, 8))
--print @time_now + ': Create ' + @delta_table + ' with new structure.'
Select @sql = 'Select Top 0 * into ' + @delim_delta_table + ' from ' + @table_server + '...' + @delim_table_name 
begin try
	exec sp_executesql @sql
end try
begin catch
	Select @time_now = (select Convert(char(8),CURRENT_TIMESTAMP, 8))
	print @time_now + ': Error when creating delta table. ' + ERROR_MESSAGE()
	set @LogMessage = 'Error when creating delta table. ' + ERROR_MESSAGE()
	exec SF_Logger @SPName, N'Message', @LogMessage 
	GOTO ERR_HANDLER
end catch

-- Remember query time as the the start of the interval
declare @queryTime datetime
select @queryTime = (Select CURRENT_TIMESTAMP)

-- Populate new delta table with updated rows	
if @bulkapi_option is null
begin
	select @sql = 'Insert ' + @delim_delta_table + ' Select * from ' + @table_server + '...' + @delim_table_name + ' where ' + @timestamp_col_name + ' > @LastTimeIN'
	select @parmlist = '@LastTimeIN datetime'
	exec sp_executesql @sql, @parmlist, @LastTimeIN=@last_time
	IF (@@ERROR <> 0) GOTO ERR_HANDLER
end
else
begin
	-- Use bulkapi
	-- Execute DBAmp.exe to query using the bulkapi
	Select @time_now = (select Convert(char(8),CURRENT_TIMESTAMP, 8))
	print @time_now + ': Run the DBAmp.exe program.'
	set @LogMessage = 'Run the DBAmp.exe program.'
	exec SF_Logger @SPName, N'Message', @LogMessage
	set @Command = @ProgDir + 'DBAmp.exe ExportBulk' 
	set @Command = @Command + ':' + @bulkapi_option
	set @Command = @Command + ' "' + @delta_table + '" '
	set @Command = @Command + ' "' + @server + '" '
	set @Command = @Command + ' "' + @database + '" '
	set @Command = @Command + ' "' + @table_server + '" '
	-- Add where clause
	set @Command = @Command + ' "where ' + RTRIM(@timestamp_col_name) +'>' + Convert(nvarchar(24),@last_time,120) + '" '
	
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
   		--set @errorLines = @errorLines + @line
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
  		GOTO ERR_HANDLER
	END
end

-- Delete any overlap rows in the delta table
-- These are rows we've already synched but got picked up due to the 10 min sliding window
select @sql = 'delete ' + @delim_delta_table + ' where exists '
select @sql = @sql + '(select Id from ' + @delim_table_name + ' where Id= ' + @delim_delta_table +'.Id '
if @table_name = 'OpportunityHistory'
begin
	select @sql = @sql + ')'
end
else
begin
	select @sql = @sql + ' and ' + @timestamp_col_name + ' = ' + @delim_delta_table + '.' + @timestamp_col_name + ')'
end
exec sp_executesql @sql
IF (@@ERROR <> 0) GOTO ERR_HANDLER

-- Get the count of records from the delta table
declare @delta_count int
select @sql = 'Select @DeltaCountOUT = Count(*) from ' + @delim_delta_table
select @parmlist = '@DeltaCountOUT int OUTPUT'
exec sp_executesql @sql,@parmlist, @DeltaCountOUT=@delta_count OUTPUT
IF (@@ERROR <> 0) GOTO ERR_HANDLER

-- Print number of rows in delta table
Select @time_now = (select Convert(char(8),CURRENT_TIMESTAMP, 8))
Select @char_count = (select CAST(@delta_count as VARCHAR(10)))
print @time_now + ': Identified ' + @char_count + ' updated/inserted rows.'

set @LogMessage = 'Identified ' + @char_count + ' updated/inserted rows.'
exec SF_Logger @SPName, N'Message',@LogMessage

-- If no records have changed then move on to deletes
if (@delta_count = 0) goto DELETE_PROCESS

-- Check to see if the column structure is the same
declare @cnt1 int
declare @cnt2 int
Select @cnt1 = Count(*) FROM INFORMATION_SCHEMA.COLUMNS v1 WHERE v1.TABLE_NAME=@delta_table 
		AND NOT EXISTS (Select COLUMN_NAME from INFORMATION_SCHEMA.COLUMNS v2 
		Join INFORMATION_SCHEMA.TABLES t1
		On v2.TABLE_NAME = t1.TABLE_NAME and t1.TABLE_SCHEMA = v2.TABLE_SCHEMA
		where (t1.TABLE_TYPE = 'BASE TABLE') and
		v2.TABLE_NAME=@table_name and v1.COLUMN_NAME = v2.COLUMN_NAME and v1.DATA_TYPE = v2.DATA_TYPE 
		and v1.IS_NULLABLE = v2.IS_NULLABLE and v1.ORDINAL_POSITION = v2.ORDINAL_POSITION 
		and ISNULL(v1.CHARACTER_MAXIMUM_LENGTH,0) = ISNULL(v2.CHARACTER_MAXIMUM_LENGTH,0))
IF (@@ERROR <> 0) GOTO ERR_HANDLER

Select @cnt2 = Count(*) FROM INFORMATION_SCHEMA.COLUMNS v1
		Join INFORMATION_SCHEMA.TABLES t1
		On v1.TABLE_NAME = t1.TABLE_NAME and t1.TABLE_SCHEMA = v1.TABLE_SCHEMA
		WHERE (t1.TABLE_TYPE = 'BASE TABLE') and v1.TABLE_NAME=@table_name 
		AND NOT EXISTS (Select COLUMN_NAME from INFORMATION_SCHEMA.COLUMNS v2 where 
		v2.TABLE_NAME=@delta_table and v1.COLUMN_NAME = v2.COLUMN_NAME and v1.DATA_TYPE = v2.DATA_TYPE 
		and v1.IS_NULLABLE = v2.IS_NULLABLE and v1.ORDINAL_POSITION = v2.ORDINAL_POSITION 
		and ISNULL(v1.CHARACTER_MAXIMUM_LENGTH,0) = ISNULL(v2.CHARACTER_MAXIMUM_LENGTH,0))
IF (@@ERROR <> 0) GOTO ERR_HANDLER

set @diff_schema_count = @cnt1 + @cnt2

if (@diff_schema_count > 0)
begin
	Select @time_now = (select Convert(char(8),CURRENT_TIMESTAMP, 8))
	
		Select v1.COLUMN_NAME into #Test1 FROM INFORMATION_SCHEMA.COLUMNS v1 WHERE v1.TABLE_NAME=@delta_table 
		And v1.COLUMN_NAME Not in (Select COLUMN_NAME from INFORMATION_SCHEMA.COLUMNS v2 
		Join INFORMATION_SCHEMA.TABLES t1
		On v2.TABLE_NAME = t1.TABLE_NAME and t1.TABLE_SCHEMA = v2.TABLE_SCHEMA
		where (t1.TABLE_TYPE = 'BASE TABLE') and 
		v2.TABLE_NAME=@table_name and v1.COLUMN_NAME = v2.COLUMN_NAME and v1.DATA_TYPE = v2.DATA_TYPE 
		and v1.IS_NULLABLE = v2.IS_NULLABLE
		and ISNULL(v1.CHARACTER_MAXIMUM_LENGTH,0) = ISNULL(v2.CHARACTER_MAXIMUM_LENGTH,0))

		Select v1.COLUMN_NAME into #Test2 FROM INFORMATION_SCHEMA.COLUMNS v1 
		Join INFORMATION_SCHEMA.TABLES t1
		On v1.TABLE_NAME = t1.TABLE_NAME and t1.TABLE_SCHEMA = v1.TABLE_SCHEMA
		WHERE (t1.TABLE_TYPE = 'BASE TABLE') and v1.TABLE_NAME=@table_name 
		AND v1.COLUMN_NAME not in (Select COLUMN_NAME from INFORMATION_SCHEMA.COLUMNS v2 where 
		v2.TABLE_NAME=@delta_table and v1.COLUMN_NAME = v2.COLUMN_NAME and v1.DATA_TYPE = v2.DATA_TYPE 
		and v1.IS_NULLABLE = v2.IS_NULLABLE 
		and ISNULL(v1.CHARACTER_MAXIMUM_LENGTH,0) = ISNULL(v2.CHARACTER_MAXIMUM_LENGTH,0))

	  declare @ColumnName sysname

	  declare ColumnCompare_cursor cursor 
	  for 
		 select a.COLUMN_NAME from #Test1 a

	  open ColumnCompare_cursor

	  while 1 = 1
	  begin
	  fetch next from ColumnCompare_cursor into @ColumnName
		if @@error <> 0 or @@fetch_status <> 0 break
		    begin
				print @time_now + ': Error: ' + @ColumnName + ' exists in the delta table but does not exist in the local table or has a different definition.'
				set @LogMessage = 'Error: ' + @ColumnName + ' exists in the delta table but does not exist in the local table or has a different definition.'
				exec SF_Logger @SPName, N'Message',@LogMessage
			end
	  end

	  close ColumnCompare_cursor
	  deallocate ColumnCompare_cursor

	  declare ColumnCompare2_cursor cursor 
	  for 	
	     select a.COLUMN_NAME from #Test2 a

	  open ColumnCompare2_cursor

	  while 1 = 1
	  begin
	  fetch next from ColumnCompare2_cursor into @ColumnName
		if @@error <> 0 or @@fetch_status <> 0 break
		    begin
				print @time_now + ': Error: ' + @ColumnName + ' exists in the local table but does not exist in the delta table or has a different definition.'
				set @LogMessage = 'Error: ' + @ColumnName + ' exists in the local table but does not exist in the delta table or has a different definition.'
				exec SF_Logger @SPName, N'Message',@LogMessage
			end
	  end

	  close ColumnCompare2_cursor
	  deallocate ColumnCompare2_cursor
	  
	if (@schema_error_action = 'yes')
	begin
		print @time_now + ': Table schema has changed. The table will be replicated instead.'
		set @LogMessage = 'Table schema has changed. The table will be replicated instead.'
		exec SF_Logger @SPName, N'Message', @LogMessage
		exec ('Drop table ' + @delim_delta_table)
		goto REPLICATE_EXIT
	end
   
   if (@schema_error_action = 'no')
   begin
	  print @time_now + ': Error: Table schema has changed and therefore the table cannot be refreshed.'
	  set @LogMessage = 'Error: Table schema has changed and therefore the table cannot be refreshed.'
	  exec SF_Logger @SPName, N'Message',@LogMessage
	  exec ('Drop table ' + @delim_delta_table)
  	  GOTO ERR_HANDLER
   end
   
    -- Schema changed so try to build a subset of columns
	-- Build list of columns in common
	declare colname_cursor cursor for 
		SELECT COLUMN_NAME FROM INFORMATION_SCHEMA.COLUMNS v1 WHERE v1.TABLE_NAME= @table_name 
		AND EXISTS (Select COLUMN_NAME from INFORMATION_SCHEMA.COLUMNS v2 
		where v2.TABLE_NAME= @delta_table 
		and v1.COLUMN_NAME = v2.COLUMN_NAME and v1.DATA_TYPE = v2.DATA_TYPE and v1.IS_NULLABLE = v2.IS_NULLABLE 
		and ISNULL(v1.CHARACTER_MAXIMUM_LENGTH,0)= ISNULL(v2.CHARACTER_MAXIMUM_LENGTH,0))

	OPEN colname_cursor
	set @columnList = ''
	
	while 1 = 1
	begin
		fetch next from colname_cursor into @colname
		if @@error <> 0 or @@fetch_status <> 0 break
		set @columnList = @columnList + @colname + ','
	end
	close colname_cursor
	deallocate colname_cursor

	if Len(@columnList) = 0
	begin
		print @time_now + ': Error: Table schema has changed with no columns in common. Therefore the table cannot be refreshed.'
		set @LogMessage = 'Error: Table schema has changed with no columns in common. Therefore the table cannot be refreshed.'
		exec SF_Logger @SPName, N'Message', @LogMessage
		exec ('Drop table ' + @delim_delta_table)
		GOTO ERR_HANDLER
	end
					
	SET @columnList = SUBSTRING(@columnList, 1, Len(@columnList) - 1)

	-- Build list of columns that need to deleted in the local table
	declare colname_cursor cursor for 
		SELECT COLUMN_NAME FROM INFORMATION_SCHEMA.COLUMNS v1 WHERE v1.TABLE_NAME= @table_name 
		AND not EXISTS (Select COLUMN_NAME from INFORMATION_SCHEMA.COLUMNS v2 
		where v2.TABLE_NAME= @delta_table 
		and v1.COLUMN_NAME = v2.COLUMN_NAME )

	OPEN colname_cursor
	set @deletecolumnList = ''
	while 1 = 1
	begin
		fetch next from colname_cursor into @colname
		if @@error <> 0 or @@fetch_status <> 0 break
		set @deletecolumnList = @deletecolumnList + @colname + ','
	end
	close colname_cursor
	deallocate colname_cursor

	if Len(@deletecolumnList) > 0
	begin
		SET @deletecolumnList = SUBSTRING(@deletecolumnList, 1, Len(@deletecolumnList) - 1)
	end
					
	print @time_now + ': Warning: Table schema has changed. SF_Refresh will use the valid subset of columns.'
	set @LogMessage = 'Warning: Table schema has changed. SF_Refresh will use the valid subset of columns.'
	exec SF_Logger @SPName, N'Message', @LogMessage
end

DELETE_PROCESS:
-- Skip deleted stuff for nondeleteable tables
-- Commented out to allow correct operation for read only users
--if (@deletable = 'false') goto SKIPDELETED

-- If the deleted table exists, drop it and recreate it
set @deleted_exist = 0;
IF EXISTS (SELECT 1
    FROM INFORMATION_SCHEMA.TABLES
    WHERE TABLE_TYPE='BASE TABLE'
    AND TABLE_NAME=@deleted_table_ts)
        set @deleted_exist = 1
IF (@@ERROR <> 0) GOTO ERR_HANDLER

if (@deleted_exist = 1)
        exec ('Drop table ' + @delim_deleted_table)
IF (@@ERROR <> 0) GOTO ERR_HANDLER

select @sql = 'Create table ' +  @delim_deleted_table
select @sql = @sql + ' (Id nchar(18) null ) '
exec (@sql)
IF (@@ERROR <> 0) GOTO ERR_HANDLER

if (@replicateable = 'true') and (@schema_error_action != 'repair')
begin
	-- Object supports GetDelete api so use it to retrieve deleted ids
	select @sql = 'Insert ' + @delim_deleted_table + ' Select * from openquery(' 
	select @sql = @sql + @table_server + ',''Select Id from ' + @deleted_table 
	select @sql = @sql + ' where startdate=''''' + Convert(nvarchar(24),@last_time,120) + ''''''')' 
	--print @sql

BEGIN TRY
	   	exec (@sql)
END TRY
BEGIN CATCH
	Select @time_now = (select Convert(char(8),CURRENT_TIMESTAMP, 8))
	print @time_now + ': Error occurred fetching deleted rows.'	
	set @LogMessage = 'Error occurred fetching deleted rows.'
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
     Select @time_now = (select Convert(char(8),CURRENT_TIMESTAMP, 8))
	if (@schema_error_action = 'yes')
	begin
		print @time_now + ': Error occurred while fetching deleted rows. The table will be replicated instead.'
		set @LogMessage = 'Error occurred while fetching deleted rows. The Table will be replicated instead.'
		exec SF_Logger @SPName, N'Message', @LogMessage
		goto REPLICATE_EXIT
	end
	else
	begin
     goto ERR_HANDLER
    end
END CATCH

end
else
begin
	-- Use alternate method to discover deleted id's
	Select @time_now = (select Convert(char(8),CURRENT_TIMESTAMP, 8))
	print @time_now + ': Using alternate method to determine deleted records.' 
	set @LogMessage = 'Using alternate method to determine deleted records.'
	exec SF_Logger @SPName, N'Message', @LogMessage
	-- Create new deleted table for non-replicatable tables
	select @sql = 'Insert ' + @delim_deleted_table + ' Select Id from ' + @delim_table_name
	select @sql = @sql + ' where Id not in (select Id from ' + @table_server + '...' + @delim_table_name + ')'
	exec sp_executesql @sql
	IF (@@ERROR <> 0) GOTO ERR_HANDLER
end

-- Delete any rows in the deleted table that already have been deleted
-- These are rows we've already synched but got picked up due to the 10 min sliding window
select @sql = 'delete ' + @delim_deleted_table + ' where not exists '
select @sql = @sql + '(select Id from ' + @delim_table_name + ' where Id= ' + @delim_deleted_table +'.Id)'
exec sp_executesql @sql
IF (@@ERROR <> 0) GOTO ERR_HANDLER

-- Get the count of records from the deleted table
declare @deleted_count int
select @sql = 'Select @DeletedCountOUT = Count(*) from ' + @delim_deleted_table
select @parmlist = '@DeletedCountOUT int OUTPUT'
exec sp_executesql @sql,@parmlist, @DeletedCountOUT=@deleted_count OUTPUT
IF (@@ERROR <> 0) GOTO ERR_HANDLER

-- Print number of rows in deleted table
Select @time_now = (select Convert(char(8),CURRENT_TIMESTAMP, 8))
Select @char_count = (select CAST(@deleted_count as VARCHAR(10)))
print @time_now + ': Identified ' + @char_count + ' deleted rows.'

set @LogMessage = 'Identified ' + @char_count + ' deleted rows.'
exec SF_Logger @SPName,N'Message', @LogMessage

if (@deleted_count <> 0)
begin
	-- Delete rows from local table that exist in deleted table
	Select @time_now = (select Convert(char(8),CURRENT_TIMESTAMP, 8))
	print @time_now + ': Removing deleted rows from ' + @table_name 
	set @LogMessage = 'Removing deleted rows from ' + @table_name
	exec SF_Logger @SPName, N'Message', @LogMessage

	select @sql = 'delete ' + @delim_table_name + ' where Id IN (select Id from ' + @delim_deleted_table + ' )'
	exec sp_executesql @sql
	IF (@@ERROR <> 0) GOTO ERR_HANDLER
end

SKIPDELETED:
if (@delta_count > 0)
begin
	BEGIN TRAN
	Select @time_now = (select Convert(char(8),CURRENT_TIMESTAMP, 8))
	print @time_now + ': Adding updated/inserted rows into ' + @table_name 
	set @LogMessage = 'Adding updated/inserted rows into ' + @table_name
	exec SF_Logger @SPName, N'Message', @LogMessage
	
	if @is_history_table = 0 
	begin
		-- Delete rows from local table that exist in delta table
		-- History tables skip this step because updates are not allowed
		select @sql = 'delete ' + @delim_table_name + ' where Id IN (select Id from ' + @delim_delta_table + ' )'
		exec sp_executesql @sql
		IF (@@ERROR <> 0) 
		begin
		   ROLLBACK
		   GOTO ERR_HANDLER
		end
	end
	
	-- Insert delta rows into local table
	if (@diff_schema_count > 0 )
	begin
		if Len(@deletecolumnList) > 0 and @schema_error_action = 'subsetdelete'
		begin
			-- Remove any deleted columns
			Select @time_now = (select Convert(char(8),CURRENT_TIMESTAMP, 8))
			print @time_now + ': Removing the following deleted columns ' + @deletecolumnList
			set @LogMessage = 'Removing the following deleted columns ' + @deletecolumnList
			exec SF_Logger @SPName, N'Message', @LogMessage
			 
			select @sql = 'alter table ' + @delim_table_name + ' drop column ' + @deletecolumnList	
			exec sp_executesql @sql
			IF (@@ERROR <> 0) 
			begin
			   ROLLBACK
			   GOTO ERR_HANDLER
			end
		end
			
		-- Now insert the new rows
		select @sql = 'insert ' + @delim_table_name + '(' + @columnList + ')' 
					+ ' select ' + @columnList + ' from ' + @delim_delta_table
		exec sp_executesql @sql
		IF (@@ERROR <> 0) 
		begin
		   ROLLBACK
		   GOTO ERR_HANDLER
		end
	end
	else
	begin
		select @sql = 'insert ' + @delim_table_name + ' select * from ' + @delim_delta_table
		exec sp_executesql @sql
		IF (@@ERROR <> 0) 
		begin
		   ROLLBACK
		   GOTO ERR_HANDLER
		end
	end
		
	COMMIT
end
	
SUCCESS:
-- Reset Last Refresh in the Refresh table for this object
exec ('delete ' + @refresh_table + ' where TblName =''' + @table_name + '''')
select @sql = 'insert into ' + @refresh_table + '(TblName,LastRefreshTime) Values(''' + @table_name + ''',''' + Convert(nvarchar(24),@queryTime,126) +''')'
--print @sql
exec sp_executesql @sql

-- We don't need the deleted and delta tables so drop them
exec ('Drop table ' + @delim_deleted_table)
exec ('Drop table ' + @delim_delta_table)

-- Report row count difference
declare @differ_count int
select @sql = 'Select @DifferCountOUT = Count(Id)-min(expr0) from ' + @delim_table_name
select @sql = @sql + ' ,openquery(' + @table_server + ',''Select Count(Id) from ' + @table_name + ' '')'
select @parmlist = '@DifferCountOUT int OUTPUT'

if  @verify_action <> 'no' 
begin
	exec sp_executesql @sql,@parmlist, @DifferCountOUT=@differ_count OUTPUT
	IF (@@ERROR = 0)
	Begin
	   if @differ_count <> 0 
		  begin
			Select @time_now = (select Convert(char(8),CURRENT_TIMESTAMP, 8))
			declare @action varchar(100)
		    if  @verify_action = 'warn' 
				set @action = 'Warning'
		    else set @action = 'Error'
			print @time_now + ': ' + @action + ': The row counts of the local table and salesforce differ by ' + Cast(@differ_count as varchar(10)) + ' rows.'
			set @LogMessage = @action + ': The row counts of the local table and salesforce differ by ' + Cast(@differ_count as varchar(10)) + ' rows.'
			exec SF_Logger @SPName,N'Message', @LogMessage			
			-- Fail the proc if user requested
			if @verify_action = 'fail'
			   RAISERROR ('--- Ending SF_Refresh. Operation FAILED.',16,1)
		  end
	End
End

print '--- Ending SF_Refresh. Operation successful.'
set @LogMessage = 'Ending - Operation Successful.' 
exec SF_Logger @SPName,N'Successful', @LogMessage
set NOCOUNT OFF
return 0

ERR_HANDLER:
-- We don't need the deleted and delta tables so drop them
IF EXISTS (SELECT 1
    FROM INFORMATION_SCHEMA.TABLES
    WHERE TABLE_TYPE='BASE TABLE'
    AND TABLE_NAME=@deleted_table_ts)
begin
   exec ('Drop table ' + @delim_deleted_table)
end

IF EXISTS (SELECT 1
    FROM INFORMATION_SCHEMA.TABLES
    WHERE TABLE_TYPE='BASE TABLE'
    AND TABLE_NAME=@delta_table)
begin
   exec ('Drop table ' + @delim_delta_table)
end
print('--- Ending SF_Refresh. Operation FAILED.')
set @LogMessage = 'Ending - Operation Failed.' 
exec SF_Logger @SPName,N'Failed', @LogMessage
RAISERROR ('--- Ending SF_Refresh. Operation FAILED.',16,1)
set NOCOUNT OFF
return 1

REPLICATE_EXIT:
-- We don't need the deleted and delta tables so drop them
IF EXISTS (SELECT 1
    FROM INFORMATION_SCHEMA.TABLES
    WHERE TABLE_TYPE='BASE TABLE'
    AND TABLE_NAME=@deleted_table_ts)
begin
   exec ('Drop table ' + @delim_deleted_table)
end

IF EXISTS (SELECT 1
    FROM INFORMATION_SCHEMA.TABLES
    WHERE TABLE_TYPE='BASE TABLE'
    AND TABLE_NAME=@delta_table)
begin
   exec ('Drop table ' + @delim_delta_table)
end

set @LogMessage = 'Ending - Branching to SF_Replicate.' 
exec SF_Logger @SPName, N'Failed',@LogMessage
exec SF_Replicate @table_server, @table_name
set NOCOUNT OFF
return 0

