CREATE TABLE [SalesLT].[VendorPriceHistory] (
    [QuoteID]   BIGINT   NULL,
    [VendorID]  INT      NOT NULL,
    [ProductID] INT      NOT NULL,
    [Price]     MONEY    NOT NULL,
    [QuoteDate] DATETIME NOT NULL
);


GO
CREATE NONCLUSTERED INDEX [IX_PriceHistory]
    ON [SalesLT].[VendorPriceHistory]([VendorID] ASC, [ProductID] ASC) WITH (FILLFACTOR = 25);

