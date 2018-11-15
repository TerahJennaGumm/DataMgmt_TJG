

CREATE PROCEDURE [dbo].[SF_CreateKeys] 
	@table_server sysname 
AS
-- Input Parameter @table_server - Linked Server Name
set NOCOUNT ON

declare @time_now	char(8)
Select @time_now = (select Convert(char(8),CURRENT_TIMESTAMP, 8))
print @time_now + ': Starting SF_CreateKeys.' + ' ' +  dbo.SF_Version()

-- Now for each table in the database that exists in Salesforce, create a Primary Key for Id
Create Table #tmpSF (TABLE_CAT sysname null, 
					TABLE_SCEM sysname null, 
					TABLE_NAME sysname, 
					TABLE_TYPE varchar(32), 
					REMARKS varchar(254))
Insert #tmpSF EXEC sp_tables_ex @table_server
if (@@error <> 0) 
	begin
	   print ERROR_MESSAGE()
	   goto BYE
	end
	
declare @tn			sysname
declare @delim_tn	sysname
declare @table_exist int
declare @sql		nvarchar(4000)

-- Now add the Foreign keys
Create Table #tmpFK (
	PKTABLE_CAT sysname null,
	PKTABLE_SCHEM sysname null,
	PKTABLE_NAME sysname null,
	PKCOLUMN_NAME sysname null,
	FKTABLE_CAT sysname null,
	FKTABLE_SCHEM sysname null,
	FKTABLE_NAME sysname null,
	FKCOLUMN_NAME sysname null,
	KEY_SEQ smallint,
	UPDATE_RULE smallint,
	DELETE_RULE smallint,
	FK_NAME sysname null,
	PK_NAME sysname null,
	DEFERRABILITY smallint)
 
Insert #tmpFK EXEC sp_foreignkeys @table_server
if (@@error <> 0) 
	begin
	   print ERROR_MESSAGE()
	   goto BYE
	end

declare keys_cursor cursor local fast_forward
for 
   select PKTABLE_NAME, PKCOLUMN_NAME, FKTABLE_NAME, FKCOLUMN_NAME, DELETE_RULE 
   from #tmpFK fk
   where PKTABLE_NAME in (Select TABLE_NAME from INFORMATION_SCHEMA.TABLES where TABLE_TYPE = 'BASE TABLE' )
	and   FKTABLE_NAME in (Select TABLE_NAME from INFORMATION_SCHEMA.TABLES where TABLE_TYPE = 'BASE TABLE' )


declare @pkTable	sysname
declare @delim_pkTable sysname
declare @pkColumn	sysname
declare @fkTable	sysname
declare @delim_fkTable sysname
declare @fkColumn	sysname
declare @deleteRule smallint

open keys_cursor

while 1 = 1
begin
	fetch next from keys_cursor into @pkTable, @pkColumn, @fkTable, @fkColumn, @deleteRule
	if @@error <> 0 or @@fetch_status <> 0 break

	-- Skip the obvious FK to the User table
	if @fkColumn = 'LastModifiedById' or @fkColumn = 'CreatedById' continue

	set @delim_fkTable = '[' + @fkTable + ']'
	set @delim_pkTable = '[' + @pkTable + ']'
	select @sql = 'Alter table ' + @delim_fkTable + ' with nocheck add Constraint FK_' + @fkTable + '_' + @fkColumn + '_' +@pkTable
	select @sql = @sql + ' Foreign Key('
	select @sql = @sql + @fkColumn + ') references ' + @delim_pkTable + '(' + @pkColumn +') '
	begin try
		exec sp_executesql @sql		
	end try
	begin catch
	   print 'Error occurred while creating a foreign key: ' + @sql 	
	  -- print ERROR_MESSAGE();
		CONTINUE
	end catch	

	-- Disable the just created foreign key
	select @sql = 'Alter table ' + @delim_fkTable + ' nocheck Constraint FK_' + @fkTable + '_' + @fkColumn + '_' +@pkTable
	begin try
		exec sp_executesql @sql		
	end try
	begin catch
	   print 'Error occurred while disabling a foreign key: ' + @sql 	
	  -- print ERROR_MESSAGE();
		CONTINUE
	end catch
end

-- Clean up
close keys_cursor
deallocate keys_cursor
Drop table #tmpFK

BYE:
Select @time_now = (select Convert(char(8),CURRENT_TIMESTAMP, 8))
print @time_now + ': Ending SF_CreateKeys.'
set NOCOUNT OFF
return 0

