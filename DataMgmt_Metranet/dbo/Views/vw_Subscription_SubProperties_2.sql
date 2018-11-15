

CREATE VIEW [dbo].[vw_Subscription_SubProperties] AS
WITH cte (id_entity, BISETriggerDate, CancelSubscription, ConcurOrderID, TimeAndMaterials, S4ProviderContractID, DateCreate) AS
(
SELECT  id_entity,
MIN(CASE WHEN c_spec_name = 'BISETriggerDate' THEN nm_value ELSE NULL END) AS BISETriggerDate,
MIN(CASE WHEN c_spec_name = 'CancelSubscription' THEN nm_value ELSE NULL END) AS CancelSubscription,
MIN(CASE WHEN c_spec_name = 'ConcurOrderID' THEN nm_value ELSE NULL END) AS ConcurOrderID,
MIN(CASE WHEN c_spec_name = 'TimeAndMaterials' THEN nm_value ELSE NULL END) AS TimeAndMaterials,
MIN(CASE WHEN c_spec_name = 'S4ProviderContractID' THEN nm_value ELSE NULL END) AS S4ProviderContractID ,
MIN(CASE WHEN c_spec_name = 'DateCreate' THEN nm_value ELSE NULL END)AS DateCreate
FROM t_char_values GROUP BY (id_entity)
)

SELECT cte.BISETriggerDate, cte.CancelSubscription, cte.ConcurOrderID, cte.TimeAndMaterials, cte.S4ProviderContractID,cte.DateCreate, id_sub, id_po, id_acc, vt_start, vt_end, id_pi_instance, id_sched, c_ICBRateCustCurr, c_ICBRateUSD, dt_start, dt_end, ConcurOrderLineID, rv.CancelSubscription AS 'rpt_CancelSubscription'
FROM rpt_v_Subscription rv JOIN cte ON cte.id_entity = rv.id_sub
UNION
SELECT cte.BISETriggerDate, cte.CancelSubscription, cte.ConcurOrderID, cte.TimeAndMaterials, cte.S4ProviderContractID,cte.DateCreate, id_sub, id_po, id_acc, vt_start, vt_end, id_pi_instance, id_sched, c_ICBRateCustCurr, c_ICBRateUSD, dt_start, dt_end, ConcurOrderLineID, rv.CancelSubscription AS 'rpt_CancelSubscription'
FROM rpt_v_SubscriptionGovernment rv JOIN cte ON cte.id_entity = rv.id_sub
UNION
SELECT cte.BISETriggerDate, cte.CancelSubscription, cte.ConcurOrderID, cte.TimeAndMaterials, cte.S4ProviderContractID,cte.DateCreate, id_sub, id_po, id_acc, vt_start, vt_end, id_pi_instance, id_sched, c_ICBRateCustCurr, c_ICBRateUSD, dt_start, dt_end, ConcurOrderLineID, rv.CancelSubscription AS 'rpt_CancelSubscription'
FROM rpt_v_SubscriptionSelectAccess rv JOIN cte ON cte.id_entity = rv.id_sub
UNION
SELECT cte.BISETriggerDate, cte.CancelSubscription, cte.ConcurOrderID, cte.TimeAndMaterials, cte.S4ProviderContractID,cte.DateCreate, id_sub, id_po, id_acc, vt_start, vt_end, id_pi_instance, id_sched, c_ICBRateCustCurr, c_ICBRateUSD, dt_start, dt_end, ConcurOrderLineID, rv.CancelSubscription AS 'rpt_CancelSubscription'
FROM rpt_v_Subscription_Compleat_GDSX rv JOIN cte ON cte.id_entity = rv.id_sub
