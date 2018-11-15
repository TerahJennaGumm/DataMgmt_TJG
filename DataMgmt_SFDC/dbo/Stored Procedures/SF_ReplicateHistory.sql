

-- =============================================
-- Create procedure SF_ReplicateHistory
-- 
-- This stored procedure is a "Hail Mary" pass to
-- try and replicate a history table when the
-- normal sf_replicate will NOT work due to
-- timeout issues on the salesforce server.
-- =============================================
CREATE PROCEDURE [dbo].[SF_ReplicateHistory]
	@table_server sysname,
	@table_name sysname
AS
-- Parameters: @table_server           - Salesforce Linked Server name (i.e. SALESFORCE)
--             @table_name             - Salesforce object to copy (i.e. Account)

declare @Result 	int
declare @Command 	nvarchar(4000)
declare @time_now	char(8)


print '--- Starting SF_ReplicateHistory for ' + @table_name + ' ' +  dbo.SF_Version()
declare @delim_table_name sysname
declare @prev_table sysname
declare @delim_prev_table sysname
declare @base_object sysname
declare @parentId_name sysname
declare @server sysname
declare @database sysname
set NOCOUNT ON

-- Is it really a history table
declare @isHistory int
declare @nameLength int
set @isHistory = 0

if RIGHT(@table_name,7) = 'History'
   set @isHistory =1 
if RIGHT(@table_name,7) = 'history'
   set @isHistory =1
if @isHistory = 0
begin
   Select @time_now = (select Convert(char(8),CURRENT_TIMESTAMP, 8))
   print @time_now + ': Error: The table is not a history table.' 
   GOTO ERR_HANDLER
end 

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
	   GOTO ERR_HANDLER
	end
end

-- If the previous table exists, drop it
Select @time_now = (select Convert(char(8),CURRENT_TIMESTAMP, 8))
print @time_now + ': Drop ' + @prev_table + ' if it exists.'
if (@prev_exist = 1)
        exec ('Drop table ' + @delim_prev_table)
IF (@@ERROR <> 0) GOTO ERR_HANDLER

-- Create an empty local table with the current structure of the Salesforce object
Select @time_now = (select Convert(char(8),CURRENT_TIMESTAMP, 8))
print @time_now + ': Create ' + @prev_table + ' with new structure.'

BEGIN TRY
	exec ('Select top 0 * into ' + @delim_prev_table + ' from ' + @table_server + '...' + @delim_table_name )

	-- Now do the insert into that table
	exec ('Insert ' + @delim_prev_table + '(' + @parentId_name + ',CreatedById,CreatedDate,Field,Id,IsDeleted,NewValue,OldValue)' +
		  ' select * from openquery(' + @table_server + 
		  ',''Select Id, (Select CreatedById,CreatedDate,Field,Id,IsDeleted,NewValue,OldValue from Histories) from ' +
		  @base_object + ' '') where Histories_CreatedById is not null')
END TRY
BEGIN CATCH
	Select @time_now = (select Convert(char(8),CURRENT_TIMESTAMP, 8))
	print @time_now + ': Error occurred populating the _Previous table.'	
	print @time_now +
		': Error: ' + ERROR_MESSAGE();
		
     -- Roll back any active or uncommittable transactions before
     -- inserting information in the ErrorLog.
     IF XACT_STATE() <> 0
     BEGIN
         ROLLBACK TRANSACTION;
     END
     goto ERR_HANDLER
END CATCH
	  
declare @primarykey_exists as int

Set @primarykey_exists = 1

BEGIN TRY
    BEGIN TRANSACTION;
	-- If the local table exists, drop it
	Select @time_now = (select Convert(char(8),CURRENT_TIMESTAMP, 8))
	print @time_now + ': Drop ' + @table_name + ' if it exists.'
	if (@table_exist = 1)
		exec ('Drop table ' + @delim_table_name)

	-- Backup previous table into current
	Select @time_now = (select Convert(char(8),CURRENT_TIMESTAMP, 8))
	print @time_now + ': Rename previous table from ' + @prev_table + ' to ' + @table_name
	exec sp_rename @prev_table, @table_name

    -- If the DDL statement succeeds, commit the transaction.
    COMMIT TRANSACTION;
END TRY
BEGIN CATCH
	Select @time_now = (select Convert(char(8),CURRENT_TIMESTAMP, 8))
	print @time_now + ': Error occurred dropping and renaming the table.'	
	print @time_now +
		': Error: ' + ERROR_MESSAGE();
		
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
	if (@primarykey_exists = 1)
	   -- Add Id as Primary Key
	   exec ('Alter table ' + @delim_table_name + ' Add Constraint PK_' + @table_name + '_Id Primary Key NONCLUSTERED (Id) ')
END TRY
BEGIN CATCH
	Select @time_now = (select Convert(char(8),CURRENT_TIMESTAMP, 8))
	print @time_now + ': Error occurred creating primary key for table.'	
	print @time_now +
		': Error: ' + ERROR_MESSAGE();
		
     -- Roll back any active or uncommittable transactions before
     -- inserting information in the ErrorLog.
     IF XACT_STATE() <> 0
     BEGIN
         ROLLBACK TRANSACTION;
     END
     goto ERR_HANDLER
END CATCH

print '--- Ending SF_ReplicateHistory. Operation successful.'
set NOCOUNT OFF
return 0

RESTORE_ERR_HANDLER:
set NOCOUNT OFF
print('--- Ending SF_ReplicateHistory. Operation FAILED.')
RAISERROR ('--- Ending SF_ReplicateHistory. Operation FAILED.',16,1)
return 1

ERR_HANDLER:
set NOCOUNT OFF
print('--- Ending SF_ReplicateHistory. Operation FAILED.')
RAISERROR ('--- Ending SF_ReplicateHistory. Operation FAILED.',16,1)
return 1

