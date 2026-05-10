Create   Function SalesLT.BestRecord (
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