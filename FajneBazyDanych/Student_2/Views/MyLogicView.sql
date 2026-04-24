Create View Student_2.MyLogicView AS
Select ProductID, Name, Color, ListPrice,
Case
    When ListPrice < 50 Then 'Low Cost'
    When ListPrice Between 50 and 500 Then 'Mid Range'
    When ListPrice > 500 Then 'High End'
End as PriceSegment
from SalesLT.Product