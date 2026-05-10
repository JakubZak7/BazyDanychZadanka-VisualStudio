CREATE TABLE [SalesLT].[Customer] (
    [CustomerID]   INT              IDENTITY (1, 1) NOT NULL,
    [NameStyle]    BIT              CONSTRAINT [DF_Customer_NameStyle] DEFAULT ((0)) NOT NULL,
    [Title]        NVARCHAR (8)     NULL,
    [FirstName]    NVARCHAR (50)    NOT NULL,
    [MiddleName]   NVARCHAR (50)    NULL,
    [LastName]     NVARCHAR (50)    NOT NULL,
    [Suffix]       NVARCHAR (10)    NULL,
    [CompanyName]  NVARCHAR (128)   NULL,
    [SalesPerson]  NVARCHAR (256)   NULL,
    [EmailAddress] NVARCHAR (50)    NULL,
    [Phone]        NVARCHAR (25)    NULL,
    [PasswordHash] VARCHAR (128)    NOT NULL,
    [PasswordSalt] VARCHAR (10)     NOT NULL,
    [rowguid]      UNIQUEIDENTIFIER CONSTRAINT [DF_Customer_rowguid] DEFAULT (newid()) ROWGUIDCOL NOT NULL,
    [ModifiedDate] DATETIME         CONSTRAINT [DF_Customer_ModifiedDate] DEFAULT (getdate()) NOT NULL,
    CONSTRAINT [PK_Customer_CustomerID] PRIMARY KEY CLUSTERED ([CustomerID] ASC),
    CONSTRAINT [AK_Customer_rowguid] UNIQUE NONCLUSTERED ([rowguid] ASC)
);


GO
CREATE NONCLUSTERED INDEX [IX_Customer_EmailAddress]
    ON [SalesLT].[Customer]([EmailAddress] ASC);


GO
Create trigger [SalesLT].trg_Customers_RemoverIOD on SalesLT.Customer
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