

  
CREATE PROCEDURE [dbo].[usp_Import_Metranet_tables]  
  
AS BEGIN  
  
SET NOCOUNT ON   
  
DECLARE 
@IsProd BIT = 0 ,
@Srvr VARCHAR(20) = ''   

  
TRUNCATE TABLE t_pl_map  
  
IF @IsProd = 0   
BEGIN  
SET @Srvr = '[ORACNRAAGD]'  
INSERT t_pl_map  
(  
dt_modified,
	id_paramtable,
	id_pi_type,
id_pi_template,
	id_pi_instance,
id_pi_instance_parent,
	id_sub,
	id_acc,
	id_po,
id_pricelist,
	b_canICB
)  
SELECT 	dt_modified,
	id_paramtable,
	id_pi_type,
id_pi_template,
	id_pi_instance,
id_pi_instance_parent,
	id_sub,
	id_acc,
	id_po,
id_pricelist,
	b_canICB   
  FROM METRANET_DEV02.NetMeter.dbo.t_pl_map  
END  
  
  
IF @IsProd = 1   
BEGIN  
SET @Srvr = '[ORAPROD]'  
INSERT t_pl_map  
(  
dt_modified,
	id_paramtable,
	id_pi_type,
id_pi_template,
	id_pi_instance,
id_pi_instance_parent,
	id_sub,
	id_acc,
	id_po,
id_pricelist,
	b_canICB
)  
SELECT 	dt_modified,
	id_paramtable,
	id_pi_type,
id_pi_template,
	id_pi_instance,
id_pi_instance_parent,
	id_sub,
	id_acc,
	id_po,
id_pricelist,
	b_canICB   
  FROM METRANET_DEV02.NetMeter.dbo.t_pl_map 
END  

TRUNCATE TABLE t_description  
  
IF @IsProd = 0   
BEGIN  
SET @Srvr = '[ORACNRAAGD]'  
INSERT t_description  
(  
id_desc,
	id_lang_code,
	tx_desc,
	tx_URL_desc
)  
SELECT 	id_desc,
	id_lang_code,
	tx_desc,
	tx_URL_desc
  FROM METRANET_DEV02.NetMeter.dbo.t_description  
END  
  
  
IF @IsProd = 1   
BEGIN  
SET @Srvr = '[ORAPROD]'  
INSERT t_description  
(  
id_desc,
	id_lang_code,
	tx_desc,
	tx_URL_desc
)  
SELECT 	id_desc,
	id_lang_code,
	tx_desc,
	tx_URL_desc
  FROM METRANET_DEV02.NetMeter.dbo.t_description  
END  

TRUNCATE TABLE T_CONCUR_ILI_EXPORT  
  
IF @IsProd = 0   
BEGIN  
SET @Srvr = '[ORACNRAAGD]'  
INSERT T_CONCUR_ILI_EXPORT  
(  
id_invoice_export,
ili_dt_crt,
id_usage_interval,
bill_group_id,
id_acc,
payee_id_acc,
orar_shipto_id_acc,
invoice_number,
invoice_string,
invoice_date,
interval_start_date,
interval_end_date,
invoice_line_number,
context,
line_type,
bill_nm_login,
ship_nm_login,
pi_description_external,
pi_description,
currency_code,
amount,
revrec_amount,
payment_terms,
org_id,
gst_code,
purchase_order,
sku,
invoice_uom,
uom_name,
tax_exempt_flag,
tax_exempt_number,
trans_count,
bundle_id_sub,
bundle_name,
id_sub,
is_master,
roll_up,
concur_item_type,
id_po,
id_pi_template,
id_pi_instance,
revrec_rate_tier,
revrec_rate,
billed_rate,
internal_comments,
quantity,
transaction_type,
is_revrec,
acc_charge_freq,
charge_start_date,
charge_end_date,
prod_category,
origsku,
inoutsku,
rule_duration,
forcemonthly,
tax_amount,
bundle_line_number,
IsRoundedAmount,
IsAggregated,
company_code,
company_description
)  
SELECT 
id_invoice_export,
ili_dt_crt,
id_usage_interval,
bill_group_id,
id_acc,
payee_id_acc,
orar_shipto_id_acc,
invoice_number,
invoice_string,
invoice_date,
interval_start_date,
interval_end_date,
invoice_line_number,
context,
line_type,
bill_nm_login,
ship_nm_login,
pi_description_external,
pi_description,
currency_code,
amount,
revrec_amount,
payment_terms,
org_id,
gst_code,
purchase_order,
sku,
invoice_uom,
uom_name,
tax_exempt_flag,
tax_exempt_number,
trans_count,
bundle_id_sub,
bundle_name,
id_sub,
is_master,
roll_up,
concur_item_type,
id_po,
id_pi_template,
id_pi_instance,
revrec_rate_tier,
revrec_rate,
billed_rate,
internal_comments,
quantity,
transaction_type,
is_revrec,
acc_charge_freq,
charge_start_date,
charge_end_date,
prod_category,
origsku,
inoutsku,
rule_duration,
forcemonthly,
tax_amount,
bundle_line_number,
IsRoundedAmount,
IsAggregated,
company_code,
company_description
  FROM METRANET_DEV02.NetMeter.dbo.T_CONCUR_ILI_EXPORT  
END  
  
  
IF @IsProd = 1   
BEGIN  
SET @Srvr = '[ORAPROD]'  
INSERT T_CONCUR_ILI_EXPORT  
(  
id_invoice_export,
ili_dt_crt,
id_usage_interval,
bill_group_id,
id_acc,
payee_id_acc,
orar_shipto_id_acc,
invoice_number,
invoice_string,
invoice_date,
interval_start_date,
interval_end_date,
invoice_line_number,
context,
line_type,
bill_nm_login,
ship_nm_login,
pi_description_external,
pi_description,
currency_code,
amount,
revrec_amount,
payment_terms,
org_id,
gst_code,
purchase_order,
sku,
invoice_uom,
uom_name,
tax_exempt_flag,
tax_exempt_number,
trans_count,
bundle_id_sub,
bundle_name,
id_sub,
is_master,
roll_up,
concur_item_type,
id_po,
id_pi_template,
id_pi_instance,
revrec_rate_tier,
revrec_rate,
billed_rate,
internal_comments,
quantity,
transaction_type,
is_revrec,
acc_charge_freq,
charge_start_date,
charge_end_date,
prod_category,
origsku,
inoutsku,
rule_duration,
forcemonthly,
tax_amount,
bundle_line_number,
IsRoundedAmount,
IsAggregated,
company_code,
company_description
)  
SELECT
id_invoice_export,
ili_dt_crt,
id_usage_interval,
bill_group_id,
id_acc,
payee_id_acc,
orar_shipto_id_acc,
invoice_number,
invoice_string,
invoice_date,
interval_start_date,
interval_end_date,
invoice_line_number,
context,
line_type,
bill_nm_login,
ship_nm_login,
pi_description_external,
pi_description,
currency_code,
amount,
revrec_amount,
payment_terms,
org_id,
gst_code,
purchase_order,
sku,
invoice_uom,
uom_name,
tax_exempt_flag,
tax_exempt_number,
trans_count,
bundle_id_sub,
bundle_name,
id_sub,
is_master,
roll_up,
concur_item_type,
id_po,
id_pi_template,
id_pi_instance,
revrec_rate_tier,
revrec_rate,
billed_rate,
internal_comments,
quantity,
transaction_type,
is_revrec,
acc_charge_freq,
charge_start_date,
charge_end_date,
prod_category,
origsku,
inoutsku,
rule_duration,
forcemonthly,
tax_amount,
bundle_line_number,
IsRoundedAmount,
IsAggregated,
company_code,
company_description
  FROM METRANET_DEV02.NetMeter.dbo.T_CONCUR_ILI_EXPORT
END  


TRUNCATE TABLE t_base_props
  
IF @IsProd = 0   
BEGIN  
SET @Srvr = '[ORACNRAAGD]'  
INSERT t_base_props 
(  
id_prop,
n_kind,
n_name,
n_desc,
nm_name,
nm_desc,
b_approved,
b_archive,
n_display_name,
nm_display_name
)  
SELECT 
id_prop,
n_kind,
n_name,
n_desc,
nm_name,
nm_desc,
b_approved,
b_archive,
n_display_name,
nm_display_name
  FROM METRANET_DEV02.NetMeter.dbo.t_base_props  
END  
  
  
IF @IsProd = 1   
BEGIN  
SET @Srvr = '[ORAPROD]'  
INSERT t_base_props 
(  
id_prop,
n_kind,
n_name,
n_desc,
nm_name,
nm_desc,
b_approved,
b_archive,
n_display_name,
nm_display_name
)  
SELECT 
id_prop,
n_kind,
n_name,
n_desc,
nm_name,
nm_desc,
b_approved,
b_archive,
n_display_name,
nm_display_name
  FROM METRANET_DEV02.NetMeter.dbo.t_base_props
END   

ExitProcedure:  
  
END  
   

