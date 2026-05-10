
-- Linijka do sprawdzenia czy działa
-- SELECT dbo.fn_GetCustomerCreditRisk(29736) AS CreditRiskLevel



-- =============================================
-- Zadania Dodatkowe
-- Zadanie 8
-- =============================================

Create   function dbo.fn_FormatCustomerAndComapny (
    @FirstName NVARCHAR(50),
    @LastName NVARCHAR(50),
    @CompanyName NVARCHAR(128)
)
Returns NVARCHAR(MAX)
as
Begin
    Declare @Result NVARCHAR(MAX);

    Set @Result = @FirstName + ' ' + @LastName + ' (Company: ' + ISNULL(@CompanyName, 'Brak') + ')'

    Return @Result
end