Create View [241442_Order] AS
Select Top 100 AddressID, AddressLine1, AddressLine2, City, CountryRegion, PostalCode From SalesLT.Address 
order by City asc;