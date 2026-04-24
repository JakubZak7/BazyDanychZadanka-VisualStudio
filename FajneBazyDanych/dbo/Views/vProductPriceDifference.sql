Create view vProductPriceDifference AS
Select p.ProductID, p.Name, p.ListPrice, t.NewPrice, (t.NewPrice - p.ListPrice) as PriceDiff
From SalesLT.Product p
join dbo.temp_PriceUpdates t on p.ProductID = t.ProductID;