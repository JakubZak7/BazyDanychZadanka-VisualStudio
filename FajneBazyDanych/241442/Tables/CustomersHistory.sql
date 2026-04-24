CREATE TABLE [241442].[CustomersHistory] (
    [CustomerID]   INT                        NOT NULL,
    [NameStyle]    [dbo].[NameStyle]          NOT NULL,
    [Title]        NVARCHAR (8)               NULL,
    [FirstName]    [dbo].[Name]               NOT NULL,
    [MiddleName]   [dbo].[Name]               NULL,
    [LastName]     [J2_surname].[SurnameType] NOT NULL,
    [Suffix]       NVARCHAR (10)              NULL,
    [CompanyName]  NVARCHAR (128)             NULL,
    [SalesPerson]  NVARCHAR (256)             NULL,
    [EmailAddress] NVARCHAR (50)              NULL,
    [Phone]        [dbo].[Phone]              NULL,
    [PasswordHash] VARCHAR (128)              NOT NULL,
    [PasswordSalt] VARCHAR (10)               NOT NULL,
    [rowguid]      UNIQUEIDENTIFIER           NOT NULL,
    [ModifiedDate] DATETIME                   NOT NULL,
    [SysStartTime] DATETIME2 (7)              NOT NULL,
    [SysEndTime]   DATETIME2 (7)              NOT NULL
);


GO
CREATE CLUSTERED INDEX [ix_CustomersHistory]
    ON [241442].[CustomersHistory]([SysEndTime] ASC, [SysStartTime] ASC) WITH (DATA_COMPRESSION = PAGE);

