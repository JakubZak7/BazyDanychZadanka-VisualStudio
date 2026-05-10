
-- W celach testów stworzyłem pare danych które są z ostatniego roku bo większość z bazy AdventureWorks której używamy na zajęciach
-- Ma dane z jakiegoś 2008 roku, także zapewne u Profesora zwróci puste rekordy bo bazowo nie ma nikogo z ostatniego roku w tej bazie
-- Jeśli pojawiłby się jakiś problem z chęcią porusze to na zajęciach.

-- =============================================
-- Zadania Dodatkowe
-- Zadanie 10
-- =============================================

-- Na dłuższą metę w tym zadaniu trzeba zbudować po prostu rozbudowane CTE, zobaczymy co z tego będzie

Create   function dbo.fn_GetCategoryHierarchy(@RootCategoryName nvarchar(50))
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