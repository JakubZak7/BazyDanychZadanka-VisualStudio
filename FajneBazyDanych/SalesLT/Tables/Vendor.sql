CREATE TABLE [SalesLT].[Vendor] (
    [VendorID]      INT            IDENTITY (1, 1) NOT NULL,
    [Name]          NVARCHAR (100) NOT NULL,
    [AccountNumber] NVARCHAR (20)  NOT NULL,
    [CreditRating]  TINYINT        NOT NULL,
    [ActiveFlag]    BIT            DEFAULT ((1)) NULL,
    PRIMARY KEY CLUSTERED ([VendorID] ASC)
);


GO
CREATE NONCLUSTERED INDEX [IX_Vendor_Aktywny]
    ON [SalesLT].[Vendor]([Name] ASC, [ActiveFlag] ASC) WHERE ([ActiveFlag]=(1));


GO
CREATE NONCLUSTERED INDEX [IX_Vendor_CreditRating_Aktywny]
    ON [SalesLT].[Vendor]([Name] ASC, [CreditRating] ASC, [ActiveFlag] ASC) WHERE ([CreditRating]=(1) AND [ActiveFlag]=(1));


GO
CREATE STATISTICS [ActiveVendors]
    ON [SalesLT].[Vendor]([VendorID]);

