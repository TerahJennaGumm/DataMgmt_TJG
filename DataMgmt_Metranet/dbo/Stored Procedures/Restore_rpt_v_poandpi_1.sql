


CREATE PROCEDURE dbo.Restore_rpt_v_poandpi (@ArchiveID INT)
AS
BEGIN

declare @Message varchar(255) = ''
,@Count int = 0
,@SourceCount int = 0


print 'Restoring rpt_v_poandpi..'

begin transaction 

begin try 

if exists (select 'Y' from Archive.rpt_v_poandpi where ArchiveID = @ArchiveID)
begin

truncate table dbo.rpt_v_poandpi  

Insert into dbo.rpt_v_poandpi
(
id_po,
id_po__nm_display_name,
dt_start,
dt_end,
c_POCategory,
c_UOM,
c_UOMType,
c_UOMBlocks,
c_IsBundle,
c_HasRamps,
c_HasTermOfCommitment,
c_Edition,
c_ProductFamily,
c_MultQuanAddonsAllowed,
c_ServiceCatalog,
c_OptOut,
c_ProductLine,
c_isLegacy,
c_isNotSupportedinBMI,
c_isAbstainListPriceUpdates,
id_pi,
id_pi__nm_display_name,
c_SKU,
c_InOutSKU,
c_GSTCode,
c_ConcurItemType,
c_Rollup,
c_UnitOrFixed,
ep_type,
b_advance,
c_MaterialID,
c_GLAccount,
c_FulfType,
c_ExclAllocation,
c_TypeDesc,
c_RevRecIneligible,
id_pi_type,
id_pi_template,
nm_productview,
id_view)
select 
id_po,
id_po__nm_display_name,
dt_start,
dt_end,
c_POCategory,
c_UOM,
c_UOMType,
c_UOMBlocks,
c_IsBundle,
c_HasRamps,
c_HasTermOfCommitment,
c_Edition,
c_ProductFamily,
c_MultQuanAddonsAllowed,
c_ServiceCatalog,
c_OptOut,
c_ProductLine,
c_isLegacy,
c_isNotSupportedinBMI,
c_isAbstainListPriceUpdates,
id_pi,
id_pi__nm_display_name,
c_SKU,
c_InOutSKU,
c_GSTCode,
c_ConcurItemType,
c_Rollup,
c_UnitOrFixed,
ep_type,
b_advance,
c_MaterialID,
c_GLAccount,
c_FulfType,
c_ExclAllocation,
c_TypeDesc,
c_RevRecIneligible,
id_pi_type,
id_pi_template,
nm_productview,
id_view
from Archive.rpt_v_poandpi where ArchiveID = @ArchiveID

SET @Count = @@ROWCOUNT
SET @Message = cast(@Count as varchar(20)) + ' records restored'
raiserror (@Message, 10,1)


select @SourceCount = count(*) from Archive.rpt_v_poandpi where ArchiveID = @ArchiveID

SET @Message = cast(@SourceCount as varchar(20)) + ' records in Archive.rpt_v_poandpi for ArchiveID ' + cast(@ArchiveID as varchar(20))

if @SourceCount = @Count
begin

SET @Message = 'rpt_v_poandpi restored successfully!'
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