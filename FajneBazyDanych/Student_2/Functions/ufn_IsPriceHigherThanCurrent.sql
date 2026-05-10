
Create   function Student_2.ufn_IsPriceHigherThanCurrent (
    @ProductJson NVARCHAR(MAX)
)
Returns bit
as
Begin
    Declare @Result bit
    Declare @JsonPrice money
    Declare @DbPrice money
    Declare @ProductId int

    Select
        @ProductId = JSON_VALUE(@ProductJson,'$.ProductID'),
        @JsonPrice = cast(JSON_VALUE(@ProductJson, '$.ListPrice') as Money);

    Select @DbPrice = ListPrice
    from SalesLT.Product
    Where ProductID = @ProductId


    If @JsonPrice > @DbPrice
        Set @Result = 1
    else
        set @Result = 0

    Return @Result
end