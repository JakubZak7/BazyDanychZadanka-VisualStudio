-- =============================================
-- Jakub
-- Żak
-- 241442
-- =============================================


-- =============================================
-- Zadanie 1
-- =============================================

Create table SalesLT.ProductPriceHistory (
	PPH_ID INT identity(1,1) Primary key,
	ProductID int,
	OldPrice money,
	NewPrice money,
	ChangeDate DATETIME DEFAULT GETDATE()
);
go

Create trigger trg_ListPriceChange on SalesLT.Product
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
go

-- =============================================
-- Zadanie 2
-- =============================================

-- Przypadek Pierwszy - Insert Into, użytkownik który jest usuwany jest dodany do logów ponieważ ma jakieś zamówienie
-- Przypadek Drugi - Brak zamówienia w bazie, można go spokojnie usuwać
-- Proszę nie zwarzać na notatki, często jak coś nie wiem jak w pełni funkcjonuje to rozpisuje sobie działania żeby utrwalić

Create table SalesLT.DeletedCustomersLog (
	DCL_ID INT identity(1,1) Primary key,
	CustomerID int,
	FirstName nvarchar(50),
	LastName nvarchar(50),
	DeletedDate DATETIME DEFAULT GETDATE()
);
go

Create trigger trg_Customers_RemoverIOD on SalesLT.Customer
Instead of Delete
As
Begin
	Set nocount on

	Insert into SalesLT.DeletedCustomersLog (CustomerID, FirstName, LastName)
	Select d.CustomerID, d.FirstName, d.LastName from deleted d
	Where exists(Select 1 from SalesLT.SalesOrderHeader soh where soh.CustomerID = d.CustomerID)

	Delete c from SalesLT.Customer c
	join deleted d on d.CustomerID = c.CustomerID
	Where not exists(Select 1 from SalesLT.SalesOrderHeader soh where soh.CustomerID = d.CustomerID);
End
go

-- =============================================
-- Zadanie 3
-- =============================================
-- Road Bikes ma CategoryID 6
-- update SalesLT.ProductCategory set ParentProductCategoryID = 6
-- Where Name = 'Road Frames'

WITH CategoryCTE AS (
    SELECT 
        ProductCategoryID,
        ParentProductCategoryID,
        Name,
        CAST(Name AS NVARCHAR(MAX)) AS CategoryPath 
    FROM SalesLT.ProductCategory
    WHERE ParentProductCategoryID IS NULL

    UNION ALL

    SELECT 
        pcr.ProductCategoryID,
        pcr.ParentProductCategoryID,
        pcr.Name,
        CAST(cte.CategoryPath + ' -> ' + pcr.Name AS NVARCHAR(MAX))
    FROM SalesLT.ProductCategory pcr
    JOIN CategoryCTE cte ON pcr.ParentProductCategoryID = cte.ProductCategoryID
)

SELECT 
    ProductCategoryID,
    CategoryPath
FROM CategoryCTE
Where CategoryPath like 'Bikes%mes'
ORDER BY CategoryPath;

-- Select 
--	 ProductCategoryID,
--   CategoryPath
-- From CategoryCTE
-- Order by CategoryPath
-- Komenda do wyświetlenia całości

-- =============================================
-- Zadanie 4
-- =============================================

-- Rollback tutaj nie ma sensu, ponieważ psuje całe założenie zadania wydaje mi się że poprawnym rozwiązaniem tutaj jest cofnięcie tego do old danych
-- Jeśli coś jest niepoprawnie to no trudno, ale wydaje mi się że to jest jedyne sensowne rozwiązanie

CREATE TABLE SalesLT.PriceIncreaseLog (
    LogID INT IDENTITY(1,1) PRIMARY KEY,
    ProductID INT,
    OldPrice MONEY,
    AttemptedPrice MONEY,
    LogDate DATETIME DEFAULT GETDATE()
);
GO

Create trigger trg_Prodcut_HighPriceIncrease on SalesLT.Product
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
			print ('Cena nie została zmieniona, kwota jest większa o ponad 20%')

		End
	End
End;
go

-- =============================================
-- Zadanie 5
-- =============================================

CREATE TABLE dbo.DatabaseAuditLog (
    LogID INT IDENTITY(1,1) PRIMARY KEY,
    EventDate DATETIME DEFAULT GETDATE(),
    UserName NVARCHAR(100),
    EventType NVARCHAR(100),
    ObjectName NVARCHAR(100),
    TSQLCommand NVARCHAR(MAX)
);
GO

Create trigger tgr_AuditLogTableChange on database
for create_table, alter_table, drop_table
as 
begin
	set nocount on;

	Declare @EventData XML = EVENTDATA()

	Insert into dbo.DatabaseAuditLog (UserName, EventType, ObjectName, TSQLCommand)
	Values (
		ORIGINAL_LOGIN(),
		@EventData.value('(/EVENT_INSTANCE/EventType)[1]', 'NVARCHAR(100)'),
        @EventData.value('(/EVENT_INSTANCE/ObjectName)[1]', 'NVARCHAR(100)'),
        @EventData.value('(/EVENT_INSTANCE/TSQLCommand)[1]', 'NVARCHAR(MAX)')
	);
End
go

-- =============================================
-- Zadanie 6
-- =============================================

-- Dziecko w relacji z Products to Product Review, wychodze z założenia że sensowne potem CTE do tego to wyświetlanie recenzji jak i oceny
-- która to jest najbardziej akutalna, pomijając poprzednie opinie. Coś jak sortowanie opinii na jakiś stronach typu ceneo??? gdzie najwyżej widzimy najnowsze opinie


CREATE TABLE SalesLT.ProductReview (
    ReviewID INT IDENTITY(1,1) PRIMARY KEY,
    ProductID INT NOT NULL,
    ReviewerName NVARCHAR(50),
    Rating INT CHECK (Rating BETWEEN 1 AND 5),
    ReviewText NVARCHAR(MAX),
    ReviewDate DATETIME DEFAULT GETDATE(),
    
    CONSTRAINT FK_ProductReview_Product FOREIGN KEY (ProductID) 
    REFERENCES SalesLT.Product(ProductID)
);
GO

WITH NajnowszeDatyCTE AS (
    SELECT 
        ProductID, 
        MAX(ReviewDate) AS MaxReviewDate
    FROM SalesLT.ProductReview
    GROUP BY ProductID
)

SELECT 
	pr.ProductID,
    p.Name AS ProductName,
    pr.ReviewerName,
    pr.Rating,
    pr.ReviewDate
FROM SalesLT.ProductReview pr
JOIN NajnowszeDatyCTE cte ON pr.ProductID = cte.ProductID AND pr.ReviewDate = cte.MaxReviewDate
JOIN SalesLT.Product p ON pr.ProductID = p.ProductID;
go