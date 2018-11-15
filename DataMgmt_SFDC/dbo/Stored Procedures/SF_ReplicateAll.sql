

CREATE PROCEDURE [dbo].[SF_ReplicateAll] 
	@table_server sysname 
AS
-- Input Parameter @table_server - Linked Server Name
print N'--- Starting SF_ReplicateAll' + ' ' +  dbo.SF_Version()
set NOCOUNT ON
declare @LogMessage nvarchar(max)
declare @SPName nvarchar(50)
set @SPName = 'SF_ReplicateAll:' + Convert(nvarchar(255), NEWID(), 20)
set @LogMessage = 'Parameters: ' + @table_server + ' Version: ' +  dbo.SF_Version()
exec SF_Logger @SPName, N'Starting',@LogMessage

Create Table #tmpSF ([Name] sysname not null, Queryable varchar(5) not null)
declare @sql nvarchar(4000)
set @sql = 'Select Name,Queryable from ' + @table_server + '...sys_sfobjects'
Insert #tmpSF EXEC (@sql)
if (@@error <> 0) goto ERR_HANDLER

declare @tn sysname
declare @queryable varchar(5)
declare @ReplicateError int
Set @ReplicateError = 0

declare tbls_cursor cursor local fast_forward
for select [Name],Queryable from #tmpSF


open tbls_cursor

while 1 = 1
begin
   fetch next from tbls_cursor into @tn, @queryable
   if @@error <> 0 or @@fetch_status <> 0 break

-- print @tn + ' ' + @queryable
   if @queryable = 'false' CONTINUE
   
   -- To skip tables, add a statement similiar to the statement below
   -- if @tn = 'SolutionHistory' CONTINUE
   
   -- The IdeaComment table must now be skipped.
   -- With API 24.0, sf does not allow select all rows for that table.
   if @tn = 'IdeaComment' CONTINUE
   
   -- The UserRecordAccess table must now be skipped.
   -- With API 24.0, sf does not allow select all rows for that table.
   if @tn = 'UserRecordAccess' CONTINUE
   
   -- The vote table must now be skipped.
   -- With API 17.0, sf does not allow select all rows for that table.
   if @tn = 'Vote' CONTINUE
   
   -- Skip these tables due to api restriction
   if @tn='FieldDefinition' CONTINUE
   if @tn='ListViewChartInstance' CONTINUE

   -- The ContentDocumentLink table must now be skipped.
   -- With API 21.0, sf does not allow select all rows for that table.
   if @tn = 'ContentDocumentLink' CONTINUE
 
   -- Skip the EventLogFile table due to size of the blobs
   if @tn = 'EventLogFile' CONTINUE

    -- The FeedItem table must now be skipped.
   -- With API 21.0, sf does not allow select all rows for that table.
   if @tn = 'FeedItem' CONTINUE

   -- Feed tables consume huge quantities of API calls
   -- Therefore, we skip them. Comment out the lines if you would like to include them.
   if LEFT(@tn,4) = 'Feed' CONTINUE
   if RIGHT(@tn,4) = 'Feed' CONTINUE
   
   -- Knowledge _kav tables cannot handle a select without where clause so we skip them
   if RIGHT(@tn,4) = '_kav' CONTINUE
   if @tn = 'KnowledgeArticleVersion' CONTINUE
   
   if @tn = 'PlatformAction' CONTINUE
   if @tn = 'CollaborationGroupRecord' CONTINUE
   
   -- Skip offending data.com tables
   if @tn = 'DatacloudDandBCompany' CONTINUE
   if @tn = 'DcSocialProfile' CONTINUE
   if @tn = 'DataCloudConnect' CONTINUE
   if @tn = 'DatacloudCompany' CONTINUE
   if @tn = 'DatacloudContact' CONTINUE
   if @tn = 'DatacloudSocialHandle' CONTINUE
   if @tn = 'DcSocialProfileHandle' CONTINUE
   
   if @tn = 'ContentFolderMember' CONTINUE   
   if @tn = 'EntityParticle' CONTINUE  
   if @tn = 'EntityDescription' CONTINUE 
   if @tn = 'EntityDefinition' CONTINUE   
   if @tn = 'Publisher' CONTINUE
   if @tn = 'RelationshipDomain' CONTINUE   
   if @tn = 'RelationshipInfo' CONTINUE  
   if @tn = 'ServiceFieldDataType' CONTINUE
   if @tn = 'UserEntityAccess' CONTINUE
   if @tn = 'PicklistValueInfo' CONTINUE
   if @tn = 'SearchLayout' CONTINUE
   if @tn = 'UserFieldAccess' CONTINUE
   if @tn= 'ContentFolderItem' CONTINUE
   
   if @tn = 'FieldPermissions' CONTINUE

   
   -- Call SF_Replicate for this table
   begin try
      exec SF_Replicate @table_server, @tn
   end try
   begin catch
      print 'Error: SF_Replicate failed for table ' + @tn
	  set @LogMessage = 'Error: SF_Replicate failed for table ' + @tn
	  exec SF_Logger @SPName, N'Message', @LogMessage
 	 print 
		'Error ' + CONVERT(VARCHAR(50), ERROR_NUMBER()) +
		', Severity ' + CONVERT(VARCHAR(5), ERROR_SEVERITY()) +
		', State ' + CONVERT(VARCHAR(5), ERROR_STATE()) + 
		', Line ' + CONVERT(VARCHAR(5), ERROR_LINE());
	 print 
		ERROR_MESSAGE();
		set @LogMessage = ERROR_MESSAGE()
		-- Comment out to avoid issues in log table
		-- exec SF_Logger @SPName, N'Message', @LogMessage 
		
     -- Roll back any active or uncommittable transactions before
     -- inserting information in the ErrorLog.
     IF XACT_STATE() <> 0
     BEGIN
         ROLLBACK TRANSACTION;
     END
     set @ReplicateError = 1
   end catch
 end

close tbls_cursor
deallocate tbls_cursor

-- If one of the tables failed to replicate jump to error handler
if @ReplicateError = 1 goto ERR_HANDLER

Drop table #tmpSF

set @LogMessage = 'Ending - Operation Successful.' 
exec SF_Logger @SPName, N'Successful',@LogMessage
-- Turn NOCOUNT back off
set NOCOUNT OFF
print N'--- Ending SF_ReplicateAll. Operation successful.'
return 0


ERR_HANDLER:
-- If we encounter an error, then indicate by returning 1
Drop table #tmpSF

set @LogMessage = 'Ending - Operation Failed.' 
exec SF_Logger @SPName,N'Successful', @LogMessage
-- Turn NOCOUNT back off
set NOCOUNT OFF
print N'--- Ending SF_ReplicateAll. Operation failed.'
RAISERROR ('--- Ending SF_ReplicateAll. Operation FAILED.',16,1)
return 1

