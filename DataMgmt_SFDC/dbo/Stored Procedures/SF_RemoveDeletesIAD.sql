
CREATE PROCEDURE [dbo].[SF_RemoveDeletesIAD]
	@table_server sysname,
	@table_name sysname
AS
-- NOTE: This stored procedure will not work on SQL 2000.
--
-- Parameters: @table_server           - Salesforce Linked Server name (i.e. SALESFORCE)
--             @table_name             - Salesforce object to copy (i.e. Account)
declare @Result 	int
declare @sql		nvarchar(max)
declare @parmlist	nvarchar(4000)
declare @columnList nvarchar(max)
declare @deletecolumnList nvarchar(max)
declare @colname	nvarchar(500)
declare @time_now	char(8)

print '--- Starting SF_RemoveDeletesIAD for ' + @table_name + ' ' +  dbo.SF_Version()
declare @delim_table_name sysname
declare @refresh_table sysname
declare @delim_refresh_table sysname
declare @delta_table sysname
declare @delim_delta_table sysname
declare @deleted_table sysname
declare @delim_deleted_table sysname

declare @server sysname
declare @database sysname
declare @char_count varchar(10)
declare @queryall_table sysname
declare @delim_queryall_table sysname


set NOCOUNT ON

-- Put delimeters around names so we can name tables User, etc...
set @delim_table_name = '[' + @table_name + ']'
set @deleted_table = @table_name + '_Deleted'
set @delim_deleted_table = '[' + @deleted_table + ']'
set @queryall_table = @table_name + '_QueryAll'
set @delim_queryall_table = '[' + @queryall_table + ']'


-- Use alternate method to discover deleted id's
Select @time_now = (select Convert(char(8),CURRENT_TIMESTAMP, 8))
print @time_now + ': Using alternate method to determine deleted records.' 

-- If the deleted table exists, drop it 
declare @deleted_exist int
set @deleted_exist = 0;
IF EXISTS (SELECT 1
    FROM INFORMATION_SCHEMA.TABLES
    WHERE TABLE_TYPE='BASE TABLE'
    AND TABLE_NAME=@deleted_table)
        set @deleted_exist = 1
IF (@@ERROR <> 0) GOTO ERR_HANDLER

if (@deleted_exist = 1)
        exec ('Drop table ' + @delim_deleted_table)
IF (@@ERROR <> 0) GOTO ERR_HANDLER

-- Create new deleted table for non-replicatable tables
select @sql = 'Select Id into ' + @delim_deleted_table + ' from ' + @delim_table_name
select @sql = @sql + ' where Id not in (select Id from ' + @table_server + '...' + @queryall_table 
select @sql = @sql + ' where IsDeleted = ''false'')'
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

if (@deleted_count <> 0)
begin
	-- Delete rows from local table that exist in deleted table
	Select @time_now = (select Convert(char(8),CURRENT_TIMESTAMP, 8))
	print @time_now + ': Removing deleted rows from ' + @table_name 
	
	select @sql = 'delete ' + @delim_table_name + ' where Id IN (select Id from ' + @delim_deleted_table + ' )'
	exec sp_executesql @sql
	IF (@@ERROR <> 0) GOTO ERR_HANDLER
end


SUCCESS:
-- We don't need the deleted table so drop them
exec ('Drop table ' + @delim_deleted_table)

print '--- Ending SF_RemoveDeletesIAD. Operation successful.'
set NOCOUNT OFF
return 0

ERR_HANDLER:
set NOCOUNT OFF
print('--- Ending SF_RemoveDeletesIAD. Operation FAILED.')
RAISERROR ('--- Ending SF_RemoveDeletesIAD. Operation FAILED.',16,1)
return 1


