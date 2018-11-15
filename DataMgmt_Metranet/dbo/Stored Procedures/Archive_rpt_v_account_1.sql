


CREATE PROCEDURE [dbo].[Archive_rpt_v_account] (@ArchiveID INT)
AS
BEGIN

declare @Message varchar(255) = ''
,@Count int = 0
,@SourceCount int = 0


print 'Archiving rpt_v_account..'

begin transaction 

begin try 

Insert into [Archive].[rpt_v_account]
(
ArchiveID,
id_acc,
nm_login,
nm_space,
t_account__dt_crt,
t_acccount_type__name,
c_CompanySize,
c_CustomerVAT,
c_EntityID,
c_SalesRep,
c_PurchaseOrderNum,
c_ForceMonthlyBilling,
c_ReferrerSFAID,
c_ReferringPartner,
c_ReferralDate,
c_LegacyEdition,
c_ContractSource,
c_ImplementationMethod,
c_BMILastQuoteID,
c_OrderEffectiveDate,
c_DisableBMIAddons,
c_TermNumMonths,
c_BusinessUnit,
c_segment,
c_Market,
c_RevenueGroup,
c_Region,
c_AccountChargeFrequency,
c_SalesChannel,
c_PaymentTerms,
c_ReferralType,
c_TaxExempt,
c_TaxExemptID,
c_SecurityAnswer,
c_StatusReasonOther,
c_Currency,
c_Billable,
c_TimezoneID,
c_PaymentMethod,
c_SecurityQuestion,
c_InvoiceMethod,
c_UsageCycleType,
c_Language,
c_StatusReason,
t_account_state__status,
t_account_state__vt_start,
c_CBTravelConfigID,
c_CBSFAID,
c_CBCompanyID,
c_CBMasterAcct,
c_CBAgencyID,
c_FutureAccountFrequency,
c_FutureAccountFrequencyDate,
c_S4BusinessPartnerID,
c_S4ContractAccountID
)
select @ArchiveID,
id_acc,
nm_login,
nm_space,
t_account__dt_crt,
t_acccount_type__name,
c_CompanySize,
c_CustomerVAT,
c_EntityID,
c_SalesRep,
c_PurchaseOrderNum,
c_ForceMonthlyBilling,
c_ReferrerSFAID,
c_ReferringPartner,
c_ReferralDate,
c_LegacyEdition,
c_ContractSource,
c_ImplementationMethod,
c_BMILastQuoteID,
c_OrderEffectiveDate,
c_DisableBMIAddons,
c_TermNumMonths,
c_BusinessUnit,
c_segment,
c_Market,
c_RevenueGroup,
c_Region,
c_AccountChargeFrequency,
c_SalesChannel,
c_PaymentTerms,
c_ReferralType,
c_TaxExempt,
c_TaxExemptID,
c_SecurityAnswer,
c_StatusReasonOther,
c_Currency,
c_Billable,
c_TimezoneID,
c_PaymentMethod,
c_SecurityQuestion,
c_InvoiceMethod,
c_UsageCycleType,
c_Language,
c_StatusReason,
t_account_state__status,
t_account_state__vt_start,
c_CBTravelConfigID,
c_CBSFAID,
c_CBCompanyID,
c_CBMasterAcct,
c_CBAgencyID,
c_FutureAccountFrequency,
c_FutureAccountFrequencyDate,
c_S4BusinessPartnerID,
c_S4ContractAccountID
from dbo.rpt_v_account

SET @Count = @@ROWCOUNT
SET @Message = cast(@Count as varchar(20)) + ' Records Archived'
raiserror (@Message, 10,1)


select @SourceCount = count(*) from [rpt_v_account]

SET @Message = 'Count of Records in dbo.[rpt_v_account]'

if @SourceCount = @Count
begin

SET @Message = 'rpt_v_account archived successfully!'
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