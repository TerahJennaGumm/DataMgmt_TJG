


CREATE PROCEDURE dbo.Restore_rpt_v_accountcontact (@ArchiveID INT)
AS
BEGIN

declare @Message varchar(255) = ''
,@Count int = 0
,@SourceCount int = 0


print 'Restoring rpt_v_accountcontact..'

begin transaction 

begin try 

if exists (select 'Y' from Archive.rpt_v_accountcontact where ArchiveID = @ArchiveID)
begin

truncate table dbo.rpt_v_accountcontact  

Insert into dbo.rpt_v_accountcontact
(

id_acc,
c_ContactType,
c_Company,
c_FirstName,
c_LastName,
c_Email,
c_PhoneNumber,
c_Address1,
c_Address2,
c_Address3,
c_Address4,
c_City,
c_Zip,
c_State,
c_Country,
c_CompanyCode,
c_CompanyDescription
)
select 
id_acc,
c_ContactType,
c_Company,
c_FirstName,
c_LastName,
c_Email,
c_PhoneNumber,
c_Address1,
c_Address2,
c_Address3,
c_Address4,
c_City,
c_Zip,
c_State,
c_Country,
c_CompanyCode,
c_CompanyDescription
from Archive.rpt_v_accountcontact where ArchiveID = @ArchiveID

SET @Count = @@ROWCOUNT
SET @Message = cast(@Count as varchar(20)) + ' records restored'
raiserror (@Message, 10,1)


select @SourceCount = count(*) from Archive.rpt_v_accountcontact where ArchiveID = @ArchiveID

SET @Message = cast(@SourceCount as varchar(20)) + ' records in Archive.rpt_v_accountcontact for ArchiveID ' + cast(@ArchiveID as varchar(20))

if @SourceCount = @Count
begin

SET @Message = 'rpt_v_accountcontact restored successfully!'
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
