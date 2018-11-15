


CREATE PROCEDURE [dbo].[SF_RefreshAll] 
	@table_server sysname,
	@replicate_on_schema_error sysname = 'No',
	@verify_action varchar(100) = 'no'
AS
-- Input Parameter @table_server - Linked Server Name
--             @replicate_on_schema_error - Controls whether to go ahead and replicate for a schema change or non refreshable table 
--                                        -    If the value is Yes then a replicate will be done for schema changes and non refreshable tables
--                                        -    If the value is Subset then a refresh with the common subset of columns will be done
--             @replicate_on_schema_error    - Controls the action for a schema change 
--                                     -    'No' : FAIL on a schema change
--                                     -    'Yes' : The table will be replicated instead
--                                     -    'Subset' : The new columns are ignored and the current
--                                                     subset of local table columns are refreshed.
--                                     -               Columns deleted on salesforce ARE NOT deleted locally. 
--                                     -    'SubsetDelete' : The new columns are ignored and the current
--                                                     subset of local table columns are refreshed.
--                                     -               Columns deleted on salesforce ARE deleted locally. 
--									   -    'Repair' :  The Max(SystemModStamp of the local table is used and 
--                                                      alternate method of handling deletes is used (slower)
--             @verify_action		   - Controls the row count compare behavior
--                                     -    'No' : Do not compare row counts
--                                     -    'Warn' : Compare row counts and issue warning if different
--                                     -    'Fail' : Compare row counts and fail the proc if different

set NOCOUNT ON
print N'--- Starting SF_RefreshAll' + ' ' +  dbo.SF_Version()
declare @LogMessage nvarchar(max)
declare @SPName nvarchar(50)
set @SPName = 'SF_RefreshAll:' + Convert(nvarchar(255), NEWID(), 20)
set @LogMessage = 'Parameters: ' + @table_server + ' ' + @replicate_on_schema_error + ' ' + @verify_action + ' Version: ' +  dbo.SF_Version()
exec SF_Logger @SPName,N'Starting', @LogMessage

if (@replicate_on_schema_error = 'Yes' or @replicate_on_schema_error = 'yes')
   print N'Warning: Replicating tables that are non-refreshable or that have schema changes.'
   set @LogMessage = 'Warning: Replicating tables that are non-refreshable or that have schema changes.'
   exec SF_Logger @SPName, N'Message', @LogMessage

Create Table #tmpSF ([Name] sysname not null, TimestampField nvarchar(128)not null, Queryable varchar(5) not null)
declare @sql nvarchar(4000)
set @sql = 'Select Name,TimestampField,Queryable from ' + @table_server + '...sys_sfobjects'
Insert #tmpSF EXEC (@sql)
if (@@error <> 0) goto ERR_HANDLER

declare @tn sysname
declare @timestampfield nvarchar(128)
declare @suberror int
set @suberror = 0

declare @queryable varchar(5)
declare tbls_cursor cursor local fast_forward
for select [Name],TimestampField, Queryable from #tmpSF
join tablerefreshtime as trt on trt.tblname= name
order by trt.lastrefreshtime desc

open tbls_cursor

while 1 = 1
begin
   fetch next from tbls_cursor into @tn,@timestampfield,@queryable
   if @@error <> 0 or @@fetch_status <> 0 break

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
   
   -- The ContentDocumentLink table must now be skipped.
   -- With API 21.0, sf does not allow select all rows for that table.
   if @tn = 'ContentDocumentLink' CONTINUE
 
    -- The FeedItem table must now be skipped.
   -- With API 21.0, sf does not allow select all rows for that table.
   if @tn = 'FeedItem' CONTINUE
   
    -- Skip the EventLogFile table due to size of the blobs
   if @tn = 'EventLogFile' CONTINUE
   
   -- Skip these tables due to api restriction
   if @tn='FieldDefinition' CONTINUE
   if @tn='ListViewChartInstance' CONTINUE
   
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
   
   if @tn = 'FieldPermissions' CONTINUE
   if @tn = 'ContentFolderItem' CONTINUE
   
   if @timestampfield <> 'SystemModstamp' and @timestampfield <> 'CreatedDate' 
   begin
      -- print @tn + ' ' + @queryable
      if ((@replicate_on_schema_error = 'Yes' or @replicate_on_schema_error = 'yes') and @queryable = 'true')
      begin
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
			--exec SF_Logger @SPName, N'Message', @LogMessage

			 -- Roll back any active or uncommittable transactions before
			 -- inserting information in the ErrorLog.
			 IF XACT_STATE() <> 0
			 BEGIN
				 ROLLBACK TRANSACTION;
			 END
		  set @suberror = 1
	    end catch
		continue
	  end
	  else
	  begin
	    -- skip this table
	    CONTINUE
	  end
   end
   
   -- Call SF_Refresh for this table
   begin try
		exec SF_Refresh @table_server, @tn , @replicate_on_schema_error, @verify_action
   end try
   begin catch
	 print 'Error: SF_Refresh failed for table ' + @tn
	 set @LogMessage = 'Error: SF_Refresh failed for table ' + @tn
	 exec SF_Logger @SPName, N'Message', @LogMessage
	 print 
		'Error ' + CONVERT(VARCHAR(50), ERROR_NUMBER()) +
		', Severity ' + CONVERT(VARCHAR(5), ERROR_SEVERITY()) +
		', State ' + CONVERT(VARCHAR(5), ERROR_STATE()) + 
		', Line ' + CONVERT(VARCHAR(5), ERROR_LINE());
	 print 
		ERROR_MESSAGE();
		set @LogMessage = ERROR_MESSAGE()
		exec SF_Logger @SPName, N'Message', @LogMessage 
		
     -- Roll back any active or uncommittable transactions before
     -- inserting information in the ErrorLog.
     IF XACT_STATE() <> 0
     BEGIN
         ROLLBACK TRANSACTION;
     END
	 set @suberror = 1
   end catch
   
 end

close tbls_cursor
deallocate tbls_cursor

if @suberror = 1 goto ERR_HANDLER

Drop table #tmpSF

-- Turn NOCOUNT back off

print N'--- Ending SF_RefreshAll. Operation successful.'
set @LogMessage = 'Ending - Operation Successful.' 
exec SF_Logger @SPName,N'Successful', @LogMessage
set NOCOUNT OFF
return 0


ERR_HANDLER:
-- If we encounter an error creating the view, then indicate by returning 1
Drop table #tmpSF

set @LogMessage = 'Ending - Operation Failed.' 
exec SF_Logger @SPName,N'Failed', @LogMessage
-- Turn NOCOUNT back off
print N'--- Ending SF_RefreshAll. Operation failed.'
set @LogMessage = 'Ending - Operation Failed.'
exec SF_Logger @SPName, N'Failed', @LogMessage
RAISERROR ('--- Ending SF_RefreshAll. Operation FAILED.',16,1)
set NOCOUNT OFF
return 1


