-- =============================================
-- Jakub
-- Żak
-- 241442
-- =============================================

-- =============================================
-- Zadanie 1
-- =============================================
-- https://github.com/JakubZak7/BazyDanychZadanka-VisualStudio
-- =============================================

-- =============================================
-- Zadanie 2
--  ALTER TABLE [241442].[Customers] ADD SysStartTime DATETIME2 NULL, SysEndTime DATETIME2 NULL;
--  UPDATE [241442].[Customers] SET SysStartTime = SYSUTCDATETIME(), SysEndTime = CONVERT(DATETIME2, '9999-12-31 23:59:59.9999999');
--  ALTER TABLE [241442].[Customers] ALTER COLUMN SysStartTime DATETIME2 NOT NULL;
--  ALTER TABLE [241442].[Customers] ALTER COLUMN SysEndTime DATETIME2 NOT NULL;
--  ALTER TABLE [241442].[Customers] ADD PERIOD FOR SYSTEM_TIME (SysStartTime, SysEndTime);
--  ALTER TABLE [241442].[Customers] SET (SYSTEM_VERSIONING = ON (HISTORY_TABLE = [241442].[CustomersHistory]));
-- Nie rozumiem dlaczego to nie działało i trzeba to było rozbijać na kroki, ale finalnie działa xD
-- =============================================

ALTER TABLE [241442].[Customers]
ADD 
    SysStartTime DATETIME2 NULL,
    SysEndTime   DATETIME2 NULL
GO

UPDATE [241442].[Customers]
SET 
    SysStartTime = SYSUTCDATETIME(),
    SysEndTime   = CONVERT(DATETIME2, '9999-12-31 23:59:59.9999999')
GO

ALTER TABLE [241442].[Customers]
ALTER COLUMN SysStartTime DATETIME2 NOT NULL;

ALTER TABLE [241442].[Customers]
ALTER COLUMN SysEndTime DATETIME2 NOT NULL;
GO

ALTER TABLE [241442].[Customers]
ADD PERIOD FOR SYSTEM_TIME (SysStartTime, SysEndTime);
GO

ALTER TABLE [241442].[Customers]
SET (SYSTEM_VERSIONING = ON (HISTORY_TABLE = [241442].[CustomersHistory]));
GO

-- =============================================
-- Zadanie 3
-- =============================================

Update [241442].[Customers] SET FirstName = 'Anna' WHERE CustomerID = 1;
Update [241442].[Customers] SET MiddleName = 'Maria' WHERE CustomerID = 1;
Update [241442].[Customers] SET LastName = 'Wesołowska' WHERE CustomerID = 1;
GO

Update [241442].[Customers] SET FirstName = 'Franciszek' WHERE CustomerID = 2;
Update [241442].[Customers] SET FirstName = 'Zbigniew' WHERE CustomerID = 3;
Update [241442].[Customers] SET FirstName = 'Mariusz' WHERE CustomerID = 4;
Update [241442].[Customers] SET FirstName = 'Marek' WHERE CustomerID = 5;
Update [241442].[Customers] SET FirstName = 'Eustachy' WHERE CustomerID = 6;
Update [241442].[Customers] SET FirstName = 'Władysław' WHERE CustomerID = 7;
Update [241442].[Customers] SET FirstName = 'Nelosława' WHERE CustomerID = 10;
GO

INSERT INTO [241442].[Customers] (NameStyle, FirstName, LastName, PasswordHash, PasswordSalt, rowguid, ModifiedDate)
VALUES
(0, 'Jan',    'Jankowski',  'hash1', 'salt1', NEWID(), GETDATE()),
(0, 'Ewa',    'Jabłoński',  'hash2', 'salt2', NEWID(), GETDATE()),
(0, 'Adam',   'Jędrzejak',  'hash3', 'salt3', NEWID(), GETDATE()),
(0, 'Zofia',  'Jaworski',   'hash4', 'salt4', NEWID(), GETDATE()),
(0, 'Michał', 'Jurczak',    'hash5', 'salt5', NEWID(), GETDATE());
GO

-- =============================================
-- Zadanie 4
-- =============================================

Select * From [241442].[Customers]
For SYSTEM_TIME ALL
Where CustomerID = 1
Order by SysStartTime
go

-- =============================================
-- Zadanie 5

-- Select MIN(SysStartTime) From [241442].[Customers]
-- Where LastName like 'J%';
-- Użyte do sprawdzenia godziny zmian
-- =============================================

DECLARE @DataPrzedZadaniem3 datetime2 = '2026-04-07 11:38:34.7928059'
SELECT * FROM [241442].[Customers]
FOR SYSTEM_TIME AS OF @DataPrzedZadaniem3;
go

-- =============================================
-- Zadanie 6
-- =============================================

CREATE XML SCHEMA COLLECTION [SalesLT].[ProductAttributeSchema] AS N'
<xs:schema xmlns:xs="http://www.w3.org/2001/XMLSchema">
  <xs:element name="Product" type="ProductType"/>
  <xs:complexType name="ProductType">
    <xs:sequence>
      <xs:element name="Weight" type="xs:decimal"/>
      <xs:element name="Manufacturer" type="xs:string"/>
      <xs:element name="Material" type="xs:string"/>
      <xs:element name="Warranty" type="xs:int"/>
      <xs:element name="Color" type="xs:string"/>
    </xs:sequence>
  </xs:complexType>
</xs:schema>';
go

Create Table [SalesLT].[ProductAttribute] (
    ProductAttributeID INT Identity(1,1) Primary Key,
    ProductID INT not null,
    Attributes XML([SalesLT].[ProductAttributeSchema]),
    Constraint FK_ProductAttributePK_ProductFK Foreign key (ProductID) REFERENCES [SalesLT].[Product](ProductID)
);
go

-- =============================================
-- Zadanie 7
-- =============================================

INSERT INTO [SalesLT].[ProductAttribute] (ProductID, Attributes)
VALUES
(680, N'<Product><Weight>1.5</Weight><Manufacturer>Acme</Manufacturer><Material>Metal</Material><Warranty>12</Warranty><Color>Czerwony</Color></Product>'),
(706, N'<Product><Weight>2.1</Weight><Manufacturer>GCorp</Manufacturer><Material>Plastik</Material><Warranty>24</Warranty><Color>Niebieski</Color></Product>'),
(707, N'<Product><Weight>0.8</Weight><Manufacturer>SportsInc</Manufacturer><Material>Karbon</Material><Warranty>6</Warranty><Color>Czarny</Color></Product>'),
(708, N'<Product><Weight>3.0</Weight><Manufacturer>NatureWorks</Manufacturer><Material>Drewno</Material><Warranty>36</Warranty><Color>Biały</Color></Product>'),
(709, N'<Product><Weight>1.2</Weight><Manufacturer>Elastix</Manufacturer><Material>Guma</Material><Warranty>12</Warranty><Color>Zielony</Color></Product>');
GO

-- =============================================
-- Zadanie 8
-- =============================================

Update [SalesLT].[ProductAttribute]
SET Attributes.modify('
    replace value of (/Product/Color)[1]
    with "Jasnoniebieski"
');
GO

-- =============================================
-- Zadanie 9
-- =============================================

Declare @JSONKontenerZadanie9 nvarchar(max) = 
N'{"Imie": "Jan", "Indeks": "000000", "Kierunek": "Informatyka"}';

SET @JSONKontenerZadanie9 = JSON_MODIFY(@JSONKontenerZadanie9, '$.Indeks', '241442');
Select @JSONKontenerZadanie9 AS GotoweZadanie9;
go

