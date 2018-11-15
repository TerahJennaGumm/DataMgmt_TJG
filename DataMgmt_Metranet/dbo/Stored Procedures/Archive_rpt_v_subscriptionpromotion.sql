


CREATE PROCEDURE [dbo].[Archive_rpt_v_subscriptionpromotion] (@ArchiveID INT)
AS
BEGIN

declare @Message varchar(255) = ''
,@Count int = 0
,@SourceCount int = 0


print 'Archiving rpt_v_subscriptionpromotion..'

begin transaction 

begin try 

Insert into [Archive].[rpt_v_subscriptionpromotion]
(
ArchiveID,
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
select @ArchiveID,
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
from dbo.rpt_v_subscriptionpromotion

SET @Count = @@ROWCOUNT
SET @Message = cast(@Count as varchar(20)) + ' Records Archived'
raiserror (@Message, 10,1)


select @SourceCount = count(*) from [rpt_v_subscriptionpromotion]

SET @Message = 'Count of Records in dbo.[rpt_v_subscriptionpromotion]'

if @SourceCount = @Count
begin

SET @Message = 'rpt_v_subscriptionpromotion archived successfully!'
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
