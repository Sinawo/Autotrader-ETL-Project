CREATE PROCEDURE dbo.MyStoredProcedu
AS
BEGIN
    -- Code for the stored procedure goes here
select [Car_ID],
		   [Title], [Price], [Car Type], [Registration Year], [Mileage],
            [Transmission], [Fuel Type], [Dealership],[Suburb], [Introduction date],
            [End date], [Engine position], [Engine detail], [Engine capacity (litre)],
            [Cylinder layout and quantity], [Fuel capacity], [Fuel consumption (average) **],
            [Fuel range (average)], [Power maximum (detail)], [Torque maximum],
            [Maximum/top speed], [CO2 emissions (average)], [Acceleration 0-100 km/h],
            [Last Updated], [Previous Owners], [Service History], [Colour], [Body Type]
into Autotrade_sp
FROM dbo.overnight_table


EXEC sp_rename 'Autotrade_sp.[Mileage]', 'Mileage(km)';
EXEC sp_rename 'Autotrade_sp.[Fuel range (average)]', 'Fuel range (average)(km)';
EXEC sp_rename 'Autotrade_sp.[Torque maximum]', 'Torque maximum(Nm)';
EXEC sp_rename 'Autotrade_sp.[CO2 emissions (average)]', 'CO2 emissions (average)(g/km)';
EXEC sp_rename 'Autotrade_sp.[Engine capacity (litre)]', 'Engine capacity (litre)';
EXEC sp_rename 'Autotrade_sp.[Power maximum (detail)]', 'Power maximum (detail)(kW)';
EXEC sp_rename 'Autotrade_sp.[Fuel consumption (average) **]', 'Fuel consumption (average)/100km';
EXEC sp_rename 'Autotrade_sp.[Maximum/top speed]', 'Maximum/top speed(km/h)';
EXEC sp_rename 'Autotrade_sp.[Title]', 'Vehicle';


-- remove for sale
update Autotrade_sp
set Vehicle = Replace(Vehicle,'For Sale','');

-- remove for sale
update Autotrade_sp
set Price = Replace(Price,'R','');

-- remove year
update Autotrade_sp
set Vehicle = SUBSTRING(Vehicle, CHARINDEX(' ', Vehicle) + 1, LEN(Vehicle))

------------------------------------------------CAR MAKE------------------------------------------------------
ALTER TABLE Autotrade_sp
ADD CarMake varchar(255)

UPDATE Autotrade_sp
SET CarMake = 
  CASE
    WHEN Vehicle LIKE 'Alfa Romeo%' THEN 'Alfa Romeo'
    WHEN Vehicle LIKE 'Land Rover%' THEN 'Land Rover'
    WHEN Vehicle LIKE 'Aston Martin%' THEN 'Aston Martin'
    ELSE LEFT(Vehicle, CHARINDEX(' ', Vehicle) - 1)
  END;


-----------------------------------------------CAR MODEL--------------------------------------------------------
ALTER TABLE Autotrade_sp
ADD CarModel varchar(255)

UPDATE Autotrade_sp
SET CarModel = 
  CASE
	WHEN Vehicle LIKE 'Alfa Romeo%' THEN SUBSTRING(Vehicle, CHARINDEX('Romeo', Vehicle) + 6, CHARINDEX(' ', Vehicle, CHARINDEX('Romeo', Vehicle) + 6) - CHARINDEX('Romeo', Vehicle) - 6)
    WHEN Vehicle LIKE '%Range Rover%' THEN 'Range Rover'
	--------------------------------------------------------
	WHEN Vehicle LIKE '%FJ Cruiser%' THEN 'FJ Cruiser'
	WHEN Vehicle LIKE '%Land Cruiser%' THEN 'Land Cruiser'
	WHEN Vehicle LIKE '%Urban Cruiserr%' THEN 'Urban Cruiser'
	WHEN Vehicle LIKE '%1 Series%' THEN '1 Series'
	WHEN Vehicle LIKE '%2 Series%' THEN '2 Series'
	WHEN Vehicle LIKE '%3 Series%' THEN '3 Series'
	WHEN Vehicle LIKE '%4 Series%' THEN '4 Series'
	WHEN Vehicle LIKE '%5 Series%' THEN '5 Series'
	WHEN Vehicle LIKE '%6 Series%' THEN '6 Series'
	WHEN Vehicle LIKE '%7 Series%' THEN '7 Series'
	WHEN Vehicle LIKE '%8 Series%' THEN '8 Series'
	WHEN Vehicle LIKE '%Grand Creta%' THEN 'Grand Creta'
	WHEN Vehicle LIKE '%Grand Voyager%' THEN 'Grand Voyager'
	WHEN Vehicle LIKE '%Grand i10%' THEN 'Grand i10'
	WHEN Vehicle LIKE '%Grand Sedona%' THEN 'Grand Sedona'
	WHEN Vehicle LIKE '%Grand Cherokee%' THEN 'Grand Cherokee'
	WHEN Vehicle LIKE '%Grand Vitara%' THEN 'Grand Vitara'
	---------------------------------------------------------
	WHEN Vehicle LIKE 'Land Rover%' THEN SUBSTRING(Vehicle, CHARINDEX('Rover', Vehicle) + 6, CHARINDEX(' ', Vehicle, CHARINDEX('Rover', Vehicle) + 6) - CHARINDEX('Rover', Vehicle) - 6)
	WHEN Vehicle LIKE 'Aston Martin%' THEN SUBSTRING(Vehicle, CHARINDEX('Martin', Vehicle) + 7, CHARINDEX(' ', Vehicle, CHARINDEX('Martin', Vehicle) + 7) - CHARINDEX('Martin', Vehicle) - 7)
	ELSE SUBSTRING(Vehicle, CHARINDEX(' ', Vehicle) + 1, CHARINDEX(' ', Vehicle, CHARINDEX(' ', Vehicle) + 1) - CHARINDEX(' ', Vehicle) - 1)
  END;

--------------------------------------------------------------------------------------------------------------

----------========================================CAR SERIES============================----------------------
ALTER TABLE Autotrade_sp
ADD CarSeries varchar(255)

UPDATE Autotrade_sp
SET CarSeries = 

	CASE 
	------------------------------------------------------------------------
	----------get everything after the 4th word------------------------------
		WHEN Vehicle LIKE '%Range Rover%' THEN SUBSTRING(Vehicle, CHARINDEX(' ', Vehicle, CHARINDEX(' ', Vehicle, CHARINDEX(' ', Vehicle, CHARINDEX(' ', Vehicle) + 1) + 1) + 1) + 1, LEN(Vehicle))
	-----------------------------------------------------------------------
	----------get everything after the third word--------------------------
		WHEN Vehicle LIKE 'Alfa Romeo%' THEN SUBSTRING(Vehicle, CHARINDEX(' ', Vehicle, CHARINDEX(' ', Vehicle, CHARINDEX(' ', Vehicle) + 1) + 1) + 1, LEN(Vehicle))
		WHEN Vehicle LIKE 'Land Rover%' THEN SUBSTRING(Vehicle, CHARINDEX(' ', Vehicle, CHARINDEX(' ', Vehicle, CHARINDEX(' ', Vehicle) + 1) + 1) + 1, LEN(Vehicle))
		WHEN Vehicle LIKE 'Aston Martin%' THEN SUBSTRING(Vehicle, CHARINDEX(' ', Vehicle, CHARINDEX(' ', Vehicle, CHARINDEX(' ', Vehicle) + 1) + 1) + 1, LEN(Vehicle))
	
		WHEN Vehicle LIKE '%FJ Cruiser%' THEN SUBSTRING(Vehicle, CHARINDEX(' ', Vehicle, CHARINDEX(' ', Vehicle, CHARINDEX(' ', Vehicle) + 1) + 1) + 1, LEN(Vehicle))
		WHEN Vehicle LIKE '%Land Cruiser%' THEN SUBSTRING(Vehicle, CHARINDEX(' ', Vehicle, CHARINDEX(' ', Vehicle, CHARINDEX(' ', Vehicle) + 1) + 1) + 1, LEN(Vehicle))
		WHEN Vehicle LIKE '%Urban Cruiserr%' THEN SUBSTRING(Vehicle, CHARINDEX(' ', Vehicle, CHARINDEX(' ', Vehicle, CHARINDEX(' ', Vehicle) + 1) + 1) + 1, LEN(Vehicle))
		WHEN Vehicle LIKE '%1 Series%' THEN SUBSTRING(Vehicle, CHARINDEX(' ', Vehicle, CHARINDEX(' ', Vehicle, CHARINDEX(' ', Vehicle) + 1) + 1) + 1, LEN(Vehicle))
		WHEN Vehicle LIKE '%2 Series%' THEN SUBSTRING(Vehicle, CHARINDEX(' ', Vehicle, CHARINDEX(' ', Vehicle, CHARINDEX(' ', Vehicle) + 1) + 1) + 1, LEN(Vehicle))
		WHEN Vehicle LIKE '%3 Series%' THEN SUBSTRING(Vehicle, CHARINDEX(' ', Vehicle, CHARINDEX(' ', Vehicle, CHARINDEX(' ', Vehicle) + 1) + 1) + 1, LEN(Vehicle))
		WHEN Vehicle LIKE '%4 Series%' THEN SUBSTRING(Vehicle, CHARINDEX(' ', Vehicle, CHARINDEX(' ', Vehicle, CHARINDEX(' ', Vehicle) + 1) + 1) + 1, LEN(Vehicle))
		WHEN Vehicle LIKE '%5 Series%' THEN SUBSTRING(Vehicle, CHARINDEX(' ', Vehicle, CHARINDEX(' ', Vehicle, CHARINDEX(' ', Vehicle) + 1) + 1) + 1, LEN(Vehicle))
		WHEN Vehicle LIKE '%6 Series%' THEN SUBSTRING(Vehicle, CHARINDEX(' ', Vehicle, CHARINDEX(' ', Vehicle, CHARINDEX(' ', Vehicle) + 1) + 1) + 1, LEN(Vehicle))
		WHEN Vehicle LIKE '%7 Series%' THEN SUBSTRING(Vehicle, CHARINDEX(' ', Vehicle, CHARINDEX(' ', Vehicle, CHARINDEX(' ', Vehicle) + 1) + 1) + 1, LEN(Vehicle))
		WHEN Vehicle LIKE '%8 Series%' THEN SUBSTRING(Vehicle, CHARINDEX(' ', Vehicle, CHARINDEX(' ', Vehicle, CHARINDEX(' ', Vehicle) + 1) + 1) + 1, LEN(Vehicle))
		WHEN Vehicle LIKE '%Grand Creta%' THEN SUBSTRING(Vehicle, CHARINDEX(' ', Vehicle, CHARINDEX(' ', Vehicle, CHARINDEX(' ', Vehicle) + 1) + 1) + 1, LEN(Vehicle))
		WHEN Vehicle LIKE '%Grand Voyager%' THEN SUBSTRING(Vehicle, CHARINDEX(' ', Vehicle, CHARINDEX(' ', Vehicle, CHARINDEX(' ', Vehicle) + 1) + 1) + 1, LEN(Vehicle))
		WHEN Vehicle LIKE '%Grand i10%' THEN SUBSTRING(Vehicle, CHARINDEX(' ', Vehicle, CHARINDEX(' ', Vehicle, CHARINDEX(' ', Vehicle) + 1) + 1) + 1, LEN(Vehicle))
		WHEN Vehicle LIKE '%Grand Sedona%' THEN SUBSTRING(Vehicle, CHARINDEX(' ', Vehicle, CHARINDEX(' ', Vehicle, CHARINDEX(' ', Vehicle) + 1) + 1) + 1, LEN(Vehicle))
		WHEN Vehicle LIKE '%Grand Cherokee%' THEN SUBSTRING(Vehicle, CHARINDEX(' ', Vehicle, CHARINDEX(' ', Vehicle, CHARINDEX(' ', Vehicle) + 1) + 1) + 1, LEN(Vehicle))
		WHEN Vehicle LIKE '%Grand Vitara%' THEN SUBSTRING(Vehicle, CHARINDEX(' ', Vehicle, CHARINDEX(' ', Vehicle, CHARINDEX(' ', Vehicle) + 1) + 1) + 1, LEN(Vehicle))
	---------------------------------------------------------
	ELSE SUBSTRING(Vehicle, CHARINDEX(' ', Vehicle, CHARINDEX(' ', Vehicle) + 1) + 1, LEN(Vehicle))
	END;

-- remove km
update Autotrade_sp
set [Mileage(km)] = Replace([Mileage(km)], 'km','')

-------------------------------  MOVE VALUES TO THE CORRECT COLUMNS  ----------------------------------------
UPDATE [dbo].[Autotrade_sp]
SET [Mileage(km)] = CASE
                        WHEN [Transmission] NOT LIKE 'Automatic' AND [Transmission] NOT LIKE 'Manual' THEN [Transmission]
                        ELSE [Mileage(km)]
                    END,
    [Transmission] = CASE
                        WHEN [Transmission] LIKE 'Automatic' OR [Transmission] LIKE 'Manual' THEN [Transmission]
                        ELSE 'Automatic' -- or 'Manual' based on your preference
                    END;

-- remove L
update Autotrade_sp
set [Engine capacity (litre)] = Replace([Engine capacity (litre)], 'L','')

-- remove kW
update Autotrade_sp
set [Power maximum (detail)(kW)] = Replace([Power maximum (detail)(kW)], 'kW','')

-- remove km/h
update Autotrade_sp
set [Maximum/top speed(km/h)] = Replace([Maximum/top speed(km/h)], 'km/h','')
-------------------------------------------------------------------------------------------
-- remove g/km
UPDATE Autotrade_sp
set [CO2 emissions (average)(g/km)] = Replace([CO2 emissions (average)(g/km)] , 'g/km', '');

-- remove Nm
UPDATE Autotrade_sp
set [Torque maximum(Nm)] = Replace([Torque maximum(Nm)] , 'Nm', '');

-- remove km
UPDATE Autotrade_sp
set [Fuel range (average)(km)] = Replace([Fuel range (average)(km)] , 'km', '');

-- remove /100km
UPDATE Autotrade_sp
set [Fuel consumption (average)/100km] = Replace([Fuel consumption (average)/100km] , '/100km', '');

-- get total
UPDATE Autotrade_sp
SET [Fuel capacity] = 
    CASE
        WHEN CHARINDEX('(total', [Fuel capacity]) > 0 THEN SUBSTRING([Fuel capacity], CHARINDEX('(total', [Fuel capacity]) + 7, CHARINDEX(')', [Fuel capacity]) - CHARINDEX('(total', [Fuel capacity]) - 7)
        ELSE [Fuel capacity]
		END;

UPDATE Autotrade_sp
SET [Power maximum (detail)(kW)] = 
    CASE
        WHEN CHARINDEX('(total', [Power maximum (detail)(kW)]) > 0 THEN
            SUBSTRING([Power maximum (detail)(kW)], CHARINDEX('(total', [Power maximum (detail)(kW)]) + 7, CHARINDEX(')', [Power maximum (detail)(kW)], CHARINDEX('(total', [Power maximum (detail)(kW)]) + 7) - CHARINDEX('(total', [Power maximum (detail)(kW)]) - 7)
        ELSE [Power maximum (detail)(kW)]
    END;

DECLARE @counter INT = 0;

WHILE @counter < 8
BEGIN
    UPDATE Autotrade_sp
SET [Acceleration 0-100 km/h] = REVERSE(SUBSTRING(REVERSE([Acceleration 0-100 km/h]), CHARINDEX(' ', REVERSE([Acceleration 0-100 km/h])) + 1, LEN([Acceleration 0-100 km/h])))

UPDATE Autotrade_sp
SET [Fuel range (average)(km)] = REVERSE(SUBSTRING(REVERSE([Fuel range (average)(km)]), CHARINDEX(' ', REVERSE([Fuel range (average)(km)])) + 1, LEN([Fuel range (average)(km)])))

UPDATE Autotrade_sp
SET [Power maximum (detail)(kW)] = REVERSE(SUBSTRING(REVERSE([Power maximum (detail)(kW)]), CHARINDEX(' ', REVERSE([Power maximum (detail)(kW)])) + 1, LEN([Power maximum (detail)(kW)])))

UPDATE Autotrade_sp
SET [Maximum/top speed(km/h)] = REVERSE(SUBSTRING(REVERSE([Maximum/top speed(km/h)]), CHARINDEX(' ', REVERSE([Maximum/top speed(km/h)])) + 1, LEN([Maximum/top speed(km/h)])))

    SET @counter = @counter + 1;
END;

UPDATE Autotrade_sp
SET [Fuel Capacity] = REVERSE(SUBSTRING(REVERSE([Fuel Capacity]), CHARINDEX(' ', REVERSE([Fuel Capacity])) + 1, LEN([Fuel Capacity])))

----------------------------------------------------------------------------------------------------------------
-- get total
UPDATE Autotrade_sp
SET [Fuel capacity] = 
    CASE
        WHEN CHARINDEX('(total', [Fuel capacity]) > 0 THEN SUBSTRING([Fuel capacity], CHARINDEX('(total', [Fuel capacity]) + 7, CHARINDEX(')', [Fuel capacity]) - CHARINDEX('(total', [Fuel capacity]) - 7)
        ELSE [Fuel capacity]
		END;

UPDATE Autotrade_sp
SET [Power maximum (detail)(kW)] = 
    CASE
        WHEN CHARINDEX('(total', [Power maximum (detail)(kW)]) > 0 THEN
            SUBSTRING([Power maximum (detail)(kW)], CHARINDEX('(total', [Power maximum (detail)(kW)]) + 7, CHARINDEX(')', [Power maximum (detail)(kW)], CHARINDEX('(total', [Power maximum (detail)(kW)]) + 7) - CHARINDEX('(total', [Power maximum (detail)(kW)]) - 7)
        ELSE [Power maximum (detail)(kW)]
    END;

   
END;

EXEC dbo.MyStoredProcedu;

    
