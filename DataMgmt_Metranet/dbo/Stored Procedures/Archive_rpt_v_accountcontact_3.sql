


CREATE PROCEDURE [dbo].[Archive_rpt_v_accountcontact] (@ArchiveID INT)
AS
BEGIN

declare @Message varchar(255) = ''
,@Count int = 0
,@SourceCount int = 0


print 'Archiving rpt_v_accountcontact..'

begin transaction 

begin try 

Insert into [Archive].[rpt_v_accountcontact]
(
ArchiveID,
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
select @ArchiveID,
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
from dbo.rpt_v_accountcontact

SET @Count = @@ROWCOUNT
SET @Message = cast(@Count as varchar(20)) + ' Records Archived'
raiserror (@Message, 10,1)


select @SourceCount = count(*) from [rpt_v_accountcontact]

SET @Message = 'Count of Records in dbo.[rpt_v_accountcontact]'

if @SourceCount = @Count
begin

SET @Message = 'rpt_v_accountcontact archived successfully!'
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
