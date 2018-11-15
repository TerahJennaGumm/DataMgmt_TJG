


CREATE PROCEDURE [dbo].[Archive_rpt_v_accountflattenedhierarchy] (@ArchiveID INT)
AS
BEGIN

declare @Message varchar(255) = ''
,@Count int = 0
,@SourceCount int = 0


print 'Archiving rpt_v_accountflattenedhierarchy..'

begin transaction 

begin try 

Insert into [Archive].[rpt_v_accountflattenedhierarchy]
(
ArchiveID,
root_acct_type,
num_generations,
root_id_acc,
business_id_acc,
secondary_business_id_acc,
service_id_acc,
billing_id_acc)
select @ArchiveID,
root_acct_type,
num_generations,
root_id_acc,
business_id_acc,
secondary_business_id_acc,
service_id_acc,
billing_id_acc
from dbo.rpt_v_accountflattenedhierarchy

SET @Count = @@ROWCOUNT
SET @Message = cast(@Count as varchar(20)) + ' Records Archived'
raiserror (@Message, 10,1)


select @SourceCount = count(*) from [rpt_v_accountflattenedhierarchy]

SET @Message = 'Count of Records in dbo.[rpt_v_accountflattenedhierarchy]'

if @SourceCount = @Count
begin

SET @Message = 'rpt_v_accountflattenedhierarchy archived successfully!'
raiserror (@Message, 10,1)

end

else begin

SET @Message = 'Error: Archive table and Live table row count does not match'
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
