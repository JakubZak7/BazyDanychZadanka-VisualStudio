
Create   view dbo.vw_CustomerList
as
    Select CustomerID, dbo.fn_FormatCustomerAndComapny(FirstName, LastName, CompanyName) as CustomerData from [241442].Customers