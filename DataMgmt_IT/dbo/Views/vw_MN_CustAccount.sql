

create view [dbo].[vw_MN_CustAccount] as
with cte(business_id_acc, secondary_business_id_acc )
as
(
select b.business_id_acc, b.secondary_business_id_acc 
from [DataMgmt_Metranet].dbo.t_sub a JOIN [DataMgmt_Metranet].dbo.rpt_v_AccountFlattenedHierarchy b ON b.service_id_acc = a.id_acc
WHERE a.vt_end >= GETDATE() AND a.id_po NOT IN (270, 685, 825, 987)
union
select  b.business_id_acc, b.secondary_business_id_acc  
from [DataMgmt_Metranet].dbo.t_sub a JOIN [DataMgmt_Metranet].dbo.rpt_v_AccountFlattenedHierarchy b ON b.billing_id_acc = a.id_acc
WHERE a.vt_end >= GETDATE() AND a.id_po NOT IN (270, 685, 825, 987)
union
select  b.business_id_acc, b.secondary_business_id_acc  
from [DataMgmt_Metranet].dbo.t_sub a JOIN [DataMgmt_Metranet].dbo.rpt_v_AccountFlattenedHierarchy b ON b.business_id_acc = a.id_acc
WHERE a.vt_end >= GETDATE() AND a.id_po NOT IN (270, 685, 825, 987)
union
select  b.business_id_acc, b.secondary_business_id_acc  
from [DataMgmt_Metranet].dbo.t_sub a JOIN [DataMgmt_Metranet].dbo.rpt_v_AccountFlattenedHierarchy b ON b.secondary_business_id_acc = a.id_acc
WHERE a.vt_end >= GETDATE() AND a.id_po NOT IN (270, 685, 825, 987)
)

select d.nm_login AS business_login, d.id_acc AS business_id_Acc
,e.nm_login AS secondary_biz_login, e.id_Acc AS secondary_biz_id_Acc 
from cte z
LEFT JOIN [DataMgmt_Metranet].dbo.t_account_mapper d  ON d.id_acc = z.business_id_acc
LEFT JOIN [DataMgmt_Metranet].dbo.t_account_mapper e  ON e.id_acc = z.secondary_business_id_acc

