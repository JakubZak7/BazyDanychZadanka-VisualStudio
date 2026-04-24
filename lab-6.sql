-- =============================================
-- Jakub
-- Żak
-- 241442
-- =============================================

-- =============================================
-- Zadanie 1
-- =============================================

BEGIN TRAN;
UPDATE SalesLT.Product
SET ListPrice = ListPrice + 5
WHERE ProductID = 680;

WAITFOR DELAY '00:00:30';

UPDATE SalesLT.SalesOrderDetail
SET UnitPrice = UnitPrice + 1
WHERE ProductID = 680;
COMMIT;
go

BEGIN TRAN;
UPDATE SalesLT.SalesOrderDetail
SET UnitPrice = UnitPrice + 1
WHERE ProductID = 680;

WAITFOR DELAY '00:00:30';

UPDATE SalesLT.Product
SET ListPrice = ListPrice + 5
WHERE ProductID = 680;
COMMIT;
go

-- Dlaczego deadlock to problem?
-- Zator (Bottleneck aplikacji) - w momencie kiedy taka sytuacja występuje, tabela jest niedostępna oznacza to że, jakikolwiek
-- inny program który miał dodać/usunąć/zmodyfikować te dane po prostu tego nie zrobi.


-- =============================================
-- Zadanie 2
-- =============================================

Select TOP 20 * Into dbo.TempCustomer From [241442].[Customers]
Begin Tran

Update SalesLT.Product SET ListPrice = ListPrice * 5
Where ProductCategoryID like '7%'

INSERT INTO SalesLT.Product (Name, ProductNumber, Color, StandardCost, ListPrice, SellStartDate)
VALUES 
    ('Koszulka 1', '245-1', 'Black', 23, 44, '2022-01-01'),
    ('Koszulka 2', '245-2', 'Black', 23, 44, '2022-01-01'),
    ('Koszulka 3', '245-3', 'Black', 23, 44, '2022-01-01'),
    ('Koszulka 4', '245-4', 'Black', 23, 44, '2022-01-01'),
    ('Koszulka 5', '245-5', 'Black', 23, 44, '2022-01-01'),
    ('Koszulka 6', '245-6', 'Black', 23, 44, '2022-01-01'),
    ('Koszulka 7', '245-7', 'Black', 23, 44, '2022-01-01'),
    ('Koszulka 8', '245-8', 'Black', 23, 44, '2022-01-01'),
    ('Koszulka 9', '245-9', 'Black', 23, 44, '2022-01-01'),
    ('Koszulka 10', '245-10', 'Black', 23, 44, '2022-01-01');


Truncate Table dbo.TempCustomer

Select Count(*) as TempCustomerIlosc from dbo.TempCustomer
Select ListPrice as CenyPrzedRollBackiem from SalesLT.Product Where Name like 'Koszu%'

Rollback

Select Count(*) as TempCustomerIloscPoRollbacku from dbo.TempCustomer
Select ListPrice as CenyPoRollBackiem from SalesLT.Product Where Name like 'Koszu%'

Drop Table dbo.TempCustomer
go

-- =============================================
-- Zadanie 3
-- =============================================

Select TOP 20 * Into dbo.TempCustomer From [241442].[Customers]

Begin Tran

Update SalesLT.Product SET ListPrice = ListPrice * 5
Where ProductCategoryID like '7%'

INSERT INTO SalesLT.Product (Name, ProductNumber, Color, StandardCost, ListPrice, SellStartDate)
VALUES 
    ('Koszulka 1', '245-1', 'Black', 23, 44, '2022-01-01'),
    ('Koszulka 2', '245-2', 'Black', 23, 44, '2022-01-01'),
    ('Koszulka 3', '245-3', 'Black', 23, 44, '2022-01-01'),
    ('Koszulka 4', '245-4', 'Black', 23, 44, '2022-01-01'),
    ('Koszulka 5', '245-5', 'Black', 23, 44, '2022-01-01'),
    ('Koszulka 6', '245-6', 'Black', 23, 44, '2022-01-01'),
    ('Koszulka 7', '245-7', 'Black', 23, 44, '2022-01-01'),
    ('Koszulka 8', '245-8', 'Black', 23, 44, '2022-01-01'),
    ('Koszulka 9', '245-9', 'Black', 23, 44, '2022-01-01'),
    ('Koszulka 10', '245-10', 'Black', 23, 44, '2022-01-01');

WAITFOR DELAY '00:00:30';

Truncate Table dbo.TempCustomer

Rollback

Select Count(*) as TempCustomerIloscPoRollbacku from dbo.TempCustomer
Select ListPrice as CenyPoRollBackiem from SalesLT.Product Where Name like 'Koszu%'

Drop Table dbo.TempCustomer
go

SELECT ProductID, Name, ProductNumber, ListPrice 
FROM SalesLT.Product WITH (NOLOCK)
WHERE Name LIKE 'Koszu%';


-- Select poniżej służy do odczytania brudnych danych (Dirty Read) w trakcie wywoływania sekwencji która to ma 30 sekund delayu


-- =============================================
-- Zadanie 4
-- =============================================

Begin Try

INSERT INTO SalesLT.Product (Name, ProductNumber, StandardCost, ListPrice, SellStartDate, ProductCategoryID)
    VALUES ('BugTesting', 'BT-225', 500, 1000, GETDATE(), 999999999999);

End Try

Begin Catch
    Select ERROR_NUMBER() AS NumerBledu;
    Select ERROR_MESSAGE() AS WiadomoscBledu;
End Catch
go

-- =============================================
-- Zadanie 5
-- =============================================

-- Założenie biznesowe, wprowadzam nowy produkt i wycofuje stary produkt, sprawdzam czy dane podane są nowe / poprawne w miejscach gdzie jest to wymagane
-- np. @OldProductID, jeśli nie wyrzuca błąd walidacji oraz kod błędu
-- Jeśli wszystko jest okej dodaje go do bazy danych i zmienia dane SellEndDate na obecną co sprawia że produkt zostaje wycofany

-- Operacje wykonywane: Odczyt (Select) -> Wstawianie (Insert) -> Modyfikowanie (Update) [Modyfikacja SellEndDate, żeby nie można było sprzedawać starego produktu]

-- Możliwe Błędy:
-- Dane Wejściowe a dokładnie ich brak, stąd też pojawia się walidacja która będzie weryfikować czy wszystko jest git
-- Konflikty, a dokładnie to błędnie podane @OldProductID bo jeśli @OldProductID jest takie jakie nie występuje w bazie to ten kod dosłownie nic nie zrobi xD
-- Może też pojawić się niepoprawność danych ale to już raczej kwestia tego że osoba pracująca na bazie zrobi ten błąd albo po prostu coś źle wypełni

Declare @OldProductID INT = 999;
Declare @NewColor NVARCHAR(30) = 'Aquamarine';
Declare @NewProductNumber NVARCHAR(30) = 'C0-R23J-2IUM-MMNVC';

IF @OldProductID is null or @NewColor is null or @NewProductNumber is null
Begin 
    Return
End 

IF NOT EXISTS (Select 1 From SalesLT.Product Where ProductID = @OldProductID)
Begin
    Return
End 

Begin Try
    INSERT INTO SalesLT.Product 
        (Name, ProductNumber, Color, StandardCost, ListPrice, Size, Weight, ProductCategoryID, ProductModelID, SellStartDate)
    SELECT 
        Name + ' - ' + @NewColor, 
        @NewProductNumber,             
        @NewColor,                     
        StandardCost, 
        ListPrice, 
        Size, 
        Weight, 
        ProductCategoryID, 
        ProductModelID, 
        GETDATE()                      
    FROM SalesLT.Product
    WHERE ProductID = @OldProductID;

    Update SalesLT.Product Set SellEndDate = GETDATE() Where ProductID = @OldProductID
End Try

Begin Catch
    Print 'Wystąpił Błąd Systemowy';
    Select ERROR_NUMBER() AS NumberBledu
End Catch

go

-- =============================================
-- Zadanie 6
-- =============================================

-- Jedyna zmiana względem zadania 5 to dodanie transakcji oraz zabezpieczenia rollbackiem jeśli jakaś transakcja jest otwarta bo jest to
-- swojego rodzaju błąd krytyczny wtedy. Tak to reszta bez zmian :)

Declare @OldProductID INT = 706;
Declare @NewColor NVARCHAR(30) = 'Cyan';
Declare @NewProductNumber NVARCHAR(30) = 'C0-R23J-2IUM-MMNVC-V332';

IF @OldProductID is null or @NewColor is null or @NewProductNumber is null
Begin 
    Return
End 

IF NOT EXISTS (Select 1 From SalesLT.Product Where ProductID = @OldProductID)
Begin
    Print 'PODAJ POPRAWNE ID PRODUKTU KTÓRY JUŻ ISTNIEJE'
    Return
End 

Begin Try

    Begin Tran
    INSERT INTO SalesLT.Product 
        (Name, ProductNumber, Color, StandardCost, ListPrice, Size, Weight, ProductCategoryID, ProductModelID, SellStartDate)
    SELECT 
        Name + ' - ' + @NewColor, 
        @NewProductNumber,             
        @NewColor,                     
        StandardCost, 
        ListPrice, 
        Size, 
        Weight, 
        ProductCategoryID, 
        ProductModelID, 
        GETDATE()                      
    FROM SalesLT.Product
    WHERE ProductID = @OldProductID;

    Update SalesLT.Product Set SellEndDate = GETDATE() Where ProductID = @OldProductID
    Commit Tran

End Try
Begin Catch
       IF @@TRANCOUNT > 0
       Begin
            ROLLBACK
       End

    Print 'Wystąpił Błąd Systemowy';
    Select ERROR_MESSAGE() AS NazwaErroru

End Catch

