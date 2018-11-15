


CREATE PROCEDURE dbo.Restore_rpt_v_accountflattenedhierarchy (@ArchiveID INT)
AS
BEGIN

declare @Message varchar(255) = ''
,@Count int = 0
,@SourceCount int = 0


print 'Restoring rpt_v_accountflattenedhierarchy..'

begin transaction 

begin try 

if exists (select 'Y' from Archive.rpt_v_accountflattenedhierarchy where ArchiveID = @ArchiveID)
begin

truncate table dbo.rpt_v_accountflattenedhierarchy  

Insert into dbo.rpt_v_accountflattenedhierarchy
(

root_acct_type,
num_generations,
root_id_acc,
business_id_acc,
secondary_business_id_acc,
service_id_acc,
billing_id_acc)
select 
root_acct_type,
num_generations,
root_id_acc,
business_id_acc,
secondary_business_id_acc,
service_id_acc,
billing_id_acc
from Archive.rpt_v_accountflattenedhierarchy where ArchiveID = @ArchiveID

SET @Count = @@ROWCOUNT
SET @Message = cast(@Count as varchar(20)) + ' records restored'
raiserror (@Message, 10,1)


select @SourceCount = count(*) from Archive.rpt_v_accountflattenedhierarchy where ArchiveID = @ArchiveID

SET @Message = cast(@SourceCount as varchar(20)) + ' records in Archive.rpt_v_accountflattenedhierarchy for ArchiveID ' + cast(@ArchiveID as varchar(20))

if @SourceCount = @Count
begin

SET @Message = 'rpt_v_accountflattenedhierarchy restored successfully!'
raiserror (@Message, 10,1)

end

else begin

SET @Message = 'Error: Archive table and Live table row count does not match'
raiserror (@Message, 16,1)

end
end 
else
begin

SET @Message = 'No records exist in Archive table for ArchiveID ' + cast(@ArchiveID as varchar(20)) 
raiserror (@Message, 16,1)

end
commit transaction

end try 

begin catch 
declare @msg varchar(255) = ERROR_MESSAGE()
print @msg
if @@TRANCOUNT <> 0 
rollback transaction
raiserror (@msg, 16,1)
end catch 
 

end