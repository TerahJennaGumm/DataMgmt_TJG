


CREATE PROCEDURE dbo.Restore_rpt_v_subscription_compleat_gdsx (@ArchiveID INT)
AS
BEGIN

declare @Message varchar(255) = ''
,@Count int = 0
,@SourceCount int = 0


print 'Restoring rpt_v_subscription_compleat_gdsx..'

begin transaction 

begin try 

if exists (select 'Y' from Archive.rpt_v_subscription_compleat_gdsx where ArchiveID = @ArchiveID)
begin

truncate table dbo.rpt_v_subscription_compleat_gdsx  

Insert into dbo.rpt_v_subscription_compleat_gdsx
(

id_sub,
id_po,
id_acc,
vt_start,
vt_end,
id_pricelist,
id_pi_instance,
b_advance,
nm_desc,
id_sched,
n_order,
id_audit,
c_Tier,
c_ICBRateCustCurr,
c_PORateCustCurr,
c_PORateUSD,
c_ICBRateUSD,
tt_start,
tt_end,
dt_start,
dt_end,
c_RatingType,
c_UsgQualGroup,
c_AcctQualGroup,
c_CommitmentAmount,
c_MonthsInCommitmentPeriod,
c_CLINRate,
nm_instance_tablename,
ConcurOrderLineID,
c_CompanyCode,
c_CompanyDescription,
ConcurOrderLineIDRaw,
CancelSubscription)
select 
id_sub,
id_po,
id_acc,
vt_start,
vt_end,
id_pricelist,
id_pi_instance,
b_advance,
nm_desc,
id_sched,
n_order,
id_audit,
c_Tier,
c_ICBRateCustCurr,
c_PORateCustCurr,
c_PORateUSD,
c_ICBRateUSD,
tt_start,
tt_end,
dt_start,
dt_end,
c_RatingType,
c_UsgQualGroup,
c_AcctQualGroup,
c_CommitmentAmount,
c_MonthsInCommitmentPeriod,
c_CLINRate,
nm_instance_tablename,
ConcurOrderLineID,
c_CompanyCode,
c_CompanyDescription,
ConcurOrderLineIDRaw,
CancelSubscription
from Archive.rpt_v_subscription_compleat_gdsx where ArchiveID = @ArchiveID

SET @Count = @@ROWCOUNT
SET @Message = cast(@Count as varchar(20)) + ' records restored'
raiserror (@Message, 10,1)


select @SourceCount = count(*) from Archive.rpt_v_subscription_compleat_gdsx where ArchiveID = @ArchiveID

SET @Message = cast(@SourceCount as varchar(20)) + ' records in Archive.rpt_v_subscription_compleat_gdsx for ArchiveID ' + cast(@ArchiveID as varchar(20))

if @SourceCount = @Count
begin

SET @Message = 'rpt_v_subscription_compleat_gdsx restored successfully!'
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
