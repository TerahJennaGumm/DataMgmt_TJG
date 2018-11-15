

create view [dbo].[vw_t_cnqr_provider_con_line_map_UAT03] as
SELECT 
SourceData.id
,SourceData.id_sub
,SourceData.id_po_instance
,SourceData.id_pi_instance
,SourceData.id_sched
,SourceData.out_of_term_line
,SourceData.concur_line_item_id
,SourceData.Concur_Line_Item_ID_Lookup
,SourceData.provider_con_id
,SourceData.provider_con_line_num
,SourceData.provider_con_line_id
,SourceData.business_partner_id
,SourceData.contract_account_id
,SourceData.concur_order_id
,SourceData.date_created
,SourceData.mn_customer_id
,SourceData.billing_account_id
,SourceData.service_account_id
,SourceData.material_id
--CSYS-72231
,SourceData.OverrideValidFromDate
,SourceData.S4ValidFrom
,SourceData.S4ValidTo
,SourceData.S4EndOfDuration
,SourceData.S4MoveStartFlag
,SourceData.S4MoveEndFlag
,SourceData.S4MoveDurationFlag
,SourceData.S4BillingCycle
,SourceData.S4Currency
,SourceData.subsidiary_business_partner_id
FROM 
(
SELECT m.id
,m.id_sub
,m.id_po_instance
,m.id_pi_instance
,m.id_sched
,m.out_of_term_line
,m.concur_line_item_id
,m.[Concur_Line_Item_ID_Lookup]
,m.provider_con_id
,m.provider_con_line_num
,m.provider_con_line_id
,m.business_partner_id
,m.contract_account_id
,m.concur_order_id
,m.date_created
,m.mn_customer_id
,m.billing_account_id
,m.service_account_id
,m.material_id
,ROW_NUMBER() OVER (
PARTITION BY m.concur_order_id
,m.concur_line_item_id
ORDER BY  m.id desc 
) AS RowRank
,m.OverrideValidFromDate
,m.S4ValidFrom
,m.S4ValidTo
,m.S4EndOfDuration
,m.S4MoveStartFlag
,m.S4MoveEndFlag
,m.S4MoveDurationFlag
,m.S4BillingCycle
,m.S4Currency
,m.subsidiary_business_partner_id
FROM Metranet_data.dbo.t_cnqr_provider_con_line_map_UAT03 m WHERE m.id_sub is not null
) AS SourceData  WHERE SourceData.RowRank = 1
