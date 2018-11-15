CREATE VIEW vw_Metranet_Active_BusCu_Ids_BasedonCOID AS (
SELECT DISTINCT d.nm_login MetranetBusCustId,  o.Account_ID__c SFDCAcctId, rva.c_Company, a1.Name  --, f.nm_value, 
--d.nm_login AS business_login, d.id_acc as business_id_Acc, e.nm_login AS secondary_biz_login,  h.nm_login as Service_login, e.id_Acc AS secondary_biz_id_Acc,service_id_acc, id_sub, vt_end, id_po,nm_value, c_spec_name, o.Account_ID__c
FROM [$(DataMgmt_Metranet)].dbo.t_sub a WITH (NOLOCK) 
INNER JOIN [$(DataMgmt_Metranet)].dbo.rpt_v_AccountFlattenedHierarchy b ON b.service_id_acc = a.id_acc
LEFT OUTER JOIN [$(DataMgmt_Metranet)].dbo.rpt_v_account h WITH (NOLOCK) ON h.id_acc = b.service_id_acc
LEFT OUTER JOIN [$(DataMgmt_Metranet)].dbo.rpt_v_account d WITH (NOLOCK) on d.id_acc = b.business_id_acc 
LEFT OUTER JOIN [$(DataMgmt_Metranet)].dbo.t_char_values f with (NOLOCK) on( f.id_entity = id_sub and f. [c_spec_name] = 'ConcurOrderID') 
LEFT OUTER JOIN [$(DataMgmt_SFDC)].dbo.Opportunity o with (NOLOCK) ON o.id = LEFT(f.nm_value, 18)
LEFT OUTER JOIN [$(DataMgmt_Metranet)].dbo.rpt_v_accountcontact rva ON rva.id_acc = b.business_id_acc
LEFT OUTER JOIN [$(DataMgmt_SFDC)].dbo.Account a1 ON a1.id = o.Account_ID__c
WHERE a.vt_end >= GETDATE() AND a.id_po NOT IN (270, 685, 825, 987) 
AND  
( b.num_generations = 3 )
)
