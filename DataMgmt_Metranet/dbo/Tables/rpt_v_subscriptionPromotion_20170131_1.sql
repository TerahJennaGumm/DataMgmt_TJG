CREATE TABLE [dbo].[rpt_v_subscriptionPromotion_20170131] (
    [id_acc]                 INT              NULL,
    [id_pi_instance]         INT              NULL,
    [c_PromoCode]            NVARCHAR (255)   NULL,
    [c_Description]          NVARCHAR (255)   NULL,
    [c_Percentage_Off]       NUMERIC (22, 10) NULL,
    [c_PromotionDescription] NVARCHAR (255)   NULL,
    [promo__id_sub]          INT              NULL,
    [promo__id_pi_instance]  INT              NULL,
    [promo__id_pricelist]    INT              NULL,
    [promo__id_sched]        INT              NOT NULL,
    [promo__n_order]         INT              NOT NULL,
    [promo__id_audit]        INT              NOT NULL,
    [dt_start]               DATETIME         NULL,
    [dt_end]                 DATETIME         NULL
);

