create view dbo.Active_MNSubs_Assets_OpptyLIne_PILevel as
SELECT 
distinct  f.id_entity SubProperties_SubId, f.nm_value SubProperties_COID 
, a.id_sub Sub_Sub_Id, a.id_acc Sub_ServAcctID, a.vt_start Sub_Start, a.vt_end Sub_End
, ass.AccountId Assets_AccountId, ass.Id AssetID , ass.Name Assets_Name, ass.Status Assets_Status, ass.Opportunity__c Assets_OppoId, ass.Purchase_Quote__c Assets_Quote, ass.Service_Acct_ID__c Assets_ServAcctID , ass.MN_Subscription_ID__c Assets_SubId,  ass.MN_PO_ID__c Assets_MNPOId, ass.MN_PI_ID__c Assets_MNPIID, ass.Item_Type__c Assets_ItemType, ass.MN_Update_ID__c Assets_MNUpdateID
, o.Name Oppty_Name, o.Id OpptyID, o.AccountID Oppty_AccountId, o.HasOpportunityLineItem oppty_LineItemExist, o.StageName Oppty_Stage, o.type oppty_Type
,  li.MN_PO_ID__c, li.MN_PI_ID__c , li.Item_Type__c,li.Quote_Number__c OppptyLine_Quote, li.Asset_ID__c OpptyLine_AssetId
FROM t_sub a WITH (NOLOCK)
LEFT OUTER JOIN t_char_values f with (NOLOCK) on( f.id_entity = id_sub and f. [c_spec_name] = 'ConcurOrderID')
FULL outer join salesforce_data.dbo.asset ass on ((ass.Opportunity__c = LEFt(f.nm_value,18) and a.id_po = MN_PO_ID__c))
LEFT OUTER JOIN salesforce_data.dbo.Opportunity o ON ( LEFt(f.nm_value,18) = o.Id ) --OR (ass.Opportunity__c = o.Id ) 
left outer join salesforce_data.dbo.OpportunityLineItem li ON (o.Id = li.OpportunityId AND li.MN_PO_ID__c = a.id_po and li.MN_PI_ID__c = ass.MN_PI_ID__c)
WHERE a.vt_end >= GETDATE() AND a.id_po NOT IN (270, 685, 825, 987)