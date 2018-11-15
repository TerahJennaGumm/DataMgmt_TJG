
CREATE PROCEDURE [dbo].[usp_ArchiveMetranetTables] 
AS 
BEGIN 

DECLARE @ArchiveID	INT
DECLARE	@OutputTbl TABLE (ID INT)
		

	begin
	INSERT INTO [Archive].[ArchiveHistory]
		(
		ArchiveDateTime
		)
	OUTPUT INSERTED.ID INTO @OutputTbl(ID)
	SELECT getdate()

	SELECT @ArchiveID = ID from @OutputTbl

	EXEC dbo.Archive_rpt_v_account @ArchiveID

	EXEC dbo.Archive_rpt_v_accountcontact @ArchiveID

	EXEC dbo.Archive_rpt_v_accountflattenedhierarchy @ArchiveID

	EXEC dbo.Archive_rpt_v_poandpi @ArchiveID

	EXEC dbo.Archive_rpt_v_subscription @ArchiveID

	EXEC dbo.Archive_rpt_v_subscription_compleat_gdsx @ArchiveID

	EXEC dbo.Archive_rpt_v_subscriptionBundle @ArchiveID

	EXEC dbo.Archive_rpt_v_subscriptiongovernment @ArchiveID

	EXEC dbo.Archive_rpt_v_subscriptionpromotion @ArchiveID

	EXEC dbo.Archive_rpt_v_subscriptionselectaccess @ArchiveID

	EXEC dbo.Archive_t_av_concur @ArchiveID

	EXEC dbo.Archive_t_char_values @ArchiveID
	end

END


