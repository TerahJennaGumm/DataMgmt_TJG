
CREATE VIEW [dbo].[vw_CRS_MN_Products] as

--Retrieve all products from MetraNet with CLIN and Create Date

--Select all products from Metranet with Clin from t_base_props and create date from [dbo].[t_pl_map]
select *
from [$(DataMgmt_Metranet)].[dbo].[rpt_v_PoAndPi] p --1506
left join (				--join to b_base_props to get the CLIN for gov products
	select tbps.id_prop
	, tbps.nm_name
	, tbps.nm_desc
	, tbps.n_display_name
	, tbps.nm_display_name
	, td.tx_desc
	, p.id_pi as id_pi_tbase
	from [$(DataMgmt_Metranet)].[dbo].[t_base_props] tbps 
		LEFT JOIN [$(DataMgmt_Metranet)].[dbo].[t_description] td 
			ON tbps.n_name=td.id_desc
		inner join [$(DataMgmt_Metranet)].[dbo].[rpt_v_PoAndPi] p
			on tbps.id_prop = p.id_pi
	where tbps.nm_display_name LIKE '0%'
	)  tp on tp.id_pi_tbase = p.id_pi
left join (			--join to t_pl_map to get earliest create date
SELECT id_pi_instance
	,MIN(dt_modified) date_created 
FROM [$(DataMgmt_Metranet)].[dbo].[t_pl_map]
where id_paramtable IS null 
	AND id_sub IS NULL 
GROUP by id_po
, id_pi_instance 
) c on c.id_pi_instance = p.id_pi
left join (			--join to ili file to get latest bill date for MN Products
select distinct(id_pi) as id_pi_bill
, max(tcie.interval_end_date) as interval_end_date
--INTO #MN_BILL
FROM [$(DataMgmt_Metranet)].[dbo].[rpt_v_PoAndPi] rvpap 
	inner join [$(DataMgmt_Metranet)].[dbo].[T_CONCUR_ILI_EXPORT] tcie
		on rvpap.id_pi = tcie.id_pi_instance
group by id_pi
) b on b.id_pi_bill = p.id_pi
