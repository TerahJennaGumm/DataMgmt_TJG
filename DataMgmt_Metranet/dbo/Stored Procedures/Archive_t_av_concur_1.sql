


CREATE PROCEDURE [dbo].[Archive_t_av_concur] (@ArchiveID INT)
AS
BEGIN

declare @Message varchar(255) = ''
,@Count int = 0
,@SourceCount int = 0


print 'Archiving t_av_concur..'

begin transaction 

begin try 

Insert into [Archive].[t_av_concur]
(
ArchiveID,
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
select @ArchiveID,
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
from dbo.t_av_concur

SET @Count = @@ROWCOUNT
SET @Message = cast(@Count as varchar(20)) + ' Records Archived'
raiserror (@Message, 10,1)


select @SourceCount = count(*) from [t_av_concur]

SET @Message = 'Count of Records in dbo.[t_av_concur]'

if @SourceCount = @Count
begin

SET @Message = 't_av_concur archived successfully!'
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