CREATE TABLE [dbo].[rpt_v_PoAndPi] (
    [id_po]                       INT            NULL,
    [id_po__nm_display_name]      NVARCHAR (255) NULL,
    [dt_start]                    DATETIME       NULL,
    [dt_end]                      DATETIME       NULL,
    [c_POCategory]                NVARCHAR (99)  NULL,
    [c_UOM]                       NVARCHAR (150) NOT NULL,
    [c_UOMType]                   NVARCHAR (150) NOT NULL,
    [c_UOMBlocks]                 INT            NOT NULL,
    [c_IsBundle]                  CHAR (1)       NOT NULL,
    [c_HasRamps]                  CHAR (1)       NOT NULL,
    [c_HasTermOfCommitment]       CHAR (1)       NOT NULL,
    [c_Edition]                   NVARCHAR (99)  NULL,
    [c_ProductFamily]             NVARCHAR (99)  NULL,
    [c_MultQuanAddonsAllowed]     CHAR (1)       NULL,
    [c_ServiceCatalog]            NVARCHAR (255) NOT NULL,
    [c_OptOut]                    CHAR (1)       NULL,
    [c_ProductLine]               NVARCHAR (255) NULL,
    [c_isLegacy]                  CHAR (1)       NULL,
    [c_isNotSupportedinBMI]       CHAR (1)       NULL,
    [c_isAbstainListPriceUpdates] CHAR (1)       NULL,
    [id_pi]                       INT            NOT NULL,
    [id_pi__nm_display_name]      NVARCHAR (255) NULL,
    [c_SKU]                       NVARCHAR (150) NOT NULL,
    [c_InOutSKU]                  NVARCHAR (150) NULL,
    [c_GSTCode]                   NVARCHAR (255) NULL,
    [c_ConcurItemType]            NVARCHAR (255) NULL,
    [c_Rollup]                    CHAR (1)       NULL,
    [c_UnitOrFixed]               NVARCHAR (255) NULL,
    [ep_type]                     VARCHAR (12)   NOT NULL,
    [b_advance]                   CHAR (1)       NULL,
    [c_MaterialID]                NVARCHAR (150) NULL,
    [c_GLAccount]                 BIGINT         NULL,
    [c_FulfType]                  NVARCHAR (255) NULL,
    [c_ExclAllocation]            CHAR (1)       NULL,
    [c_TypeDesc]                  NVARCHAR (255) NULL,
    [c_RevRecIneligible]          CHAR (1)       NULL,
    [id_pi_type]                  INT            NULL,
    [id_pi_template]              INT            NULL,
    [nm_productview]              VARCHAR (100)  NULL,
    [id_view]                     INT            NULL
);


GO
CREATE NONCLUSTERED INDEX [rpt_v_PoAndPi_N1]
    ON [dbo].[rpt_v_PoAndPi]([id_pi] ASC)
    INCLUDE([c_ConcurItemType]);

