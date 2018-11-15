


CREATE PROCEDURE [dbo].[Archive_t_char_values] (@ArchiveID INT)
AS
BEGIN

declare @Message varchar(255) = ''
,@Count int = 0
,@SourceCount int = 0


print 'Archiving t_char_values..'

begin transaction 

begin try 

Insert into [Archive].[t_char_values]
(
ArchiveID,
id_scv,
id_entity,
nm_value,
c_start_date,
c_end_date,
c_spec_name,
c_spec_type)
select @ArchiveID,
id_scv,
id_entity,
nm_value,
c_start_date,
c_end_date,
c_spec_name,
c_spec_type
from dbo.t_char_values

SET @Count = @@ROWCOUNT
SET @Message = cast(@Count as varchar(20)) + ' Records Archived'
raiserror (@Message, 10,1)


select @SourceCount = count(*) from [t_char_values]

SET @Message = 'Count of Records in dbo.[t_char_values]'

if @SourceCount = @Count
begin

SET @Message = 't_char_values archived successfully!'
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