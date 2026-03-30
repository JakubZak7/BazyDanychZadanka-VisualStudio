CREATE TABLE [SalesLT].[VendorProductQuality] (
    [ReviewID]   INT            IDENTITY (1, 1) NOT NULL,
    [VendorID]   INT            NOT NULL,
    [ProductID]  INT            NOT NULL,
    [Rating]     TINYINT        NOT NULL,
    [IsResolved] BIT            DEFAULT ((0)) NULL,
    [Comments]   NVARCHAR (500) NULL,
    CONSTRAINT [PK_VendorProductQuality] PRIMARY KEY CLUSTERED ([ReviewID] ASC),
    CONSTRAINT [FK_VPQ_ProductID] FOREIGN KEY ([ProductID]) REFERENCES [SalesLT].[Product] ([ProductID]),
    CONSTRAINT [FK_VPQ_VendorID] FOREIGN KEY ([VendorID]) REFERENCES [SalesLT].[Vendor] ([VendorID])
);


GO
CREATE NONCLUSTERED INDEX [IX_FPQ_Vendor_Rating]
    ON [SalesLT].[VendorProductQuality]([VendorID] ASC)
    INCLUDE([Rating]);


GO
CREATE NONCLUSTERED INDEX [IX_FPQ_Unresolved_Problems]
    ON [SalesLT].[VendorProductQuality]([VendorID] ASC, [ProductID] ASC) WHERE ([IsResolved]=(0));


GO
CREATE NONCLUSTERED INDEX [IX_VPQ_Vendor_Rating]
    ON [SalesLT].[VendorProductQuality]([VendorID] ASC)
    INCLUDE([Rating]);


GO
CREATE NONCLUSTERED INDEX [IX_VPQ_Unresolved_Problems]
    ON [SalesLT].[VendorProductQuality]([VendorID] ASC, [ProductID] ASC) WHERE ([IsResolved]=(0));

