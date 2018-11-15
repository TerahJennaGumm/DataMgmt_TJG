
CREATE PROCEDURE [dbo].[usp_RestoreMetranetTables] (@ArchiveID	INT)
AS 
BEGIN 

DECLARE @msg varchar(255) = ''

	if exists (select 'Y' from Archive.ArchiveHistory where ID = @ArchiveID)

		begin

		EXEC dbo.Restore_rpt_v_account @ArchiveID

		EXEC dbo.Restore_rpt_v_accountcontact @ArchiveID

		EXEC dbo.Restore_rpt_v_accountflattenedhierarchy @ArchiveID

		EXEC dbo.Restore_rpt_v_poandpi @ArchiveID

		EXEC dbo.Restore_rpt_v_subscription @ArchiveID

		EXEC dbo.Restore_rpt_v_subscription_compleat_gdsx @ArchiveID

		EXEC dbo.Restore_rpt_v_subscriptionBundle @ArchiveID

		EXEC dbo.Restore_rpt_v_subscriptiongovernment @ArchiveID

		EXEC dbo.Restore_rpt_v_subscriptionpromotion @ArchiveID

		EXEC dbo.Restore_rpt_v_subscriptionselectaccess @ArchiveID

		EXEC dbo.Restore_t_av_concur @ArchiveID

		EXEC dbo.Restore_t_char_values @ArchiveID

		update Archive.ArchiveHistory 
		set    LastRestoreDateTime = getdate()
		where  ID = @ArchiveID

		end
	else

		begin
		set @msg = 'ArchiveID parameter of ' + cast(@ArchiveID as varchar(20)) + ' does not exist in ArchiveHistory table'
		raiserror (@msg,16,1)
		return
		end	
END