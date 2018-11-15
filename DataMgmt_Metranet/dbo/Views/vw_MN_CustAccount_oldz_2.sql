CREATE VIEW [vw_MN_CustAccount_oldz] as
SELECT DISTINCT d.nm_login AS business_login, d.id_acc as business_id_Acc, e.nm_login AS secondary_biz_login, e.id_Acc AS secondary_biz_id_Acc
 FROM t_sub a WITH (NOLOCK)
 INNER JOIN dbo.rpt_v_AccountFlattenedHierarchy b ON b.service_id_acc = a.id_acc
 LEFT OUTER JOIN t_account_mapper d WITH (NOLOCK) on d.id_acc = b.business_id_acc
 LEFT OUTER join t_account_mapper e WITH (NOLOCK) on d.id_acc = b.secondary_business_id_acc
 WHERE a.vt_end >= GETDATE() AND a.id_po NOT IN (270, 685, 825, 987)
 UNION all
 SELECT DISTINCT d.nm_login AS business_login, d.id_acc as business_id_Acc, e.nm_login AS secondary_biz_login, e.id_Acc AS secondary_biz_id_Acc
 FROM t_sub a WITH (NOLOCK)
 INNER JOIN dbo.rpt_v_AccountFlattenedHierarchy b ON b.billing_id_acc = a.id_acc
 LEFT OUTER JOIN t_account_mapper d WITH (NOLOCK) on d.id_acc = b.business_id_acc
 LEFT OUTER join t_account_mapper e WITH (NOLOCK) on d.id_acc = b.secondary_business_id_acc
 WHERE a.vt_end >= GETDATE() AND a.id_po NOT IN (270, 685, 825, 987)
 UNION all
 SELECT DISTINCT d.nm_login AS business_login, d.id_acc as business_id_Acc, e.nm_login AS secondary_biz_login, e.id_Acc AS secondary_biz_id_Acc
 FROM t_sub a WITH (NOLOCK)
 INNER JOIN dbo.rpt_v_AccountFlattenedHierarchy b ON b.business_id_acc = a.id_acc
 LEFT OUTER JOIN t_account_mapper d WITH (NOLOCK) on d.id_acc = b.business_id_acc
 LEFT OUTER join t_account_mapper e WITH (NOLOCK) on d.id_acc = b.secondary_business_id_acc
 WHERE a.vt_end >= GETDATE() AND a.id_po NOT IN (270, 685, 825, 987)
 UNION all
 SELECT DISTINCT d.nm_login AS business_login, d.id_acc as business_id_Acc, e.nm_login AS secondary_biz_login, e.id_Acc AS secondary_biz_id_Acc
 FROM t_sub a WITH (NOLOCK)
 INNER JOIN dbo.rpt_v_AccountFlattenedHierarchy b ON b.secondary_business_id_acc = a.id_acc
 LEFT OUTER JOIN t_account_mapper d WITH (NOLOCK) on d.id_acc = b.business_id_acc
 LEFT OUTER join t_account_mapper e WITH (NOLOCK) on d.id_acc = b.secondary_business_id_acc
 WHERE a.vt_end >= GETDATE() AND a.id_po NOT IN (270, 685, 825, 987) 