
create view [dbo].[vw_SubscriptionOpportunityID]
as
SELECT 
SRC.SFDCOpportunityID
,subscription.id_sub
FROM rpt_v_Subscription as subscription
inner join 
(
SELECT	sub.id_sub
		,tv.nm_value AS SFDCOpportunityID
		,ROW_NUMBER() OVER (PARTITION BY sub.id_sub order by tv.c_start_date desc ) as RowRank
		from rpt_v_Subscription AS sub 
		INNER JOIN  t_char_values AS tv on sub.id_sub = tv.id_entity
		WHERE tv.c_spec_name = 'SFDCOpportunityID' and nullif(tv.nm_value,'') is not null and tv.c_start_date >= sub.vt_start 
)  AS SRC on subscription.id_sub = SRC.id_sub 
where RowRank = 1
group by subscription.id_sub
,SRC.SFDCOpportunityID
