CREATE TABLE [SalesLT].[Product] (
    [ProductID]              INT              IDENTITY (1, 1) NOT NULL,
    [Name]                   [dbo].[Name]     NOT NULL,
    [ProductNumber]          NVARCHAR (25)    NOT NULL,
    [Color]                  NVARCHAR (15)    NULL,
    [StandardCost]           MONEY            NOT NULL,
    [ListPrice]              MONEY            NOT NULL,
    [Size]                   NVARCHAR (5)     NULL,
    [Weight]                 DECIMAL (8, 2)   NULL,
    [ProductCategoryID]      INT              NULL,
    [ProductModelID]         INT              NULL,
    [SellStartDate]          DATETIME         NOT NULL,
    [SellEndDate]            DATETIME         NULL,
    [DiscontinuedDate]       DATETIME         NULL,
    [ThumbNailPhoto]         VARBINARY (MAX)  NULL,
    [ThumbnailPhotoFileName] NVARCHAR (50)    NULL,
    [rowguid]                UNIQUEIDENTIFIER CONSTRAINT [DF_Product_rowguid] DEFAULT (newid()) NOT NULL,
    [ModifiedDate]           DATETIME         CONSTRAINT [DF_Product_ModifiedDate] DEFAULT (getdate()) NOT NULL,
    CONSTRAINT [PK_Product_ProductID] PRIMARY KEY CLUSTERED ([ProductID] ASC),
    CONSTRAINT [CK_Product_ListPrice] CHECK ([ListPrice]>=(0.00)),
    CONSTRAINT [CK_Product_SellEndDate] CHECK ([SellEndDate]>=[SellStartDate] OR [SellEndDate] IS NULL),
    CONSTRAINT [CK_Product_StandardCost] CHECK ([StandardCost]>=(0.00)),
    CONSTRAINT [CK_Product_Weight] CHECK ([Weight]>(0.00)),
    CONSTRAINT [FK_Product_ProductCategory_ProductCategoryID] FOREIGN KEY ([ProductCategoryID]) REFERENCES [SalesLT].[ProductCategory] ([ProductCategoryID]),
    CONSTRAINT [FK_Product_ProductModel_ProductModelID] FOREIGN KEY ([ProductModelID]) REFERENCES [SalesLT].[ProductModel] ([ProductModelID]),
    CONSTRAINT [AK_Product_Name] UNIQUE NONCLUSTERED ([Name] ASC),
    CONSTRAINT [AK_Product_ProductNumber] UNIQUE NONCLUSTERED ([ProductNumber] ASC),
    CONSTRAINT [AK_Product_rowguid] UNIQUE NONCLUSTERED ([rowguid] ASC)
);




GO
CREATE NONCLUSTERED INDEX [IX_Product_ProductNumber_CategoryID]
    ON [SalesLT].[Product]([ProductNumber] ASC, [ProductCategoryID] ASC)
    INCLUDE([Name], [StandardCost]);


GO
Create trigger [SalesLT].trg_Prodcut_HighPriceIncrease on SalesLT.Product
After update
as
begin
	set nocount on

	if update(ListPrice)
	begin
		if exists(
			Select 1 from inserted i 
			join deleted d on i.ProductID = d.ProductID
			where i.ListPrice > d.ListPrice * 1.20
		)
		
		Begin

			Insert into SalesLT.PriceIncreaseLog (ProductID, OldPrice, AttemptedPrice)
			Select i.ProductID, d.ListPrice, i.ListPrice from inserted i
			join deleted d on d.ProductID = i.ProductID
			where i.ListPrice > d.ListPrice * 1.20

			update p
			Set p.ListPrice = d.ListPrice from SalesLT.Product p
			join deleted d on d.ProductID = p.ProductID
			join inserted i on i.ProductID = p.ProductID
			where i.ListPrice > d.ListPrice * 1.20
			print ('TEST CZY DZIAŁA')

		End
	End
End;
GO
Create trigger [SalesLT].trg_ListPriceChange
on SalesLT.Product
After update
as
begin
	set nocount on
	
	if update(ListPrice)
	begin
		Insert into SalesLT.ProductPriceHistory (ProductID, OldPrice, NewPrice)
		Select	
			i.ProductID,
			d.ListPrice,
			i.ListPrice
		from inserted i
		join deleted d on d.ProductID = i.ProductID
		where i.ListPrice <> d.ListPrice
	end
end