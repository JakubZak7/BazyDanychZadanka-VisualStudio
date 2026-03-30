CREATE TABLE [SalesLT].[ProductVendor] (
    [ProductID]       INT   NOT NULL,
    [VendorID]        INT   NOT NULL,
    [StandardPrice]   MONEY NOT NULL,
    [AverageLeadTime] INT   NOT NULL,
    CONSTRAINT [PK_ProductVendor] PRIMARY KEY CLUSTERED ([ProductID] ASC, [VendorID] ASC)
);


GO
CREATE NONCLUSTERED INDEX [IX_Tracking_DeliveryStatus]
    ON [SalesLT].[ProductVendor]([VendorID] ASC, [ProductID] ASC)
    INCLUDE([AverageLeadTime]);

