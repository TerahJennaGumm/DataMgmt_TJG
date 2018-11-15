
CREATE PROCEDURE [dbo].[SF_Generate]
	@operation nvarchar(20), 
	@table_server sysname,
	@load_tablename	sysname 

AS

-- Input Parameter @operation - Must be either 'Insert','Upsert','Update','Delete'
-- Input Parameter @table_server - Linked Server Name
-- Input Parameter @load_tablename - Existing bulkops table
print N'--- Starting SF_Generate' + ' ' +  dbo.SF_Version()
if LOWER(@operation) not in ('insert','upsert','update','delete')
begin
	RAISERROR ('--- Ending SF_Generate. Error: Invalid operation parameter.',16,1)
	return 1
end

IF  EXISTS (SELECT 1
    FROM INFORMATION_SCHEMA.TABLES
    WHERE TABLE_TYPE='BASE TABLE' 
    AND TABLE_NAME=@load_tablename)
begin
	RAISERROR ('--- Ending SF_Generate. Error: Table to generate already exists.',16,1)
	return 1
end

set NOCOUNT ON

declare @base_tablename sysname
declare @work sysname
declare @sql nvarchar(max)
declare @uscore_pos int
declare @uuc_pos int
declare @uus_pos int
declare @uuh_pos int
declare @uuk_pos int
declare @rc int

-- derive base table name from load table name
set @work = lower(@load_tablename)

-- Is this a custom table
set @uuc_pos = CHARINDEX('__c',@work)
set @uus_pos = CHARINDEX('__share',@work)
set @uuh_pos = CHARINDEX('__history',@work)
set @uuk_pos = CHARINDEX('__kav',@work)
if @uuc_pos <> 0 
	begin
		set @base_tablename = SUBSTRING(@work,1,@uuc_pos+2)
	end
else if @uus_pos <> 0
	begin
		set @base_tablename = SUBSTRING(@work,1,@uus_pos+6)
	end
else if @uuh_pos <> 0
	begin
		set @base_tablename = SUBSTRING(@work,1,@uuh_pos+8)
	end
else if @uuk_pos <> 0
	begin
		set @base_tablename = SUBSTRING(@work,1,@uuk_pos+4)
	end
else
	begin
		set @uscore_pos = CHARINDEX('_',@work)

		if @uscore_pos = 0
			set @base_tablename = @work
		else
			set @base_tablename = SUBSTRING(@work,1,@uscore_pos-1)
	end

-- Get a temporary sffields table
CREATE TABLE #sffields(
	[ObjectName] [nvarchar](128),
	[Name] [nvarchar](128) ,
	[Type] [nvarchar](32) ,
	[SQLDefinition] [nvarchar](128),
	[Createable] [varchar](5),
	[Updateable] [varchar](5)
)

set @sql = 'Insert into #sffields '
set @sql = @sql + 'Select [ObjectName],[Name],[Type],[SQLDefinition],[Createable],[Updateable] '
set @sql = @sql + 'from '+ @table_server + '...sys_sffields'
exec (@sql)
IF (@@ERROR <> 0) GOTO ERR_HANDLER

-- Clear out columns not belonging to the base table
delete #sffields where ObjectName != @base_tablename
IF (@@ERROR <> 0) GOTO ERR_HANDLER

set @sql = 'Create Table ' + @load_tablename + ' ('
set @sql = @sql + '[Id] nchar(18) null'
set @sql = @sql + ',[Error] nvarchar(255) null'

-- Generate rest of columns
declare @c_Name nvarchar(512)
declare @c_SQLDefinition nvarchar(512)
declare @c_Createable char(5)
declare @c_Updateable char(5)

declare flds_cursor cursor local fast_forward
for select [Name],[SQLDefinition],[Createable],[Updateable] from #sffields

open flds_cursor
IF (@@ERROR <> 0) GOTO ERR_HANDLER

while 1 = 1
begin
	fetch next from flds_cursor into @c_Name,@c_SQLDefinition,@c_Createable,@c_Updateable
	if @@error <> 0 or @@fetch_status <> 0 break
	
	if Lower(@c_Name) = 'id' continue
	if Lower(@operation) in ('insert','upsert') and @c_Createable = 'true '
	begin
		set @sql = @sql + ',[' + @c_Name + '] ' + @c_SQLDefinition
	end
	else if Lower(@operation) in ('update') and @c_Updateable = 'true '
	begin
		set @sql = @sql + ',[' + @c_Name + '] ' + @c_SQLDefinition
	end
end

set @sql = @sql + ')'

close flds_cursor
deallocate flds_cursor

-- Print CREATE TABLE and execute it to create the table
print @sql
exec (@sql)
set @rc = 0

-- Return to caller
if @rc = 1
	RAISERROR ('--- Ending SF_Generate. Operation FAILED.',16,1)

SET NOCOUNT OFF
return @rc

ERR_HANDLER:
RAISERROR ('--- Ending SF_Generate. Operation FAILED.',16,1)
SET NOCOUNT OFF
return 1

