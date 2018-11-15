
CREATE PROCEDURE [dbo].[SF_DropKeys] @table_server sysname 
AS

declare @time_now	char(8)
Select @time_now = (select Convert(char(8),CURRENT_TIMESTAMP, 8))
print @time_now + ': Starting SF_DropKeys.' + ' ' +  dbo.SF_Version()

DECLARE @table sysname
DECLARE @ftable sysname
DECLARE @fkey sysname

set NOCOUNT ON

CREATE TABLE #tempFK (
   PKTABLE_QUALIFIER sysname null,
   PKTABLE_OWNER sysname null,
   PKTABLE_NAME sysname,
   PKCOLUMN_NAME sysname,
   FKTABLE_QUALIFIER sysname null,
   FKTABLE_OWNER sysname null,
   FKTABLE_NAME sysname,
   FKCOLUMN_NAME sysname,
   KEY_SEQ smallint,
   UPDATE_RULE smallint,
   DELETE_RULE smallint,
   FK_NAME sysname null,
   PK_NAME sysname null,
   DEFERABILITY smallint)


-- Fetch all the user tables in this database that are salesforce.com tables
DECLARE curTable SCROLL CURSOR FOR 
   SELECT db.TABLE_NAME 
   FROM INFORMATION_SCHEMA.TABLES db
   WHERE db.TABLE_TYPE = 'BASE TABLE' 
ORDER BY db.TABLE_NAME

OPEN curTable

FETCH FIRST FROM curTable INTO @table

WHILE (@@FETCH_STATUS = 0)
BEGIN
   -- For each table, get the foreign and primary keys for that table 
   -- and add to our temp table of fkeys to be dropped
   INSERT INTO #tempFK exec sp_fkeys @table
   FETCH NEXT FROM curTable INTO @table
END
CLOSE curTable
DEALLOCATE curTable

-- Now go through and drop all the foreign keys
DECLARE curFK SCROLL CURSOR FOR SELECT FKTABLE_NAME, FK_NAME FROM #tempFK
OPEN curFK
FETCH FIRST FROM curFK INTO @ftable, @fkey
WHILE (@@FETCH_STATUS = 0)
BEGIN
   EXEC ('ALTER TABLE [' + @ftable + '] DROP CONSTRAINT ' + @fkey )
   if (@@error <> 0) goto ERR_HANDLER
   FETCH NEXT FROM curFK INTO @ftable, @fkey
END
CLOSE curFK
DEALLOCATE curFK


Select @time_now = (select Convert(char(8),CURRENT_TIMESTAMP, 8))
print @time_now + ': Ending SF_DropKeys. Operation successful..'
set NOCOUNT OFF
return 0

ERR_HANDLER:
set NOCOUNT OFF
Select @time_now = (select Convert(char(8),CURRENT_TIMESTAMP, 8))
print @time_now + ': Ending SF_DropKeys. Operation FAILED.'
RAISERROR ('--- Ending SF_DropKeys. Operation FAILED.',16,1)
return 1

