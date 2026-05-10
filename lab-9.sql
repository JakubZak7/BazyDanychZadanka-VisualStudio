-- =============================================
-- Jakub
-- Żak
-- 241442
-- =============================================

-- Wszelkie komentarze jakie pojawiąją się w zadaniach to:
-- Moje głośne gdybania które pozwalają mi prościej zapamiętać różne rzeczy używane do zadań,
-- Potencjalne wyjaśnienia jeśli zadanie tego wymaga, lub zadanie wymaga wprowadzenia teoretycznego,
-- Ostatecznie pytania do Profesora.

-- =============================================
-- Zadanie 1
-- =============================================

Select * from [dbo].[241442_Order]

Create or Alter Function SalesLT.BestRecord (
    @AddressLine1 NVARCHAR(60) = 'New Millhouse, 2583 Milton Park' ,
    @City NVARCHAR(30) = 'Abingdon',
    @AddressID int = 651
)
Returns int
as
Begin
    Declare @Result int

    Select Top 1 @Result = AddressID
    from [dbo].[241442_Order]
    where AddressLine1 = @AddressLine1 
      and City = CAST(@City AS NCHAR(30)) 
      and AddressID = @AddressID

    return @Result
End
GO 

Select SalesLT.BestRecord('New Millhouse, 2583 Milton Park','Abingdon', 651)

-- =============================================
-- Zadanie 2
-- =============================================

Select top 25 ProductID,Name,ListPrice
into ##TopPRoduct
from SalesLT.Product
order by ListPrice, ProductID, Name desc


CREATE FUNCTION Student_2.ufn_CalcAdjustedPrices()
RETURNS @Summary TABLE 
(
    ProductID INT,
    ListPrice MONEY
)
AS
BEGIN
UPDATE ##TopProducts
SET ListPrice = (ListPrice - (ListPrice * 0.07))
END;
GO


-- Nie da się tego wykonać ponieważ nie da się użyć tabeli tymczasowej w funkcji 

-- =============================================
-- Zadanie 3
-- =============================================
Create function Student_2.ufn_ProductJsonByCategory (
    @CategoryName NVARCHAR(50) 
)
Returns NVARCHAR(MAX)
as
Begin
    Declare @Product NVARCHAR(MAX)
    set @Product = (
    Select pc.[ProductCategoryID], p.Name
    From [SalesLT].[ProductCategory] pc
    join SalesLT.Product p on pc.[ProductCategoryID] = p.[ProductCategoryID]
    where pc.Name = 'Mountain Bikes'
    for json path);

    return @Product
end
go

Select Student_2.ufn_ProductJsonByCategory('Bike')


-- =============================================
-- Zadanie 4
-- =============================================
-- Kiedy ceny będą równe, warunek większe niż który tutaj jest przyjmowany
-- nie zostanie uruchomiony przez co @result zwróci 0 czyli false, co teoretycznie oznacza że cena jest niższa, lecz może też
-- oznaczać wyrównanie ceny bo dwie równe ceny nie spełniają warunku "większe niż"

Create or alter function Student_2.ufn_IsPriceHigherThanCurrent (
    @ProductJson NVARCHAR(MAX)
)
Returns bit
as
Begin
    Declare @Result bit
    Declare @JsonPrice money
    Declare @DbPrice money
    Declare @ProductID int

    Select
        @ProductID = JSON_VALUE(@ProductJson,'$.ProductID'),
        @JsonPrice = cast(JSON_VALUE(@ProductJson, '$.ListPrice') as Money);

    Select @DbPrice = ListPrice
    from SalesLT.Product
    Where ProductID = @ProductID


    If @JsonPrice > @DbPrice
        Set @Result = 1
    else
        set @Result = 0

    Return @Result
end
go

-- Linijka do sprawdzenia czy działa
-- SELECT student_2.ufn_IsPriceHigherThanCurrent('{"ProductID": 680, "ListPrice": 5000.00}') AS IsHigherThenCurrent;

-- =============================================
-- Zadanie 5
-- =============================================

-- Robiąc to postanowiłem że zrobie po prostu porównywarke cen na więcej niż jedną wartość, wierzę że to spełnia to zadanie :)

Create or alter function Student_2.ufn_CheckMultipleProductsPrices (
    @JsonArray NVARCHAR(MAX)
)
Returns Table
as
Return (
        
    Select
-- value tutaj w kontekście wyciągnięcia zawartości elementu jsonowego, czyli mówiąc prościej tekstu
        JSON_VALUE(value, '$.ProductID') as ProductID,
        Student_2.ufn_IsPriceHigherThanCurrent(value) as IsPriceHigher
        From OPENJSON(@JsonArray)
)
go

-- Linijka do sprawdzenia czy działa
-- SELECT * FROM student_2.ufn_CheckMultipleProductsPrices('[{"ProductID": 680, "ListPrice": 9999.00}, {"ProductID": 706, "ListPrice": 10.00}]');


-- =============================================
-- Zadanie 6
-- =============================================

-- Opisy Scenariuszy dla zadania 6

-- 1. iTVF (inline table-valued function):
-- Aplikacja potrzebuje prostej funkcji, która przyjmuje wymiary prostokąta (bok A i bok B) i zwróci to w formie pojedynczeog wiersza w tabeli wraz z obliczonym polem powierzchni

Create or alter function dbo.fn_RectangleAreaTVF(@SideA INT, @SideB INT)
Returns Table
as
Return (
    Select 
        @SideA AS Bok_A,
        @SideB AS Bok_B,
        (@SideA * @SideB) AS PolePowierzchni
)

-- Linijka Testowa dla iTVF - Select * From dbo.fn_RectangleAreaTVF(5,10)

-- 2. mTVF (multi-statement table-valued function)
-- Wymyśliłem zadanie że trzeba wygenerować prostą linie numeró od 1 do podanego limitu. Funkcja uzyje pętli do wstawienia liczb do zmiennej tabelowej

Create or alter function dbo.fn_GenerateNumbers(@Limit INT)
Returns @ResultTable Table (Number INT)
as
Begin
    Declare @Counter INT = 1;

    While @Counter <= @Limit
    Begin
        Insert Into @ResultTable(Number) Values (@Counter);
        SET @Counter = @Counter + 1
    End

    Return
end

-- 3. Widok
-- Kolejna rozkminka to potrzeba stałego, statycznego niezmiennego słownika kursów walut (bardzo podobne zadanie prowadze obecnie stąd pomysł). Użyje widoku, aby móc
-- łatwo odpytywać te dane za pomocą selecta.

Create or alter view dbo.vw_StaticExchangeRates
as
    Select 'USD' AS Waluta, 4.00 As Kurs
    Union All
    Select 'EUR' AS Waluta, 4.30 As Kurs
    Union All 
    Select 'GBP' AS Waluta, 5.00 As Kurs;


-- 4. Funkcja skalarna:
-- Kalkulator wskaźnika BMI. Przyjmuje wage w kilogramach, wzrost w metrach, a następnie zwraca wskaźnik BMI w formie liczby

Create or alter function dbo.fn_CalculateBMI(@WeightKG Decimal(5,2), @HeightM Decimal(3,2))
returns Decimal(5,2)
as
begin
    -- Wzór na BMI: waga / wzrost^2
    Return @WeightKG / (@HeightM * @HeightM);
end

-- =============================================
-- Zadanie 7
-- =============================================

Create or alter function dbo.fn_GetCustomerCreditRisk(@CustomerID int)
Returns varchar(10)
as 
Begin
    Declare @RiskLevel Varchar(10)
    Declare @TotalOrdersValue Decimal(12,2) = 0
    Declare @OverdueCount INT = 0

    Declare @Orders Table (
        OrderID INT,
        OrderTotal Decimal(12,2),
        IsOverdue BIT
    )

    Insert into @Orders (OrderID,OrderTotal,IsOverdue)
    Select 
        SalesOrderID,
        TotalDue,
        Case
            When DATEDIFF(day, DueDate, ISNULL(ShipDate, GETDATE())) > 3 then 1
            else 0
        end
    from SalesLT.SalesOrderHeader
    Where CustomerID = @CustomerID

-- isNull używam tutaj w formie zabezpieczenia, chociaż i tak ta baza danych jest w miare odporna na to, ale używam tu tego po to
-- żeby praktycznie niwelować błąd klienta który nie wykonał żadnego zamówienia a sumowanie nulli w bazie nie jest najlepszą rzeczą
-- to samo z datą, jeśli data nie jest zaksięgowana niech przyjmie dzisiejszą po prostu za pomocą GETDATE()

    Select 
        @TotalOrdersValue = ISNULL(Sum(OrderTotal), 0),
        @OverdueCount = ISNULL(Sum(cast(IsOverdue as INT)),0)
    from @Orders

    IF @TotalOrdersValue > 100000 AND @OverdueCount >= 2
        SET @RiskLevel = 'HIGH'
    ELSE IF @TotalOrdersValue > 50000
        SET @RiskLevel = 'MEDIUM'
    ELSE
        SET @RiskLevel = 'LOW'

    
    Return @RiskLevel;
end
go

-- Linijka do sprawdzenia czy działa
-- SELECT dbo.fn_GetCustomerCreditRisk(29736) AS CreditRiskLevel



-- =============================================
-- Zadania Dodatkowe
-- Zadanie 8
-- =============================================

Create or alter function dbo.fn_FormatCustomerAndComapny (
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
go

Create or alter view dbo.vw_CustomerList
as
    Select CustomerID, dbo.fn_FormatCustomerAndComapny(FirstName, LastName, CompanyName) as CustomerData from [241442].Customers

go

-- Linijka do sprawdzania czy działa
-- Select * from dbo.vw_CustomerList


-- =============================================
-- Zadania Dodatkowe
-- Zadanie 9
-- =============================================

Create or alter view dbo.vw_RecentCustomers
as
    Select Distinct c.CustomerID, c.FirstName, c.LastName from [241442].Customers c
    join SalesLT.SalesOrderHeader soh on c.CustomerID = soh.CustomerID
    Where soh.OrderDate >= DATEADD(day, -365, GETDATE())

go

Declare @MinOrderCount int = 3

Select rc.CustomerID, rc.FirstName, rc.LastName, Count(soh.SalesOrderID) as TotalOrders from dbo.vw_RecentCustomers rc
join SalesLT.SalesOrderHeader soh on rc.CustomerID = soh.CustomerID
group by rc.CustomerID, rc.FirstName, rc.LastName
having Count(soh.SalesOrderID) > @MinOrderCount
go

-- W celach testów stworzyłem pare danych które są z ostatniego roku bo większość z bazy AdventureWorks której używamy na zajęciach
-- Ma dane z jakiegoś 2008 roku, także zapewne u Profesora zwróci puste rekordy bo bazowo nie ma nikogo z ostatniego roku w tej bazie
-- Jeśli pojawiłby się jakiś problem z chęcią porusze to na zajęciach.

-- =============================================
-- Zadania Dodatkowe
-- Zadanie 10
-- =============================================

-- Na dłuższą metę w tym zadaniu trzeba zbudować po prostu rozbudowane CTE, zobaczymy co z tego będzie

Create or alter function dbo.fn_GetCategoryHierarchy(@RootCategoryName nvarchar(50))
Returns @ResultTable Table (
    ProductCategoryID INT,
-- Nie mogę użyć normalnego level, path, sort bo to słowa kluczowe w T-SQLu dlatego nawiasy kwadratowe wchodzą w gre
    [Level] INT,
    [Path] NVARCHAR(MAX),
    [Sort] NVARCHAR(MAX)
 )
 as
 Begin
    With CategoryTree as (
       Select ProductCategoryID, ParentProductCategoryID, Name, 1 as [Level], cast(Name as NVARCHAR(MAX)) as [Path], cast(Name as NVARCHAR(MAX)) as [Sort]
       from SalesLT.ProductCategory Where Name = @RootCategoryName

       Union All

       Select pc.ProductCategoryID,pc.ParentProductCategoryID, pc.Name, ct.[Level] + 1 as [Level], ct.[Path] + ' -> ' + pc.Name as [Path], ct.[Sort] + '::' + pc.Name as [Sort]
       from SalesLT.ProductCategory pc
       join CategoryTree ct on pc.ParentProductCategoryID = ct. ProductCategoryID
    )
    Insert Into @ResultTable (ProductCategoryID, [Level], [Path], [Sort])
    Select ProductCategoryID, [Level], [Path], [Sort] from CategoryTree

 
    return;
end
go

Create or alter view dbo.v_ProductCategoryTree
as
    With AllHierarchies AS (
        Select * From dbo.fn_GetCategoryHierarchy('Bikes')
        Union All
        Select * From dbo.fn_GetCategoryHierarchy('Components')
        Union All
        Select * From dbo.fn_GetCategoryHierarchy('Clothing')
        Union All
        Select * From dbo.fn_GetCategoryHierarchy('Accessories')
    )
    Select 
        p.ProductID,
        p.Name as ProductName,
        ah.[Path] + ' -> ' + p.Name as FullCategoryPath
    From SalesLT.Product p
    Join AllHierarchies ah on p.ProductCategoryID = ah.ProductCategoryID;
GO


-- Linijka do sprawdzenia czy działa
-- Select * from dbo.v_ProductCategoryTree