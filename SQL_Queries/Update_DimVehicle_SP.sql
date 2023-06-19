
CREATE PROCEDURE Update_DimVehicle
AS
BEGIN

insert into Dim_Vehicle
select distinct 
Make, Model, Variant, 
'V-' + UPPER(LEFT(Make, 3)) + '-' + UPPER(LEFT(Model, 2)) + '-' + RIGHT('0000' + CAST(ROW_NUMBER() OVER (ORDER BY Make, Model, Variant) AS VARCHAR(20)), 4) + '-' + UPPER(RIGHT(Variant, 2))
-- into Dim_Vehicle
from Flat_Updated

WHERE NOT EXISTS (
    SELECT 1
    FROM Dim_Vehicle
    WHERE Dim_Vehicle.Make = Flat_Updated.Make AND Dim_Vehicle.Model = Flat_Updated.Model AND Dim_Vehicle.Variant = Flat_Updated.Variant
)
END


