

create view [dbo].[vw_MN_ActiveSubscription] as 
SELECT DISTINCT d.nm_login AS business_login, d.id_acc as business_id_Acc, e.nm_login AS secondary_biz_login,  h.nm_login as Service_login, e.id_Acc AS secondary_biz_id_Acc,service_id_acc, id_sub, vt_end, id_po,nm_value, c_spec_name
FROM [DataMgmt_Metranet].dbo.t_sub a WITH (NOLOCK) 
INNER JOIN [DataMgmt_Metranet].dbo.rpt_v_AccountFlattenedHierarchy b ON b.service_id_acc = a.id_acc
LEFT OUTER JOIN [DataMgmt_Metranet].dbo.t_account_mapper h WITH (NOLOCK) ON h.id_acc = b.service_id_acc
LEFT OUTER JOIN [DataMgmt_Metranet].dbo.t_account_mapper d WITH (NOLOCK) on d.id_acc = b.business_id_acc 
LEFT OUTER JOIN [DataMgmt_Metranet].dbo.t_account_mapper e WITH (NOLOCK) on e.id_acc = b.secondary_business_id_acc 
LEFT OUTER JOIN [DataMgmt_Metranet].dbo.t_char_values f with (NOLOCK) on( f.id_entity = id_sub and f. [c_spec_name] = 'ConcurOrderID') 
WHERE a.vt_end >= GETDATE() AND a.id_po NOT IN (270, 685, 825, 987) 
UNION all 
SELECT DISTINCT d.nm_login AS business_login, d.id_acc as business_id_Acc, e.nm_login AS secondary_biz_login,  h.nm_login as Service_login, e.id_Acc AS secondary_biz_id_Acc,service_id_acc, id_sub, vt_end, id_po,nm_value, c_spec_name 
FROM [DataMgmt_Metranet].dbo.t_sub a WITH (NOLOCK) 
INNER JOIN [DataMgmt_Metranet].dbo.rpt_v_AccountFlattenedHierarchy b ON b.billing_id_acc = a.id_acc 
LEFT OUTER JOIN [DataMgmt_Metranet].dbo.t_account_mapper h WITH (NOLOCK) ON h.id_acc = b.service_id_acc
LEFT OUTER JOIN [DataMgmt_Metranet].dbo.t_account_mapper d WITH (NOLOCK) on d.id_acc = b.business_id_acc 
LEFT OUTER join [DataMgmt_Metranet].dbo.t_account_mapper e WITH (NOLOCK) on e.id_acc = b.secondary_business_id_acc 
LEFT OUTER JOIN [DataMgmt_Metranet].dbo.t_char_values f with (NOLOCK) on( f.id_entity = id_sub and f. [c_spec_name] = 'ConcurOrderID') 
WHERE a.vt_end >= GETDATE() AND a.id_po NOT IN (270, 685, 825, 987) 
UNION all 
SELECT DISTINCT d.nm_login AS business_login, d.id_acc as business_id_Acc, e.nm_login AS secondary_biz_login,  h.nm_login as Service_login, e.id_Acc AS secondary_biz_id_Acc,service_id_acc, id_sub, vt_end, id_po,nm_value, c_spec_name
FROM [DataMgmt_Metranet].dbo.t_sub a WITH (NOLOCK) 
INNER JOIN [DataMgmt_Metranet].dbo.rpt_v_AccountFlattenedHierarchy b ON b.business_id_acc = a.id_acc 
LEFT OUTER JOIN [DataMgmt_Metranet].dbo.t_account_mapper h WITH (NOLOCK) ON h.id_acc = b.service_id_acc
LEFT OUTER JOIN [DataMgmt_Metranet].dbo.t_account_mapper d WITH (NOLOCK) on d.id_acc = b.business_id_acc 
LEFT OUTER join [DataMgmt_Metranet].dbo.t_account_mapper e WITH (NOLOCK) on e.id_acc = b.secondary_business_id_acc 
LEFT OUTER JOIN [DataMgmt_Metranet].dbo.t_char_values f with (NOLOCK) on (f.id_entity = id_sub and f. [c_spec_name] = 'ConcurOrderID') 
WHERE a.vt_end >= GETDATE() AND a.id_po NOT IN (270, 685, 825, 987) 
UNION all 
SELECT DISTINCT d.nm_login AS business_login, d.id_acc as business_id_Acc, e.nm_login AS secondary_biz_login,  h.nm_login as Service_login, e.id_Acc AS secondary_biz_id_Acc,service_id_acc, id_sub, vt_end, id_po,nm_value, c_spec_name
FROM [DataMgmt_Metranet].dbo.t_sub a WITH (NOLOCK) 
INNER JOIN [DataMgmt_Metranet].dbo.rpt_v_AccountFlattenedHierarchy b ON b.secondary_business_id_acc = a.id_acc 
LEFT OUTER JOIN [DataMgmt_Metranet].dbo.t_account_mapper h WITH (NOLOCK) ON h.id_acc = b.service_id_acc
LEFT OUTER JOIN [DataMgmt_Metranet].dbo.t_account_mapper d WITH (NOLOCK) on d.id_acc = b.business_id_acc 
LEFT OUTER join [DataMgmt_Metranet].dbo.t_account_mapper e WITH (NOLOCK) on e.id_acc = b.secondary_business_id_acc 
LEFT OUTER JOIN [DataMgmt_Metranet].dbo.t_char_values f with (NOLOCK) on (f.id_entity = id_sub and f. [c_spec_name] = 'ConcurOrderID') 
WHERE a.vt_end >= GETDATE() AND a.id_po NOT IN (270, 685, 825, 987)
