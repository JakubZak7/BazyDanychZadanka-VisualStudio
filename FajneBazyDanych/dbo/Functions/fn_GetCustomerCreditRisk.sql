Create   function dbo.fn_GetCustomerCreditRisk(@CustomerID int)
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