CREATE TABLE [SalesLT].[ProductPriceHistory] (
    [PPH_ID]     INT      IDENTITY (1, 1) NOT NULL,
    [ProductID]  INT      NULL,
    [OldPrice]   MONEY    NULL,
    [NewPrice]   MONEY    NULL,
    [ChangeDate] DATETIME DEFAULT (getdate()) NULL,
    PRIMARY KEY CLUSTERED ([PPH_ID] ASC)
);

