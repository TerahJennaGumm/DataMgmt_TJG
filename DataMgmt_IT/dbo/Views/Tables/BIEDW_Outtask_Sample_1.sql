CREATE TABLE [dbo].[BIEDW_Outtask_Sample] (
    [dm_sha1_hash]                   NVARCHAR (255) NULL,
    [dm_operation_type]              FLOAT (53)     NULL,
    [uuid]                           NVARCHAR (255) NULL,
    [internet_domain]                NVARCHAR (255) NULL,
    [entity_id]                      NVARCHAR (255) NULL,
    [dm_hdp_logging_id]              NVARCHAR (255) NULL,
    [dm_create_utc_date]             NVARCHAR (255) NULL,
    [contract_external_reference_id] NVARCHAR (255) NULL,
    [concur_guid]                    NVARCHAR (255) NULL,
    [company_name]                   NVARCHAR (255) NULL,
    [travel_config_id]               FLOAT (53)     NULL,
    [company_id]                     FLOAT (53)     NULL,
    [active_switch]                  FLOAT (53)     NULL,
    [is_billable]                    FLOAT (53)     NULL
);


GO
CREATE NONCLUSTERED INDEX [NonClusteredIndex-20180920-124604]
    ON [dbo].[BIEDW_Outtask_Sample]([travel_config_id] ASC, [company_id] ASC);

