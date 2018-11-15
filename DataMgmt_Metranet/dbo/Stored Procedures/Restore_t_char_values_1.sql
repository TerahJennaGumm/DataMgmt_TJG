


CREATE PROCEDURE dbo.Restore_t_char_values (@ArchiveID INT)
AS
BEGIN

declare @Message varchar(255) = ''
,@Count int = 0
,@SourceCount int = 0


print 'Restoring t_char_values..'

begin transaction 

begin try 

if exists (select 'Y' from Archive.t_char_values where ArchiveID = @ArchiveID)
begin
	truncate table dbo.t_char_values 

	Insert into dbo.t_char_values
	(
	id_scv,
	id_entity,
	nm_value,
	c_start_date,
	c_end_date,
	c_spec_name,
	c_spec_type)
	select 
	id_scv,
	id_entity,
	nm_value,
	c_start_date,
	c_end_date,
	c_spec_name,
	c_spec_type
	from Archive.t_char_values where ArchiveID = @ArchiveID

	SET @Count = @@ROWCOUNT
	SET @Message = cast(@Count as varchar(20)) + ' records restored'
	raiserror (@Message, 10,1)


	select @SourceCount = count(*) from Archive.t_char_values where ArchiveID = @ArchiveID

	SET @Message = cast(@SourceCount as varchar(20)) + ' records in Archive.t_char_values for ArchiveID ' + cast(@ArchiveID as varchar(20))

	if @SourceCount = @Count
	begin

	SET @Message = 't_char_values restored successfully!'
	raiserror (@Message, 10,1)

	end

	else begin

	SET @Message = 'Error: Archive table and Live table row count does not match'
	raiserror (@Message, 16,1)

	end

	end 
	else begin

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