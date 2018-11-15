
CREATE view [dbo].[vw_ConcurOrderDate]
as
-- from t_char_values get the value for the 'DateCreate' attribute
-- if 'DateCreate' attribute is not present, use the start date of the ConcurOrderID
SELECT 
suborder.ConcurOrderID
,isnull(sub_Date.DateCreate,subOrder.OrderStartDate) as OrderCreatedDate
,subOrder.id_sub
from [dbo].[vw_SubscriptionOrder] as subOrder
left join 
(
		SELECT 
		subscription.id_sub
		,convert(DATETIME2 ,SRC.DateCreate, 101) as DateCreate
		FROM rpt_v_Subscription as subscription
		inner join 
		(
		SELECT	sub.id_sub
				,tv.nm_value AS DateCreate
				,ROW_NUMBER() OVER (PARTITION BY sub.id_sub order by tv.c_start_date desc ) as RowRank
				from rpt_v_Subscription AS sub 
				INNER JOIN  t_char_values AS tv on sub.id_sub = tv.id_entity
				WHERE tv.c_spec_name = 'DateCreate' and nullif(tv.nm_value,'') is not null and tv.c_start_date >= sub.vt_start 
		)  AS SRC on subscription.id_sub = SRC.id_sub 
		where RowRank = 1
		group by subscription.id_sub
		,convert(DATETIME2 ,SRC.DateCreate, 101)
) AS sub_Date on subOrder.id_sub = sub_date.id_sub