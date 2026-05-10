
-- Linijka do sprawdzania czy działa
-- Select * from dbo.vw_CustomerList


-- =============================================
-- Zadania Dodatkowe
-- Zadanie 9
-- =============================================

Create   view dbo.vw_RecentCustomers
as
    Select Distinct c.CustomerID, c.FirstName, c.LastName from [241442].Customers c
    join SalesLT.SalesOrderHeader soh on c.CustomerID = soh.CustomerID
    Where soh.OrderDate >= DATEADD(day, -365, GETDATE())