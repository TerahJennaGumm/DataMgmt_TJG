
CREATE PROCEDURE DM_PopulateConcurOrderLineIDXref
as
BEGIN
    -- populate from rpt_v_subscription
    insert into metranet_data.dbo.DM_ConcurOrderLineIDXref
    (ConcurOrderLineID, ConcurOrderLineIdRaw, ConcurOrderLineIDOldFormat, DateCreated)
    select distinct 
           ConcurOrderLineID as ConcurOrderLineID,
           ConcurOrderLineIDRaw as ConcurOrderLineIDRaw,
           cast(id_sub as nvarchar(20)) + '-' + cast(id_pi_instance as nvarchar(20)) + '-' + cast(id_sched as nvarchar(20)) + '-' + cast(n_order as nvarchar(20)) as ConcurOrderLineIDOldFormat,
           getdate()
      from metranet_data.dbo.rpt_v_subscription s
     where not exists
          (select 1
             from metranet_data.dbo.DM_ConcurOrderLineIDXref xref
            where xref.ConcurOrderLineID = s.ConcurOrderLineID
              and xref.ConcurOrderLineIDOldFormat = 
                  cast(s.id_sub as nvarchar(20)) + '-' + cast(s.id_pi_instance as nvarchar(20)) + '-' + cast(s.id_sched as nvarchar(20)) + '-' + cast(s.n_order as nvarchar(20))
          )

    -- populate from rpt_v_subscriptionGovernment
    insert into metranet_data.dbo.DM_ConcurOrderLineIDXref
    (ConcurOrderLineID, ConcurOrderLineIdRaw, ConcurOrderLineIDOldFormat, DateCreated)
    select distinct
           ConcurOrderLineID as ConcurOrderLineID,
           ConcurOrderLineIDRaw as ConcurOrderLineIDRaw,
           cast(id_sub as nvarchar(20)) + '-' + cast(id_pi_instance as nvarchar(20)) + '-' + cast(id_sched as nvarchar(20)) + '-' + cast(n_order as nvarchar(20)) as ConcurOrderLineIDOldFormat,
           getdate()
      from metranet_data.dbo.rpt_v_subscriptionGovernment s
     where not exists
          (select 1
             from metranet_data.dbo.DM_ConcurOrderLineIDXref xref
            where xref.ConcurOrderLineID = s.ConcurOrderLineID
              and xref.ConcurOrderLineIDOldFormat = 
                  cast(s.id_sub as nvarchar(20)) + '-' + cast(s.id_pi_instance as nvarchar(20)) + '-' + cast(s.id_sched as nvarchar(20)) + '-' + cast(s.n_order as nvarchar(20))
          )

    -- populate from rpt_v_subscriptionSelectAccess
    insert into metranet_data.dbo.DM_ConcurOrderLineIDXref
    (ConcurOrderLineID, ConcurOrderLineIdRaw, ConcurOrderLineIDOldFormat, DateCreated)
    select distinct
           ConcurOrderLineID as ConcurOrderLineID,
           ConcurOrderLineIDRaw as ConcurOrderLineIDRaw,
           cast(id_sub as nvarchar(20)) + '-' + cast(id_pi_instance as nvarchar(20)) + '-' + cast(id_sched as nvarchar(20)) + '-' + cast(n_order as nvarchar(20)) as ConcurOrderLineIDOldFormat,
           getdate()
      from metranet_data.dbo.rpt_v_subscriptionSelectAccess s
     where not exists
          (select 1
             from metranet_data.dbo.DM_ConcurOrderLineIDXref xref
            where xref.ConcurOrderLineID = s.ConcurOrderLineID
              and xref.ConcurOrderLineIDOldFormat = 
                  cast(s.id_sub as nvarchar(20)) + '-' + cast(s.id_pi_instance as nvarchar(20)) + '-' + cast(s.id_sched as nvarchar(20)) + '-' + cast(s.n_order as nvarchar(20))
          )

END
