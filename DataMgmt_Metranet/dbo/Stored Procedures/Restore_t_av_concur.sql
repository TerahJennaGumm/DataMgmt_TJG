


CREATE PROCEDURE dbo.Restore_t_av_concur (@ArchiveID INT)
AS
BEGIN

declare @Message varchar(255) = ''
,@Count int = 0
,@SourceCount int = 0


print 'Restoring t_av_concur..'

begin transaction 

begin try 

if exists (select 'Y' from Archive.t_av_concur where ArchiveID = @ArchiveID)
begin

truncate table dbo.t_av_concur  

Insert into dbo.t_av_concur
(
id_acc,
c_BusinessUnit,
c_CompanySize,
c_PaymentMethodStartDate,
c_PaymentMethodEndDate,
c_CustomerVAT,
c_EntityID,
c_SalesRep,
c_Affiliation,
c_Segment,
c_Market,
c_RevenueGroup,
c_Region,
c_AccountChargeFrequency,
c_SalesChannel,
c_PaymentTerms,
c_PurchaseOrderNum,
c_ForceMonthlyBilling,
c_InitialTermDate,
c_ReferrerSFAID,
c_ReferralType,
c_SpecialTerms,
c_RecordType,
c_ReferringPartner2,
c_ReferralType2,
c_LegacyEdition,
c_ContractSource,
c_ImplementationMethod,
c_ReferringPartner,
c_ReferralDate,
c_ReferralSalesRepName,
c_PartnerSegment,
c_BMILastQuoteID,
c_OrderEffectiveDate,
c_DisableBMIAddons,
c_ReferringPartnerCategory,
c_TravelDataCenter,
c_TermNumMonths,
c_FutureAccountFrequency,
c_FutureAccountFrequencyDate,
c_SFDCOpportunityID,
c_InvoiceAggregationFlag,
c_OrigCompanyName,
c_Theater,
c_Comments,
c_CommentEndDate,
c_AlternatePurchaseOrderNum,
c_BMIOrderforAlternatePONumber,
c_S4BusinessPartnerID,
c_S4ContractAccountID,
c_CompanyDescription,
c_CompanyCode,
c_HoldOrderFlag,
c_BillingExceptionFlag,
c_CorporateSubsidiaryBilling)
select
id_acc,
c_BusinessUnit,
c_CompanySize,
c_PaymentMethodStartDate,
c_PaymentMethodEndDate,
c_CustomerVAT,
c_EntityID,
c_SalesRep,
c_Affiliation,
c_Segment,
c_Market,
c_RevenueGroup,
c_Region,
c_AccountChargeFrequency,
c_SalesChannel,
c_PaymentTerms,
c_PurchaseOrderNum,
c_ForceMonthlyBilling,
c_InitialTermDate,
c_ReferrerSFAID,
c_ReferralType,
c_SpecialTerms,
c_RecordType,
c_ReferringPartner2,
c_ReferralType2,
c_LegacyEdition,
c_ContractSource,
c_ImplementationMethod,
c_ReferringPartner,
c_ReferralDate,
c_ReferralSalesRepName,
c_PartnerSegment,
c_BMILastQuoteID,
c_OrderEffectiveDate,
c_DisableBMIAddons,
c_ReferringPartnerCategory,
c_TravelDataCenter,
c_TermNumMonths,
c_FutureAccountFrequency,
c_FutureAccountFrequencyDate,
c_SFDCOpportunityID,
c_InvoiceAggregationFlag,
c_OrigCompanyName,
c_Theater,
c_Comments,
c_CommentEndDate,
c_AlternatePurchaseOrderNum,
c_BMIOrderforAlternatePONumber,
c_S4BusinessPartnerID,
c_S4ContractAccountID,
c_CompanyDescription,
c_CompanyCode,
c_HoldOrderFlag,
c_BillingExceptionFlag,
c_CorporateSubsidiaryBilling
from Archive.t_av_concur
where ArchiveID = @ArchiveID

SET @Count = @@ROWCOUNT
SET @Message = cast(@Count as varchar(20)) + ' records restored'
raiserror (@Message, 10,1)


select @SourceCount = count(*) from Archive.t_av_concur where ArchiveID = @ArchiveID

SET @Message = cast(@SourceCount as varchar(20)) + ' records in Archive.t_av_concur for ArchiveID ' + cast(@ArchiveID as varchar(20))

if @SourceCount = @Count
begin

SET @Message = 't_av_concur restored successfully!'
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
