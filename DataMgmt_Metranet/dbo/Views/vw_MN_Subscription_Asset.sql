CREATE view vw_MN_Subscription_Asset
as
with cte (id_sub, id_po, id_acc, vt_start, vt_end, id_pi_instance, id_sched, c_ICBRateCustCurr, c_ICBRateUSD, dt_start, dt_end, ConcurOrderLineID, CancelSubscription, nm_login)
as
(
select id_sub, id_po, rvs.id_acc, vt_start, vt_end, id_pi_instance, id_sched, c_ICBRateCustCurr, c_ICBRateUSD, dt_start, dt_end, ConcurOrderLineID, CancelSubscription, rva.nm_login 
from metranet_data.dbo.rpt_v_Subscription rvs join metranet_data.dbo.rpt_v_account rva ON rvs.id_acc = rva.id_acc
union
select id_sub, id_po, rvs.id_acc, vt_start, vt_end, id_pi_instance, id_sched, c_ICBRateCustCurr, c_ICBRateUSD, dt_start, dt_end, ConcurOrderLineID, CancelSubscription, rva.nm_login 
from metranet_data.dbo.rpt_v_SubscriptionGovernment rvs join metranet_data.dbo.rpt_v_account rva ON rvs.id_acc = rva.id_acc
union
select id_sub, id_po, rvs.id_acc, vt_start, vt_end, id_pi_instance, id_sched, c_ICBRateCustCurr, c_ICBRateUSD, dt_start, dt_end, ConcurOrderLineID, CancelSubscription, rva.nm_login  
from metranet_data.dbo.rpt_v_SubscriptionSelectAccess rvs join metranet_data.dbo.rpt_v_account rva ON rvs.id_acc = rva.id_acc
union
select id_sub, id_po, rvs.id_acc, vt_start, vt_end, id_pi_instance, id_sched, c_ICBRateCustCurr, c_ICBRateUSD, dt_start, dt_end, ConcurOrderLineID, CancelSubscription, rva.nm_login 
from metranet_data.dbo.rpt_v_Subscription_Compleat_GDSX rvs join metranet_data.dbo.rpt_v_account rva ON rvs.id_acc = rva.id_acc
)

SELECT 
rvs.*,
a.AccountId, a.Asset_ID__c, a.Billing_Cycle__c, a.Billing_ID__c, a.Bundled__c, 
a.Bundle_ID__c, a.Customer_Currency_Rev_Rec_Monthly__c, a.Customer_Currency_Rev_Rec__c, 
a.Customer_Currency__c, a.Id, a.Item_Type__c, a.MN_PI_ID__c, a.MN_PO_ID__c, a.MN_Subscription_ID__c, 
a.MN_Update_ID__c, a.Next_Bill_Date__c, a.Number_of_Committed_Trnxs__c, a.Number_of_Committed_Trnxs_Billing_Cycle__c, 
a.Number_of_Committed_Trnxs_Monthly__c, a.Opportunity__c, a.Opportunity_Product_ID__c, a.Opportunity_Type__c, 
a.Service_Acct_ID__c, a.Status, a.PurchaseDate, a.Purchase_Quote__c, a.Asset_Begin_Date__c, a.CreatedById, a.CreatedDate 
FROM cte rvs
LEFT JOIN salesforce_data.dbo.Asset a ON 
rvs.nm_login = a.Service_Acct_ID__c AND
rvs.id_sub = a.MN_Subscription_ID__c AND
rvs.id_pi_instance = a.MN_PI_ID__c