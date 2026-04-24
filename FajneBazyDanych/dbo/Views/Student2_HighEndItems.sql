Create View Student2_HighEndItems AS
Select ProductID, Name, Color, ListPrice, PriceSegment
From Student_2.MyLogicView Where PriceSegment = 'High End'