


CREATE PROCEDURE dbo.Restore_rpt_v_subscriptionpromotion (@ArchiveID INT)
AS
BEGIN

declare @Message varchar(255) = ''
,@Count int = 0
,@SourceCount int = 0


print 'Restoring rpt_v_subscriptionpromotion..'

begin transaction 

begin try 

if exists (select 'Y' from Archive.rpt_v_subscriptionpromotion where ArchiveID = @ArchiveID)
begin

truncate table dbo.rpt_v_subscriptionpromotion  

Insert into dbo.rpt_v_subscriptionpromotion
(
id_acc,
id_pi_instance,
c_PromoCode,
c_Description,
c_Percentage_Off,
c_PromotionDescription,
promo__id_sub,
promo__id_pi_instance,
promo__id_pricelist,
promo__id_sched,
promo__n_order,
promo__id_audit,
dt_start,
dt_end)
select 
id_acc,
id_pi_instance,
c_PromoCode,
c_Description,
c_Percentage_Off,
c_PromotionDescription,
promo__id_sub,
promo__id_pi_instance,
promo__id_pricelist,
promo__id_sched,
promo__n_order,
promo__id_audit,
dt_start,
dt_end
from Archive.rpt_v_subscriptionpromotion
where ArchiveID = @ArchiveID


SET @Count = @@ROWCOUNT
SET @Message = cast(@Count as varchar(20)) + ' records restored'
raiserror (@Message, 10,1)


select @SourceCount = count(*) from Archive.rpt_v_subscriptionpromotion where ArchiveID = @ArchiveID

SET @Message = cast(@SourceCount as varchar(20)) + ' records in Archive.rpt_v_subscriptionpromotion for ArchiveID ' + cast(@ArchiveID as varchar(20))

if @SourceCount = @Count
begin

SET @Message = 'rpt_v_subscriptionpromotion restored successfully!'
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
