
-- Linijka do sprawdzenia czy działa
-- SELECT student_2.ufn_IsPriceHigherThanCurrent('{"ProductID": 680, "ListPrice": 5000.00}') AS IsHigherThenCurrent;

-- =============================================
-- Zadanie 5
-- =============================================

-- Robiąc to postanowiłem że zrobie po prostu porównywarke cen na więcej niż jedną wartość, wierzę że to spełnia to zadanie :)

Create   function Student_2.ufn_CheckMultipleProductsPrices (
    @JsonArray NVARCHAR(MAX)
)
Returns Table
as
Return (
        
    Select
-- value tutaj w kontekście wyciągnięcia zawartości elementu jsonowego, czyli mówiąc prościej tekstu
        JSON_VALUE(value, '$.ProductID') as ProductID,
        Student_2.ufn_IsPriceHigherThanCurrent(value) as IsPriceHigher
        From OPENJSON(@JsonArray)
)