

create view [dbo].[vw_ConcurOrderSAPSubmitDate]
as 
SELECT 
suborder.ConcurOrderID
,sub_Date.LastDateSubmittoSAP
,subOrder.id_sub
from [dbo].[vw_SubscriptionOrder] as subOrder
left join 
(
		SELECT 
		subscription.id_sub
		,src.LastDateSubmittoSAP
		FROM rpt_v_Subscription as subscription
		inner join 
		(
		SELECT	sub.id_sub
				,case when convert(DATETIME2 ,nm_value, 101) IN ('0001-01-01','1900-01-01') then NULL 
					else convert(DATETIME2 ,nm_value, 101) end AS LastDateSubmittoSAP
				,ROW_NUMBER() OVER (PARTITION BY sub.id_sub order by tv.c_start_date desc ) as RowRank
				from rpt_v_Subscription AS sub 
				INNER JOIN  t_char_values AS tv on sub.id_sub = tv.id_entity
				WHERE tv.c_spec_name = 'LASTDATESUBMITTOSAP' and tv.c_start_date >= sub.vt_start 
		)  AS SRC on subscription.id_sub = SRC.id_sub 
		where RowRank = 1
		group by subscription.id_sub,LastDateSubmittoSAP
		
) AS sub_Date on subOrder.id_sub = sub_date.id_sub