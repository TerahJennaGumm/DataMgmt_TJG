


CREATE PROCEDURE [dbo].[Archive_rpt_v_subscriptionBundle] (@ArchiveID INT)
AS
BEGIN

declare @Message varchar(255) = ''
,@Count int = 0
,@SourceCount int = 0


print 'Archiving rpt_v_subscriptionBundle..'

begin transaction 

begin try 

Insert into [Archive].[rpt_v_subscriptionBundle]
(
ArchiveID,
c_IdSub,
c_IsMaster,
id_sched,
dt_start,
dt_end)
select @ArchiveID,
c_IdSub,
c_IsMaster,
id_sched,
dt_start,
dt_end
from dbo.rpt_v_subscriptionBundle

SET @Count = @@ROWCOUNT
SET @Message = cast(@Count as varchar(20)) + ' Records Archived'
raiserror (@Message, 10,1)


select @SourceCount = count(*) from [rpt_v_subscriptionBundle]

SET @Message = 'Count of Records in dbo.[rpt_v_subscriptionBundle]'

if @SourceCount = @Count
begin

SET @Message = 'rpt_v_subscriptionBundle archived successfully!'
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
