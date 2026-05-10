CREATE TABLE [SalesLT].[DeletedCustomersLog] (
    [DCL_ID]      INT           IDENTITY (1, 1) NOT NULL,
    [CustomerID]  INT           NULL,
    [FirstName]   NVARCHAR (50) NULL,
    [LastName]    NVARCHAR (50) NULL,
    [DeletedDate] DATETIME      DEFAULT (getdate()) NULL,
    PRIMARY KEY CLUSTERED ([DCL_ID] ASC)
);

