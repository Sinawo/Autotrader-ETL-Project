

exec overnight_table_SP -- updatesNClean Flat_table data
exec SplitDealers_SP
exec CreateDealerTables
exec Update_DimVehicle
exec Update_Fact_table





























select * from DeGenerics

select * from Dim_Dealerships

Inser
drop table Dim_Vehicle
select * from Flat_Updated

select distinct Make, Model, Variant from Flat_Updated

alter table DIm_Vehicle 
drop column Vehicle_ID
select count(*) from Dim_vehicle 

INSERT INTO Dim_Vehicle (vehicle_ID, Make, Model, Variant)
SELECT
    'V-' + UPPER(LEFT(fu.Make, 3)) + '-' + UPPER(LEFT(fu.Model, 2)) + '-' + RIGHT('0000' + CAST(ROW_NUMBER() OVER (ORDER BY fu.Make, fu.Model, fu.Variant) AS VARCHAR(20)), 4) + '-' + UPPER(RIGHT(fu.Variant, 2)),
    fu.Make,[dbo].[CreateDealerTables]
    fu.Model,
    fu.Variant
FROM
    (
    SELECT DISTINCT Make, Model, Variant
    FROM Flat_Updated
    ) fu
LEFT JOIN
    Dim_Vehicle dv ON fu.Make = dv.Make AND fu.Model = dv.Model AND fu.Variant = dv.Variant
WHERE
    dv.vehicle_ID IS NULL;



select * from Dim_Vehicle
