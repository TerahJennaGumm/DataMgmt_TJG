CREATE TABLE [dbo].[Attributes] (
    [Id]              INT            IDENTITY (1, 1) NOT NULL,
    [AttributeObject] NVARCHAR (255) NULL,
    [Attribute]       NVARCHAR (255) NULL,
    [Active]          BIT            CONSTRAINT [DF__Attribute__Activ__05A3D694] DEFAULT ((1)) NULL,
    CONSTRAINT [PK__Attribut__3214EC0755CB61B9] PRIMARY KEY CLUSTERED ([Id] ASC)
);


GO
CREATE NONCLUSTERED INDEX [NonClusteredIndex-20180912-144930]
    ON [dbo].[Attributes]([Attribute] ASC);

