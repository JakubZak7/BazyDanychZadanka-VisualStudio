
Create   view dbo.v_ProductCategoryTree
as
    With AllHierarchies AS (
        Select * From dbo.fn_GetCategoryHierarchy('Bikes')
        Union All
        Select * From dbo.fn_GetCategoryHierarchy('Components')
        Union All
        Select * From dbo.fn_GetCategoryHierarchy('Clothing')
        Union All
        Select * From dbo.fn_GetCategoryHierarchy('Accessories')
    )
    Select 
        p.ProductID,
        p.Name as ProductName,
        ah.[Path] + ' -> ' + p.Name as FullCategoryPath
    From SalesLT.Product p
    Join AllHierarchies ah on p.ProductCategoryID = ah.ProductCategoryID;