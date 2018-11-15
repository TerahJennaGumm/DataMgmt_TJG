

CREATE view [dbo].[vw_Metranet_PrimaryBusinessCustomer_Status] as (
select z.id_acc MNAccountId, z.nm_login MNAccountName , "MNCustomerStatus" = 
Case 
when max(a.vt_end)<= GETDATE()  then 'Inactive'
when max(a.vt_end)>= GETDATE()  then 'Active'
END 
from [$(DataMgmt_Metranet)].dbo.t_sub a 
JOIN [$(DataMgmt_Metranet)].dbo.rpt_v_AccountFlattenedHierarchy b 
ON b.service_id_acc = a.id_acc
join [$(DataMgmt_Metranet)].dbo.t_account_mapper z
on z.id_acc = b.business_id_acc --or z.id_acc = b.secondary_business_id_acc
where a.id_po NOT IN (270, 685, 825, 987)
group by z.id_acc, z.nm_login
--order by z.nm_login --57609 3 sec
)



