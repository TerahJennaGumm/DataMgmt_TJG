
CREATE PROCEDURE [dbo].[SF_UploadFile]
	@table_server sysname,
	@table_name sysname,
        @id nchar(18),
	@file_name nvarchar(512)
AS
-- Parameters: @table_server           	- Salesforce Linked Server name (i.e. SALESFORCE)
--             @table_name             	- SQL Table containing Body field to store file in
--             @id			- Salesforce object id to upload file to
--             @file_name		- File name to upload 
--
-- @ProgDir - Directory containing the DBAmp.exe. Defaults to the DBAmp program directory
-- If needed, modify this for your installation
declare @ProgDir   	varchar(250) 
set @ProgDir = 'C:\"Program Files"\DBAmp\'

declare @Result 	int
declare @Command 	nvarchar(4000)

print '--- Starting SF_UploadFile for ' + @table_name + ' ' +  dbo.SF_Version()
declare @server sysname
declare @database sysname

set NOCOUNT ON

-- Retrieve current server name and database
select @server = @@servername, @database = DB_NAME()
SET @server = CAST(SERVERPROPERTY('ServerName') AS sysname) 


-- Execute DBAmp.exe to bulk delete objects from Salesforce
print 'Run the DBAmp.exe program.' 
set @Command = @ProgDir + 'DBAmp.exe Upload ' + @table_name 
set @Command = @Command + ' "' + @server + '" '
set @Command = @Command + ' "' + @database + '" '
set @Command = @Command + ' "' + @table_server + '" '
set @Command = @Command + ' "' + @file_name + '" '
set @Command = @Command + ' "' + @id + '" '

exec @Result = master..xp_cmdshell @Command
if @Result = -1
BEGIN
  	Print 'Error: DBAmp.exe was unsuccessful.'
  	GOTO RESTORE_ERR_HANDLER
END

print '--- Ending SF_UploadFile. Operation successful.'
set NOCOUNT OFF
return 0

RESTORE_ERR_HANDLER:
set NOCOUNT OFF
print '--- Ending SF_UploadFile. Operation FAILED.'
return 1

ERR_HANDLER:
set NOCOUNT OFF
print '--- Ending SF_UploadFile. Operation FAILED.'
return 1

