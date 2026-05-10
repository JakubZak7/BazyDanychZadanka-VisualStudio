Create function Student_2.ufn_ProductJsonByCategory (
    @CategoryName NVARCHAR(50)
)
Returns NVARCHAR(MAX)
as
Begin
    Declare @Product NVARCHAR(MAX)
    set @Product = (
    Select pc.[ProductCategoryID], p.Name
    From [SalesLT].[ProductCategory] pc
    join SalesLT.Product p on pc.[ProductCategoryID] = p.[ProductCategoryID]
    where pc.Name = 'Mountain Bikes'
    for json path);

    return @Product
end