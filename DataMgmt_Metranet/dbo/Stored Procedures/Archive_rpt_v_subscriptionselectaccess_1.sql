


CREATE PROCEDURE [dbo].[Archive_rpt_v_subscriptionselectaccess] (@ArchiveID INT)
AS
BEGIN

declare @Message varchar(255) = ''
,@Count int = 0
,@SourceCount int = 0


print 'Archiving rpt_v_subscriptionselectaccess..'

begin transaction 

begin try 

Insert into [Archive].[rpt_v_subscriptionselectaccess]
(
ArchiveID,
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
CancelSubscription,
ConcurOrderLineIDRaw)
select @ArchiveID,
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
CancelSubscription,
ConcurOrderLineIDRaw
from dbo.rpt_v_subscriptionselectaccess

SET @Count = @@ROWCOUNT
SET @Message = cast(@Count as varchar(20)) + ' Records Archived'
raiserror (@Message, 10,1)


select @SourceCount = count(*) from [rpt_v_subscriptionselectaccess]

SET @Message = 'Count of Records in dbo.[rpt_v_subscriptionselectaccess]'

if @SourceCount = @Count
begin

SET @Message = 'rpt_v_subscriptionselectaccess archived successfully!'
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