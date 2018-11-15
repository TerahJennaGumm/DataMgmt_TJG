
CREATE PROCEDURE [dbo].[SF_ReplicateIAD]
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

print '--- Starting SF_ReplicateIAD for ' + @table_name + ' ' +  dbo.SF_Version()
declare @LogMessage nvarchar(max)
declare @SPName nvarchar(50)
set @SPName = 'SF_ReplicateIAD:' + Convert(nvarchar(255), NEWID(), 20)
set @LogMessage = 'Parameters: ' + @table_server + ' ' + @table_name + ' ' + ISNULL(@options, ' ') + ' Version: ' +  dbo.SF_Version()
exec SF_Logger @SPName, N'Starting',@LogMessage

declare @delim_table_name sysname
declare @prev_table sysname
declare @delim_prev_table sysname
declare @delete_table sysname
declare @delim_delete_table sysname
declare @server sysname
declare @database sysname



-- Put delimeters around names so we can name tables User, etc...
set @delim_table_name = '[' + @table_name + ']'
set @prev_table = @table_name + '_Previous'
set @delim_prev_table = '[' + @prev_table + ']'
set @delete_table = @table_name + '_DeleteIAD'
set @delim_delete_table = '[' + @delete_table + ']'

-- Determine whether the local table and the previous copy exist
declare @table_exist int
declare @prev_exist int
declare @delete_exist int

set @table_exist = 0
set @prev_exist = 0;
set @delete_exist = 0;

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

IF EXISTS (SELECT 1
    FROM INFORMATION_SCHEMA.TABLES
    WHERE TABLE_TYPE='BASE TABLE' 
    AND TABLE_NAME=@delete_table)
        set @delete_exist = 1
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

-- If the delete table exists, drop it
Select @time_now = (select Convert(char(8),CURRENT_TIMESTAMP, 8))
print @time_now + ': Drop ' + @delete_table + ' if it exists.'
set @LogMessage = 'Drop ' + @delete_table + ' if it exists.'
exec SF_Logger @SPName, N'Message', @LogMessage
if (@delete_exist = 1)
        exec ('Drop table ' + @delim_delete_table)
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

-- Make sure there is an IsDeleted column
IF NOT EXISTS (SELECT 1
    FROM INFORMATION_SCHEMA.COLUMNS
    WHERE COLUMN_NAME='IsDeleted' 
    AND TABLE_NAME=@prev_table)
BEGIN
   Select @time_now = (select Convert(char(8),CURRENT_TIMESTAMP, 8))
   print @time_now + ': Error: The table does not contain the required IsDeleted column.' 
   set @LogMessage = 'Error: The table does not contain the required IsDeleted column.'
   exec SF_Logger @SPName, N'Message', @LogMessage
   GOTO ERR_HANDLER
END


-- Retrieve current server name and database
select @server = @@servername, @database = DB_NAME()
SET @server = CAST(SERVERPROPERTY('ServerName') AS sysname) 

-- Execute DBAmp.exe to load table from Salesforce
Select @time_now = (select Convert(char(8),CURRENT_TIMESTAMP, 8))
print @time_now + ': Run the DBAmp.exe program.' 
set @LogMessage = 'Run the DBAmp.exe program.'
exec SF_Logger @SPName, N'Message', @LogMessage
set @Command = @ProgDir + 'DBAmp.exe ExportAll' 
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

-- If the local table currently exists,
-- capture the deleted rows and
-- check to see if the column structure is the same
declare @diff_schema_count int
declare @columnList nvarchar(max)
declare @colname	nvarchar(500)
declare @sql nvarchar(max)

if @table_exist = 1
BEGIN
	-- Build a table of the deleted rows
	BEGIN TRY
		-- Create an empty local table with the current structure of the Salesforce object
		Select @time_now = (select Convert(char(8),CURRENT_TIMESTAMP, 8))
		print @time_now + ': Create ' + @delete_table + ' with new structure.'
		set @LogMessage = 'Create ' + @delete_table + ' with new structure.'
		exec SF_Logger @SPName, N'Message', @LogMessage
		exec ('Select Top 0 * into ' + @delim_delete_table + ' from ' +  @delim_table_name )
		
		-- Populate it
		select @sql = 'Insert ' + @delim_delete_table + ' Select * from ' + @delim_table_name
		select @sql = @sql + ' where Id not in (select Id from ' + @delim_prev_table + ')'
		exec sp_executesql @sql
		IF (@@ERROR <> 0) GOTO ERR_HANDLER
		
		-- Mark them as deleted
		exec ('Update ' + @delim_delete_table + ' set IsDeleted = ''true'' ')
	
	
		-- Get the count of records from the deleted table
		declare @deleted_count int
		declare @parmlist	nvarchar(4000)
		declare @char_count varchar(10)
		select @sql = 'Select @DeletedCountOUT = Count(*) from ' + @delim_delete_table
		select @parmlist = '@DeletedCountOUT int OUTPUT'
		exec sp_executesql @sql,@parmlist, @DeletedCountOUT=@deleted_count OUTPUT
		IF (@@ERROR <> 0) GOTO ERR_HANDLER

		-- Print number of rows in deleted table
		Select @time_now = (select Convert(char(8),CURRENT_TIMESTAMP, 8))
		Select @char_count = (select CAST(@deleted_count as VARCHAR(10)))
		print @time_now + ': Identified ' + @char_count + ' hard deleted rows.'
		set @LogMessage = 'Identified ' + @char_count + ' hard deleted rows.'
		exec SF_Logger @SPName, N'Message', @LogMessage
		
		-- Check if the column structure has changed
		declare @cnt1 int
		declare @cnt2 int
		
		Select @cnt1 = Count(*) FROM INFORMATION_SCHEMA.COLUMNS v1 WHERE v1.TABLE_NAME=@prev_table 
				AND NOT EXISTS (Select COLUMN_NAME from INFORMATION_SCHEMA.COLUMNS v2 where 
				v2.TABLE_NAME=@table_name and v1.COLUMN_NAME = v2.COLUMN_NAME and v1.DATA_TYPE = v2.DATA_TYPE 
				and v1.IS_NULLABLE = v2.IS_NULLABLE and v1.ORDINAL_POSITION = v2.ORDINAL_POSITION 
				and ISNULL(v1.CHARACTER_MAXIMUM_LENGTH,0) = ISNULL(v2.CHARACTER_MAXIMUM_LENGTH,0))
		IF (@@ERROR <> 0) GOTO ERR_HANDLER
		
		Select @cnt2 = Count(*) FROM INFORMATION_SCHEMA.COLUMNS v1 WHERE v1.TABLE_NAME=@table_name
				AND NOT EXISTS (Select COLUMN_NAME from INFORMATION_SCHEMA.COLUMNS v2 where 
				v2.TABLE_NAME=@prev_table and v1.COLUMN_NAME = v2.COLUMN_NAME and v1.DATA_TYPE = v2.DATA_TYPE 
				and v1.IS_NULLABLE = v2.IS_NULLABLE and v1.ORDINAL_POSITION = v2.ORDINAL_POSITION 
				and ISNULL(v1.CHARACTER_MAXIMUM_LENGTH,0) = ISNULL(v2.CHARACTER_MAXIMUM_LENGTH,0))
		IF (@@ERROR <> 0) GOTO ERR_HANDLER
		
		set @diff_schema_count = @cnt1 + @cnt2

		if (@diff_schema_count > 0)
		begin
			Select @time_now = (select Convert(char(8),CURRENT_TIMESTAMP, 8))
			print @time_now + ': Table schema has changed.'
			set @LogMessage = 'Table schema has changed.'
			exec SF_Logger @SPName, N'Message', @LogMessage

			-- Schema changed so try to build a subset of columns
			-- Build list of columns in common
			declare colname_cursor cursor for 
				SELECT COLUMN_NAME FROM INFORMATION_SCHEMA.COLUMNS v1 WHERE v1.TABLE_NAME= @table_name 
				AND EXISTS (Select COLUMN_NAME from INFORMATION_SCHEMA.COLUMNS v2 
				where v2.TABLE_NAME= @prev_table 
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
				print @time_now + ': Error: Table schema has changed with no columns in common. Therefore the table cannot be replicated.'
				set @LogMessage = 'Error: Table schema has changed with no columns in common. Therefore the table cannot be replicated.'
				exec SF_Logger @SPName, N'Message', @LogMessage
				GOTO ERR_HANDLER
			end
							
			SET @columnList = SUBSTRING(@columnList, 1, Len(@columnList) - 1)
								
			-- Now insert the new rows
			select @sql = 'insert ' + @delim_prev_table + '(' + @columnList + ')' 
						+ ' select ' + @columnList + ' from ' + @delim_delete_table
			exec sp_executesql @sql
			IF (@@ERROR <> 0) 
			   GOTO ERR_HANDLER
		end
		else
		begin
			-- Insert deleted rows into the previous table
			select @sql = 'insert ' + @delim_prev_table + ' select * from ' + @delim_delete_table
			exec sp_executesql @sql
			IF (@@ERROR <> 0) 
			begin
			   GOTO ERR_HANDLER
			end
		end
	END TRY
	BEGIN CATCH
		Select @time_now = (select Convert(char(8),CURRENT_TIMESTAMP, 8))
		print @time_now + ': Error occurred while building a table of hard deleted rows.'
		set @LogMessage = 'Error occurred while building a table of hard deleted rows.'
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
end

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

print '--- Ending SF_ReplicateIAD. Operation successful.'
set @LogMessage = 'Ending - Operation Successful.' 
exec SF_Logger @SPName,N'Successful', @LogMessage
set NOCOUNT OFF
return 0

RESTORE_ERR_HANDLER:
print('--- Ending SF_ReplicateIAD. Operation FAILED.')
set @LogMessage = 'Ending - Operation Failed.' 
exec SF_Logger @SPName, N'Failed',@LogMessage
RAISERROR ('--- Ending SF_ReplicateIAD. Operation FAILED.',16,1)
set NOCOUNT OFF
return 1

ERR_HANDLER:
print('--- Ending SF_ReplicateIAD. Operation FAILED.')
set @LogMessage = 'Ending - Operation Failed.' 
exec SF_Logger @SPName,N'Failed', @LogMessage
RAISERROR ('--- Ending SF_ReplicateIAD. Operation FAILED.',16,1)
set NOCOUNT OFF
return 1


