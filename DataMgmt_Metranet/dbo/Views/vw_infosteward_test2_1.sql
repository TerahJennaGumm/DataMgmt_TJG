create view [vw_infosteward_test2] as
with cte (id_entity, c_spec_name) as
(
select id_entity, c_spec_name from metranet_data.dbo.t_char_values
where c_spec_name in ('BISETriggerDate','CancelSubscription','ConcurOrderID','TimeAndMaterials','S4ProviderContractID','DateCreate')
)
select cte.c_spec_name, id_sub, id_po, id_acc, vt_start, vt_end, id_pi_instance, id_sched, c_ICBRateCustCurr, c_ICBRateUSD, dt_start, dt_end, ConcurOrderLineID, CancelSubscription 
from metranet_data.dbo.rpt_v_Subscription rv join cte on cte.id_entity = rv.id_sub
union
select cte.c_spec_name, id_sub, id_po, id_acc, vt_start, vt_end, id_pi_instance, id_sched, c_ICBRateCustCurr, c_ICBRateUSD, dt_start, dt_end, ConcurOrderLineID, CancelSubscription 
from metranet_data.dbo.rpt_v_SubscriptionGovernment rv join cte on cte.id_entity = rv.id_sub
union
select cte.c_spec_name, id_sub, id_po, id_acc, vt_start, vt_end, id_pi_instance, id_sched, c_ICBRateCustCurr, c_ICBRateUSD, dt_start, dt_end, ConcurOrderLineID, CancelSubscription 
from metranet_data.dbo.rpt_v_SubscriptionSelectAccess rv join cte on cte.id_entity = rv.id_sub