


CREATE PROCEDURE [dbo].[Archive_rpt_v_poandpi] (@ArchiveID INT)
AS
BEGIN

declare @Message varchar(255) = ''
,@Count int = 0
,@SourceCount int = 0


print 'Archiving rpt_v_poandpi..'

begin transaction 

begin try 

INSERT into [Archive].[rpt_v_poandpi]
(
ArchiveID,
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
select @ArchiveID,
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
from dbo.rpt_v_poandpi

SET @Count = @@ROWCOUNT
SET @Message = cast(@Count as varchar(20)) + ' Records Archived'
raiserror (@Message, 10,1)


select @SourceCount = count(*) from [rpt_v_poandpi]

SET @Message = 'Count of Records in dbo.[rpt_v_poandpi]'

if @SourceCount = @Count
begin

SET @Message = 'rpt_v_poandpi archived successfully!'
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
