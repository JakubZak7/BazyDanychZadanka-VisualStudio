-- =============================================
-- Jakub
-- Żak
-- 241442
-- =============================================

-- =============================================
-- Zadanie 1
-- =============================================

Create schema J2_surname authorization dbo;
go

CREATE TYPE J2_surname.SurnameType 
FROM NVARCHAR(100) NOT NULL;
GO

Alter table [241442].Customers
Alter column LastName J2_surname.SurnameType;
go

-- =============================================
-- Zadanie 2
-- =============================================

DECLARE @ProductInfo NVARCHAR(MAX) = N'[
    {"ProductID": 680, "NewPrice": 1200.00},
    {"ProductID": 706, "NewPrice": 1250.50},
    {"ProductID": 707, "NewPrice": 30.00},
    {"ProductID": 708, "NewPrice": 25.99},
    {"ProductID": 709, "NewPrice": 100.00}
]';

SELECT * FROM OPENJSON(@ProductInfo)
WITH (ProductID INT, NewPrice MONEY);


CREATE VIEW vProductPriceComparison AS
SELECT 
    p.ProductID,
    p.Name,
    p.ListPrice AS OldPrice,
    pif.NewPrice,
    (pif.NewPrice - p.ListPrice) AS Difference
FROM SalesLT.Product p
JOIN OPENJSON(@ProductInfo) pif ON p.ProductID = pif.ProductID;
GO

-- Błąd jaki zostanie zwrócony to "Must declare the scalar variable "@ProductInfo" ponieważ widok to rzecz trwała 
-- Natomiast Zmienna lokalna @___ jest tymczasowa i żyje tylko w pamięci na długość wykonywanego skryptu.

-- =============================================
-- Zadanie 3
-- =============================================

Create View [241442_Order] AS
Select Top 100 AddressID, AddressLine1, AddressLine2, City, CountryRegion, PostalCode From SalesLT.Address 
order by City asc;
go

Select * from [241442_Order]


-- =============================================
-- Zadanie 4
-- =============================================

-- Moja Logika biznesowa to stworzenie PriceSegmentu dla produktów które mamy w bazie w tabeli SalesLT.Product
-- Kiedy nasza cena jest poniżej 50 jako listprice przyjmujemy wartość 'Low Cost'
-- Jeśli jest pomiędzy 50 a 500 przyjmujemy wartość 'Mid Range'
-- Jeśli jest powyżej 500 przyjmujemy wartość 'High End'
-- Wydaje mi się że taka logika biznesowa jest użyteczna do tego aby kategoryzować produkty znajdujące się w naszej bazie danych :)

Create View Student_2.MyLogicView AS
Select ProductID, Name, Color, ListPrice,
Case
    When ListPrice < 50 Then 'Low Cost'
    When ListPrice Between 50 and 500 Then 'Mid Range'
    When ListPrice > 500 Then 'High End'
End as PriceSegment
from SalesLT.Product
go

Select * from Student_2.MyLogicView
go

-- =============================================
-- Zadanie 5
-- =============================================

Create View Student2_HighEndItems AS
Select ProductID, Name, Color, ListPrice, PriceSegment
From Student_2.MyLogicView Where PriceSegment = 'High End'
go

Select * from Student2_HighEndItems 
go