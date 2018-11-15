
create view [dbo].[vw_ConcurOrderProviderContractID]
as  
SELECT 
SRC.ConcurOrderID
,subscription.id_sub
,SRC.S4ProviderContractID
FROM rpt_v_Subscription as subscription 
inner join 
(
select 
	so.ConcurOrderID
	,so.id_sub
	,tv.nm_value AS S4ProviderContractID
	,ROW_NUMBER() OVER (PARTITION BY sub.id_sub order by tv.c_start_date desc ) as RowRank
	from 
	vw_SubscriptionOrder as so 
	inner join rpt_v_Subscription as sub on so.id_sub = sub.id_sub
	INNER JOIN  t_char_values AS tv on sub.id_sub = tv.id_entity
	WHERE tv.c_spec_name = 'S4ProviderContractID' and nullif(tv.nm_value,'') is not null and tv.c_start_date >= sub.vt_start 
	) AS src  on subscription.id_sub = src.id_sub 
	where src.RowRank = 1 
	group by SRC.ConcurOrderID
,subscription.id_sub
,SRC.S4ProviderContractID