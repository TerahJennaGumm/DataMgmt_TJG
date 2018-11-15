﻿
CREATE PROCEDURE [dbo].[SF_RefreshIAD]
	@table_server sysname,
	@table_name sysname,
	@schema_error_action varchar(100) = 'no'
AS
-- Parameters: @table_server           - Salesforce Linked Server name (i.e. SALESFORCE)
--             @table_name             - Salesforce object to copy (i.e. Account)
--             @schema_error_action    - Controls the action for a schema change 
--                                     -    'No' : FAIL on a schema change
--                                     -    'Yes' : The table will be replicated instead
--                                     -    'Subset' : The new columns are ignored and the current
--                                                     subset of local table columns are refreshed.
--                                     -               Columns deleted on salesforce ARE NOT deleted locally. 

declare @Result 	int
declare @Command 	nvarchar(max)
declare @sql		nvarchar(max)
declare @parmlist	nvarchar(4000)
declare @columnList nvarchar(max)
declare @deletecolumnList nvarchar(max)
declare @colname	nvarchar(500)
declare @time_now	char(8)
set NOCOUNT ON

print '--- Starting SF_RefreshIAD for ' + @table_name + ' ' +  dbo.SF_Version()
declare @LogMessage nvarchar(max)
declare @SPName nvarchar(50)
set @SPName = 'SF_RefreshIAD:' + Convert(nvarchar(255), NEWID(), 20)
set @LogMessage = 'Parameters: ' + @table_server + ' ' + @table_name + ' ' + @schema_error_action + ' ' + ' Version: ' +  dbo.SF_Version()
exec SF_Logger @SPName, N'Starting', @LogMessage

declare @delim_table_name sysname
declare @refresh_table sysname
declare @delim_refresh_table sysname
declare @delta_table sysname
declare @delim_delta_table sysname
declare @deleted_table sysname
declare @delim_deleted_table sysname
declare @queryall_table sysname
declare @delim_queryall_table sysname

declare @server sysname
declare @database sysname
declare @timestamp_col_name nvarchar(2000)
declare @is_history_table int
declare @diff_schema_count int

set @schema_error_action = Lower(@schema_error_action)

Select @time_now = (select Convert(char(8),CURRENT_TIMESTAMP, 8))

-- Validate parameters
if  @schema_error_action <> 'yes' and
    @schema_error_action <> 'no' and
     @schema_error_action <> 'subset' 
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


-- Put delimeters around names so we can name tables User, etc...
set @delim_table_name = '[' + @table_name + ']'
set @refresh_table = 'TableRefreshTime'
set @delim_refresh_table = '[' + @refresh_table + ']'
set @delta_table = @table_name + '_Delta' + CONVERT(nvarchar(30), GETDATE(), 126) 
set @delim_delta_table = '[' + @delta_table + ']'
set @deleted_table = @table_name + '_Deleted'
set @delim_deleted_table = '[' + @deleted_table + ']'
set @queryall_table = @table_name + '_QueryAll'
set @delim_queryall_table = '[' + @queryall_table + ']'


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
	print @time_now + ': Local table does not exist. Using SF_ReplicateIAD to create the local table.'
	set @LogMessage = 'Local table does not exist. Using SF_ReplicateIAD to create the local table.'
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
	print @time_now + ': Table does not contain a timestamp column needed to refresh. Using SF_ReplicateIAD to create table.'
	set @LogMessage = 'Table does not contain a timestamp column needed to refresh. Using SF_ReplicateIAD to create table.'
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

-- if the last refresh time was before the last replicate time, use the last replicate time instead
if (@last_time < @table_crtime)
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
	set @LogMessage = 'DBAmp is using GMT for all datetime calculations.'
	exec SF_Logger @SPName, N'Message', @LogMessage
	SET @last_time = DATEADD(Hour, DATEDIFF(Hour, GETDATE(), GETUTCDATE()), @last_time)
end

Select @time_now = (select Convert(char(8),CURRENT_TIMESTAMP, 8))
print @time_now + ': Using last run time of ' + Convert(nvarchar(24),@last_time,120)
set @LogMessage = 'Using last run time of ' + CONVERT(nvarchar(24), @last_time, 120)
exec SF_Logger @SPName, N'Message', @LogMessage

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

-- Create new delta table with updated rows
-- Retrieve current server name and database
select @server = @@servername, @database = DB_NAME()
SET @server = CAST(SERVERPROPERTY('ServerName') AS sysname) 


-- Create an empty local table with the current structure of the Salesforce object
Select @time_now = (select Convert(char(8),CURRENT_TIMESTAMP, 8))
--print @time_now + ': Create ' + @delta_table + ' with new structure.'
exec ('Select Top 0 * into ' + @delim_delta_table + ' from ' + @table_server + '...' + @queryall_table )
IF (@@ERROR <> 0) GOTO ERR_HANDLER

-- Remember query time as the the start of the interval
declare @queryTime datetime
select @queryTime = (Select CURRENT_TIMESTAMP)

-- Use the queryall table to pick up archived and deleted rows	
select @sql = 'Insert ' + @delim_delta_table + ' Select * from ' + @table_server + '...' + @queryall_table + ' where ' + @timestamp_col_name + ' > @LastTimeIN'
select @parmlist = '@LastTimeIN datetime'
exec sp_executesql @sql, @parmlist, @LastTimeIN=@last_time
IF (@@ERROR <> 0) GOTO ERR_HANDLER

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
exec SF_Logger @SPName, N'Message', @LogMessage

-- If no records have changed then we are done
if (@delta_count = 0) goto SUCCESS

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
	  exec SF_Logger @SPName, N'Message', @LogMessage
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

if (@delta_count <> 0)
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

-- We don't need the delta tables so drop them
exec ('Drop table ' + @delim_delta_table)

print '--- Ending SF_RefreshIAD. Operation successful.'
set @LogMessage = 'Ending - Operation Successful.'
exec SF_Logger @SPName, N'Successful', @LogMessage
set NOCOUNT OFF
return 0

ERR_HANDLER:
-- We don't need the deleted and delta tables so drop them
IF EXISTS (SELECT 1
    FROM INFORMATION_SCHEMA.TABLES
    WHERE TABLE_TYPE='BASE TABLE'
    AND TABLE_NAME=@delta_table)
begin
   exec ('Drop table ' + @delim_delta_table)
end
print('--- Ending SF_RefreshIAD. Operation FAILED.')
set @LogMessage = 'Ending - Operation Failed.'
exec SF_Logger @SPName, N'Failed', @LogMessage
RAISERROR ('--- Ending SF_RefreshIAD. Operation FAILED.',16,1)
set NOCOUNT OFF
return 1

REPLICATE_EXIT:
-- Reset Last Refresh in the Refresh table for this object
-- BUGFIX: This is not needed so it is commented out
-- exec ('delete ' + @refresh_table + ' where TblName =''' + @table_name + '''')
IF EXISTS (SELECT 1
    FROM INFORMATION_SCHEMA.TABLES
    WHERE TABLE_TYPE='BASE TABLE'
    AND TABLE_NAME=@delta_table)
begin
   exec ('Drop table ' + @delim_delta_table)
end

set @LogMessage = 'Ending - Branching to SF_Replicate.' 
exec SF_Logger @SPName, N'Failed',@LogMessage
exec SF_ReplicateIAD @table_server, @table_name
set NOCOUNT OFF
return 0

