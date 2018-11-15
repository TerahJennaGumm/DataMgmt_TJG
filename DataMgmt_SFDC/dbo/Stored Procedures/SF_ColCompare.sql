
CREATE PROCEDURE [dbo].[SF_ColCompare]
	@operation nvarchar(20), 
	@table_server sysname,
	@load_tablename	sysname 

AS

-- Input Parameter @operation - Must be either 'Insert','Upsert','Update','Delete'
-- Input Parameter @table_server - Linked Server Name
-- Input Parameter @load_tablename - Existing bulkops table
print N'--- Starting SF_ColCompare' + ' ' +  dbo.SF_Version()

-- Quick parameter check
if LOWER(@operation) not in ('insert','upsert','update','delete')
begin
	RAISERROR ('--- Ending SF_ColCompare. Error: Invalid operation parameter.',16,1)
	return 1
end

IF  not EXISTS (SELECT 1
    FROM INFORMATION_SCHEMA.TABLES
    WHERE TABLE_TYPE='BASE TABLE' 
    AND TABLE_NAME=@load_tablename)
begin
	RAISERROR ('--- Ending SF_ColCompare. Error: Table to compare does not exist.',16,1)
	return 1
end

set NOCOUNT ON

declare @base_tablename sysname
declare @work sysname
declare @sql nvarchar(4000)
declare @uscore_pos int
declare @uuc_pos int
declare @rc int

-- derive base table name from load table name
set @work = @load_tablename

-- Is this a custom table
set @uuc_pos = CHARINDEX('__c',@work)
if @uuc_pos = 0 
	begin
		set @uscore_pos = CHARINDEX('_',@work)

		if @uscore_pos = 0
			set @base_tablename = @work
		else
			set @base_tablename = SUBSTRING(@work,1,@uscore_pos-1)
	end
else
	begin
		set @base_tablename = SUBSTRING(@work,1,@uuc_pos+2)
	end

-- Create problems table
CREATE TABLE #problems (
	ErrorDesc [nvarchar](1000)
)

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

-- Which cols of the load table do not exist in base table
insert into #problems
select 'Salesforce object ' +@base_tablename + ' does not contain column ' + lt.COLUMN_NAME
from INFORMATION_SCHEMA.COLUMNS lt
where lt.TABLE_NAME = @load_tablename and LOWER(lt.COLUMN_NAME) != 'error' and
not exists(select * from #sffields bt where LOWER(bt.[Name]) = LOWER(lt.COLUMN_NAME))
IF (@@ERROR <> 0) GOTO ERR_HANDLER

-- Which cols of the load table exist but are not createable
if LOWER(@operation) in ('insert','upsert')
begin
	insert into #problems
	select 'Column ' +lt.COLUMN_NAME +' is not insertable into the salesforce object ' +@base_tablename
	from INFORMATION_SCHEMA.COLUMNS lt, #sffields bt
	where lt.TABLE_NAME = @load_tablename and 
		  LOWER(lt.COLUMN_NAME) != 'error' and
		  LOWER(lt.COLUMN_NAME) != 'id' and
		  LOWER(bt.[Name]) = LOWER(lt.COLUMN_NAME) and
		  bt.[Createable] = 'false'
	IF (@@ERROR <> 0) GOTO ERR_HANDLER
end
	
-- Which cols of the load table exist but are not updateable
if LOWER(@operation) in ('update')
begin
	insert into #problems
	select 'Column ' + lt.COLUMN_NAME + ' is not updateable in the salesforce object ' + @base_tablename
	from INFORMATION_SCHEMA.COLUMNS lt, #sffields bt
	where lt.TABLE_NAME = @load_tablename and 
		  LOWER(lt.COLUMN_NAME) != 'error' and
		  LOWER(lt.COLUMN_NAME) != 'id' and
		  LOWER(bt.[Name]) = LOWER(lt.COLUMN_NAME) and
		  bt.[Updateable] = 'false'
	IF (@@ERROR <> 0) GOTO ERR_HANDLER
end  

-- Were there any problems ? If so return error and print table
if EXISTS(Select * from #problems)
begin
	set @rc = 1
	select * from #problems
	print 'Problems found with ' + @load_tablename +'. See output table for details.'
end
else
begin
	set @rc = 0
	print 'No problems found with ' + @load_tablename + '.'
end

-- Return to caller
if @rc = 1
	RAISERROR ('--- Ending SF_ColCompare. Operation FAILED.',16,1)

SET NOCOUNT OFF
return @rc

ERR_HANDLER:
RAISERROR ('--- Ending SF_ColCompare. Operation FAILED.',16,1)
SET NOCOUNT OFF
return 1

