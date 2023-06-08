

CREATE PROCEDURE overnight_table_SP
AS
BEGIN

INSERT INTO Flat_Updated  -- inserts data into existing column

SELECT
	--DECLARE @TitleNew VARCHAR(100);
	--SET @TitleNew = SUBSTRING(Replace(Title, 'For Sale', ''), CHARINDEX(' ', Title) + 1, LEN(Title));

    Car_ID,
	SUBSTRING(Replace(Title,'For Sale',''), CHARINDEX(' ', Title) + 1, LEN(Title)) AS Vehicle, 
	CASE 
		WHEN
		TRY_CAST(REPLACE(REPLACE(REPLACE(REPLACE([Mileage], 'km', ''), ' ', ''), 'Â', ''), CHAR(160), '') AS NUMERIC) < 501 
		THEN REPLACE([Car Type], 'Used Car', 'New Car')
		ELSE [Car Type] 
	END AS [Car Type], 
	[Registration Year], [Fuel Type], Dealership, Suburb, [Introduction date],
	[End date], [Engine position], [Engine detail], [Cylinder layout and quantity], [Last Updated], [Previous Owners],
	[Service History], [Colour], [Body Type],

	CASE WHEN Transmission LIKE '%KM%' THEN Mileage ELSE Transmission END AS Transmission,
	
    
	--------------------create car make column-----------------------------------------

	CASE
		WHEN SUBSTRING(Replace(Title, 'For Sale', ''), CHARINDEX(' ', Title) + 1, LEN(Title)) LIKE 'Alfa Romeo%' THEN 'Alfa Romeo'
		WHEN SUBSTRING(Replace(Title, 'For Sale', ''), CHARINDEX(' ', Title) + 1, LEN(Title)) LIKE 'Land Rover%' THEN 'Land Rover'
		WHEN SUBSTRING(Replace(Title, 'For Sale', ''), CHARINDEX(' ', Title) + 1, LEN(Title)) LIKE 'Aston Martin%' THEN 'Aston Martin'
		ELSE LEFT(SUBSTRING(Replace(Title, 'For Sale', ''), CHARINDEX(' ', Title) + 1, LEN(Title)), CHARINDEX(' ', SUBSTRING(Replace(Title, 'For Sale', ''), CHARINDEX(' ', Title) + 1, LEN(Title))) - 1)
	END AS Make,

	---------------------------car model-------------------------------------------------
	CASE
		WHEN Title LIKE 'Alfa Romeo%' 
			THEN SUBSTRING(SUBSTRING(Replace(Title, 'For Sale', ''), CHARINDEX(' ', Title) + 1, LEN(Title)), CHARINDEX('Romeo', SUBSTRING(Replace(Title, 'For Sale', ''), CHARINDEX(' ', Title) + 1, LEN(Title))) + 6, 
					CHARINDEX(' ', SUBSTRING(Replace(Title, 'For Sale', ''), CHARINDEX(' ', Title) + 1, LEN(Title)), CHARINDEX('Romeo', SUBSTRING(Replace(Title, 'For Sale', ''), CHARINDEX(' ', Title) + 1, LEN(Title))) + 6) - 
						CHARINDEX('Romeo', SUBSTRING(Replace(Title, 'For Sale', ''), CHARINDEX(' ', Title) + 1, LEN(Title))) - 6)
    WHEN SUBSTRING(Replace(Title, 'For Sale', ''), CHARINDEX(' ', Title) + 1, LEN(Title)) LIKE '%Range Rover%' THEN 'Range Rover'
	--------------------------------------------------------
	WHEN SUBSTRING(Replace(Title, 'For Sale', ''), CHARINDEX(' ', Title) + 1, LEN(Title)) LIKE '%FJ Cruiser%' THEN 'FJ Cruiser'
	WHEN SUBSTRING(Replace(Title, 'For Sale', ''), CHARINDEX(' ', Title) + 1, LEN(Title)) LIKE '%Land Cruiser%' THEN 'Land Cruiser'
	WHEN SUBSTRING(Replace(Title, 'For Sale', ''), CHARINDEX(' ', Title) + 1, LEN(Title)) LIKE '%Urban Cruiserr%' THEN 'Urban Cruiser'
	WHEN SUBSTRING(Replace(Title, 'For Sale', ''), CHARINDEX(' ', Title) + 1, LEN(Title)) LIKE '%1 Series%' THEN '1 Series'
	WHEN SUBSTRING(Replace(Title, 'For Sale', ''), CHARINDEX(' ', Title) + 1, LEN(Title)) LIKE '%2 Series%' THEN '2 Series'
	WHEN SUBSTRING(Replace(Title, 'For Sale', ''), CHARINDEX(' ', Title) + 1, LEN(Title)) LIKE '%3 Series%' THEN '3 Series'
	WHEN SUBSTRING(Replace(Title, 'For Sale', ''), CHARINDEX(' ', Title) + 1, LEN(Title)) LIKE '%4 Series%' THEN '4 Series'
	WHEN SUBSTRING(Replace(Title, 'For Sale', ''), CHARINDEX(' ', Title) + 1, LEN(Title)) LIKE '%5 Series%' THEN '5 Series'
	WHEN SUBSTRING(Replace(Title, 'For Sale', ''), CHARINDEX(' ', Title) + 1, LEN(Title)) LIKE '%6 Series%' THEN '6 Series'
	WHEN SUBSTRING(Replace(Title, 'For Sale', ''), CHARINDEX(' ', Title) + 1, LEN(Title)) LIKE '%7 Series%' THEN '7 Series'
	WHEN SUBSTRING(Replace(Title, 'For Sale', ''), CHARINDEX(' ', Title) + 1, LEN(Title)) LIKE '%8 Series%' THEN '8 Series'
	WHEN SUBSTRING(Replace(Title, 'For Sale', ''), CHARINDEX(' ', Title) + 1, LEN(Title)) LIKE '%Grand Creta%' THEN 'Grand Creta'
	WHEN SUBSTRING(Replace(Title, 'For Sale', ''), CHARINDEX(' ', Title) + 1, LEN(Title)) LIKE '%Grand Voyager%' THEN 'Grand Voyager'
	WHEN SUBSTRING(Replace(Title, 'For Sale', ''), CHARINDEX(' ', Title) + 1, LEN(Title)) LIKE '%Grand i10%' THEN 'Grand i10'
	WHEN SUBSTRING(Replace(Title, 'For Sale', ''), CHARINDEX(' ', Title) + 1, LEN(Title)) LIKE '%Grand Sedona%' THEN 'Grand Sedona'
	WHEN SUBSTRING(Replace(Title, 'For Sale', ''), CHARINDEX(' ', Title) + 1, LEN(Title)) LIKE '%Grand Cherokee%' THEN 'Grand Cherokee'
	WHEN SUBSTRING(Replace(Title, 'For Sale', ''), CHARINDEX(' ', Title) + 1, LEN(Title)) LIKE '%Grand Vitara%' THEN 'Grand Vitara'
	WHEN SUBSTRING(Replace(Title, 'For Sale', ''), CHARINDEX(' ', Title) + 1, LEN(Title)) LIKE '%Super Seven%' THEN 'Super Seven'
	WHEN SUBSTRING(Replace(Title, 'For Sale', ''), CHARINDEX(' ', Title) + 1, LEN(Title)) LIKE '%Super Series%' THEN 'Super Series'
	---------------------------------------------------------
	WHEN SUBSTRING(Replace(Title, 'For Sale', ''), CHARINDEX(' ', Title) + 1, LEN(Title)) LIKE 'Land Rover%' 
		THEN SUBSTRING(SUBSTRING(Replace(Title, 'For Sale', ''), CHARINDEX(' ', Title) + 1, LEN(Title)), CHARINDEX('Rover', SUBSTRING(Replace(Title, 'For Sale', ''), CHARINDEX(' ', Title) + 1, LEN(Title))) + 6, 
				CHARINDEX(' ', SUBSTRING(Replace(Title, 'For Sale', ''), CHARINDEX(' ', Title) + 1, LEN(Title)), CHARINDEX('Rover', SUBSTRING(Replace(Title, 'For Sale', ''), CHARINDEX(' ', Title) + 1, LEN(Title))) + 6) - 
					CHARINDEX('Rover', SUBSTRING(Replace(Title, 'For Sale', ''), CHARINDEX(' ', Title) + 1, LEN(Title))) - 6)

	WHEN SUBSTRING(Replace(Title, 'For Sale', ''), CHARINDEX(' ', Title) + 1, LEN(Title)) LIKE 'Aston Martin%' 
		THEN SUBSTRING(SUBSTRING(Replace(Title, 'For Sale', ''), CHARINDEX(' ', Title) + 1, LEN(Title)), CHARINDEX('Martin', SUBSTRING(Replace(Title, 'For Sale', ''), CHARINDEX(' ', Title) + 1, LEN(Title))) + 7, 
				CHARINDEX(' ', SUBSTRING(Replace(Title, 'For Sale', ''), CHARINDEX(' ', Title) + 1, LEN(Title)), CHARINDEX('Martin', SUBSTRING(Replace(Title, 'For Sale', ''), CHARINDEX(' ', Title) + 1, LEN(Title))) + 7) - 
					CHARINDEX('Martin', SUBSTRING(Replace(Title, 'For Sale', ''), CHARINDEX(' ', Title) + 1, LEN(Title))) - 7)

	ELSE SUBSTRING(SUBSTRING(Replace(Title, 'For Sale', ''), CHARINDEX(' ', Title) + 1, LEN(Title)), CHARINDEX(' ', SUBSTRING(Replace(Title, 'For Sale', ''), CHARINDEX(' ', Title) + 1, LEN(Title))) + 1, 
			CHARINDEX(' ', SUBSTRING(Replace(Title, 'For Sale', ''), CHARINDEX(' ', Title) + 1, LEN(Title)), CHARINDEX(' ', SUBSTRING(Replace(Title, 'For Sale', ''), CHARINDEX(' ', Title) + 1, LEN(Title))) + 1) - 
				CHARINDEX(' ', SUBSTRING(Replace(Title, 'For Sale', ''), CHARINDEX(' ', Title) + 1, LEN(Title))) - 1)
	END AS Model,

	------------------------------------------------Variant-------------------------------------

	CASE 
	------------------------------------------------------------------------
	----------get everything after the 4th word------------------------------
		WHEN Title LIKE '%Range Rover%' 
			THEN SUBSTRING(SUBSTRING(Replace(Title, 'For Sale', ''), CHARINDEX(' ', Title) + 1, LEN(Title)), 
					CHARINDEX(' ', SUBSTRING(Replace(Title, 'For Sale', ''), CHARINDEX(' ', Title) + 1, LEN(Title)), 
						CHARINDEX(' ', SUBSTRING(Replace(Title, 'For Sale', ''), CHARINDEX(' ', Title) + 1, LEN(Title)), 
							CHARINDEX(' ', SUBSTRING(Replace(Title, 'For Sale', ''), CHARINDEX(' ', Title) + 1, LEN(Title)), 
								CHARINDEX(' ', SUBSTRING(Replace(Title, 'For Sale', ''), CHARINDEX(' ', Title) + 1, LEN(Title))) + 1) + 1) + 1) + 1, 
									LEN(SUBSTRING(Replace(Title, 'For Sale', ''), CHARINDEX(' ', Title) + 1, LEN(Title))))
	-----------------------------------------------------------------------
	----------get everything after the third word--------------------------
		WHEN Title LIKE 'Alfa Romeo%' 
			THEN SUBSTRING(SUBSTRING(Replace(Title, 'For Sale', ''), CHARINDEX(' ', Title) + 1, LEN(Title)), 
				 CHARINDEX(' ', SUBSTRING(Replace(Title, 'For Sale', ''), CHARINDEX(' ', Title) + 1, LEN(Title)), 
				 CHARINDEX(' ', SUBSTRING(Replace(Title, 'For Sale', ''), CHARINDEX(' ', Title) + 1, LEN(Title)), 
				 CHARINDEX(' ', SUBSTRING(Replace(Title, 'For Sale', ''), CHARINDEX(' ', Title) + 1, LEN(Title))) + 1) + 1) + 1, 
				 LEN(SUBSTRING(Replace(Title, 'For Sale', ''), CHARINDEX(' ', Title) + 1, LEN(Title))))

		WHEN Title LIKE 'Land Rover%' 
			THEN SUBSTRING(SUBSTRING(Replace(Title, 'For Sale', ''), CHARINDEX(' ', Title) + 1, LEN(Title)), 
				 CHARINDEX(' ', SUBSTRING(Replace(Title, 'For Sale', ''), CHARINDEX(' ', Title) + 1, LEN(Title)), 
				 CHARINDEX(' ', SUBSTRING(Replace(Title, 'For Sale', ''), CHARINDEX(' ', Title) + 1, LEN(Title)), 
				 CHARINDEX(' ', SUBSTRING(Replace(Title, 'For Sale', ''), CHARINDEX(' ', Title) + 1, LEN(Title))) + 1) + 1) + 1, 
				 LEN(SUBSTRING(Replace(Title, 'For Sale', ''), CHARINDEX(' ', Title) + 1, LEN(Title))))
		WHEN Title LIKE 'Aston Martin%' 
			THEN SUBSTRING(SUBSTRING(Replace(Title, 'For Sale', ''), CHARINDEX(' ', Title) + 1, LEN(Title)), 
				 CHARINDEX(' ', SUBSTRING(Replace(Title, 'For Sale', ''), CHARINDEX(' ', Title) + 1, LEN(Title)), 
				 CHARINDEX(' ', SUBSTRING(Replace(Title, 'For Sale', ''), CHARINDEX(' ', Title) + 1, LEN(Title)), 
				 CHARINDEX(' ', SUBSTRING(Replace(Title, 'For Sale', ''), CHARINDEX(' ', Title) + 1, LEN(Title))) + 1) + 1) + 1, 
				 LEN(SUBSTRING(Replace(Title, 'For Sale', ''), CHARINDEX(' ', Title) + 1, LEN(Title))))
				 
		WHEN Title LIKE '%FJ Cruiser%' 
			THEN SUBSTRING(SUBSTRING(Replace(Title, 'For Sale', ''), CHARINDEX(' ', Title) + 1, LEN(Title)), 
				 CHARINDEX(' ', SUBSTRING(Replace(Title, 'For Sale', ''), CHARINDEX(' ', Title) + 1, LEN(Title)), 
				 CHARINDEX(' ', SUBSTRING(Replace(Title, 'For Sale', ''), CHARINDEX(' ', Title) + 1, LEN(Title)), 
				 CHARINDEX(' ', SUBSTRING(Replace(Title, 'For Sale', ''), CHARINDEX(' ', Title) + 1, LEN(Title))) + 1) + 1) + 1, 
				 LEN(SUBSTRING(Replace(Title, 'For Sale', ''), CHARINDEX(' ', Title) + 1, LEN(Title))))
			
		WHEN Title LIKE '%Land Cruiser%' 
			THEN SUBSTRING(SUBSTRING(Replace(Title, 'For Sale', ''), CHARINDEX(' ', Title) + 1, LEN(Title)), 
				 CHARINDEX(' ', SUBSTRING(Replace(Title, 'For Sale', ''), CHARINDEX(' ', Title) + 1, LEN(Title)), 
				 CHARINDEX(' ', SUBSTRING(Replace(Title, 'For Sale', ''), CHARINDEX(' ', Title) + 1, LEN(Title)), 
				 CHARINDEX(' ', SUBSTRING(Replace(Title, 'For Sale', ''), CHARINDEX(' ', Title) + 1, LEN(Title))) + 1) + 1) + 1, 
				 LEN(SUBSTRING(Replace(Title, 'For Sale', ''), CHARINDEX(' ', Title) + 1, LEN(Title))))
			
		WHEN Title LIKE '%Urban Cruiserr%' 
			THEN SUBSTRING(SUBSTRING(Replace(Title, 'For Sale', ''), CHARINDEX(' ', Title) + 1, LEN(Title)), 
				 CHARINDEX(' ', SUBSTRING(Replace(Title, 'For Sale', ''), CHARINDEX(' ', Title) + 1, LEN(Title)), 
				 CHARINDEX(' ', SUBSTRING(Replace(Title, 'For Sale', ''), CHARINDEX(' ', Title) + 1, LEN(Title)), 
				 CHARINDEX(' ', SUBSTRING(Replace(Title, 'For Sale', ''), CHARINDEX(' ', Title) + 1, LEN(Title))) + 1) + 1) + 1, 
				 LEN(SUBSTRING(Replace(Title, 'For Sale', ''), CHARINDEX(' ', Title) + 1, LEN(Title))))
			
		WHEN Title LIKE '%1 Series%' 
			THEN SUBSTRING(SUBSTRING(Replace(Title, 'For Sale', ''), CHARINDEX(' ', Title) + 1, LEN(Title)), 
				 CHARINDEX(' ', SUBSTRING(Replace(Title, 'For Sale', ''), CHARINDEX(' ', Title) + 1, LEN(Title)), 
				 CHARINDEX(' ', SUBSTRING(Replace(Title, 'For Sale', ''), CHARINDEX(' ', Title) + 1, LEN(Title)), 
				 CHARINDEX(' ', SUBSTRING(Replace(Title, 'For Sale', ''), CHARINDEX(' ', Title) + 1, LEN(Title))) + 1) + 1) + 1, 
				 LEN(SUBSTRING(Replace(Title, 'For Sale', ''), CHARINDEX(' ', Title) + 1, LEN(Title))))
			
		WHEN Title LIKE '%2 Series%' 
			THEN SUBSTRING(SUBSTRING(Replace(Title, 'For Sale', ''), CHARINDEX(' ', Title) + 1, LEN(Title)), 
				 CHARINDEX(' ', SUBSTRING(Replace(Title, 'For Sale', ''), CHARINDEX(' ', Title) + 1, LEN(Title)), 
				 CHARINDEX(' ', SUBSTRING(Replace(Title, 'For Sale', ''), CHARINDEX(' ', Title) + 1, LEN(Title)), 
				 CHARINDEX(' ', SUBSTRING(Replace(Title, 'For Sale', ''), CHARINDEX(' ', Title) + 1, LEN(Title))) + 1) + 1) + 1, 
				 LEN(SUBSTRING(Replace(Title, 'For Sale', ''), CHARINDEX(' ', Title) + 1, LEN(Title))))
			
		WHEN Title LIKE '%3 Series%' 
			THEN SUBSTRING(SUBSTRING(Replace(Title, 'For Sale', ''), CHARINDEX(' ', Title) + 1, LEN(Title)), 
				 CHARINDEX(' ', SUBSTRING(Replace(Title, 'For Sale', ''), CHARINDEX(' ', Title) + 1, LEN(Title)), 
				 CHARINDEX(' ', SUBSTRING(Replace(Title, 'For Sale', ''), CHARINDEX(' ', Title) + 1, LEN(Title)), 
				 CHARINDEX(' ', SUBSTRING(Replace(Title, 'For Sale', ''), CHARINDEX(' ', Title) + 1, LEN(Title))) + 1) + 1) + 1, 
				 LEN(SUBSTRING(Replace(Title, 'For Sale', ''), CHARINDEX(' ', Title) + 1, LEN(Title))))
			
		WHEN Title LIKE '%4 Series%' 
			THEN SUBSTRING(SUBSTRING(Replace(Title, 'For Sale', ''), CHARINDEX(' ', Title) + 1, LEN(Title)), 
				 CHARINDEX(' ', SUBSTRING(Replace(Title, 'For Sale', ''), CHARINDEX(' ', Title) + 1, LEN(Title)), 
				 CHARINDEX(' ', SUBSTRING(Replace(Title, 'For Sale', ''), CHARINDEX(' ', Title) + 1, LEN(Title)), 
				 CHARINDEX(' ', SUBSTRING(Replace(Title, 'For Sale', ''), CHARINDEX(' ', Title) + 1, LEN(Title))) + 1) + 1) + 1, 
				 LEN(SUBSTRING(Replace(Title, 'For Sale', ''), CHARINDEX(' ', Title) + 1, LEN(Title))))
			
		WHEN Title LIKE '%5 Series%' 
			THEN SUBSTRING(SUBSTRING(Replace(Title, 'For Sale', ''), CHARINDEX(' ', Title) + 1, LEN(Title)), 
				 CHARINDEX(' ', SUBSTRING(Replace(Title, 'For Sale', ''), CHARINDEX(' ', Title) + 1, LEN(Title)), 
				 CHARINDEX(' ', SUBSTRING(Replace(Title, 'For Sale', ''), CHARINDEX(' ', Title) + 1, LEN(Title)), 
				 CHARINDEX(' ', SUBSTRING(Replace(Title, 'For Sale', ''), CHARINDEX(' ', Title) + 1, LEN(Title))) + 1) + 1) + 1, 
				 LEN(SUBSTRING(Replace(Title, 'For Sale', ''), CHARINDEX(' ', Title) + 1, LEN(Title))))
			
		WHEN Title LIKE '%6 Series%' 
			THEN SUBSTRING(SUBSTRING(Replace(Title, 'For Sale', ''), CHARINDEX(' ', Title) + 1, LEN(Title)), 
				 CHARINDEX(' ', SUBSTRING(Replace(Title, 'For Sale', ''), CHARINDEX(' ', Title) + 1, LEN(Title)), 
				 CHARINDEX(' ', SUBSTRING(Replace(Title, 'For Sale', ''), CHARINDEX(' ', Title) + 1, LEN(Title)), 
				 CHARINDEX(' ', SUBSTRING(Replace(Title, 'For Sale', ''), CHARINDEX(' ', Title) + 1, LEN(Title))) + 1) + 1) + 1, 
				 LEN(SUBSTRING(Replace(Title, 'For Sale', ''), CHARINDEX(' ', Title) + 1, LEN(Title))))
			
		WHEN Title LIKE '%7 Series%' 
			THEN SUBSTRING(SUBSTRING(Replace(Title, 'For Sale', ''), CHARINDEX(' ', Title) + 1, LEN(Title)), 
				 CHARINDEX(' ', SUBSTRING(Replace(Title, 'For Sale', ''), CHARINDEX(' ', Title) + 1, LEN(Title)), 
				 CHARINDEX(' ', SUBSTRING(Replace(Title, 'For Sale', ''), CHARINDEX(' ', Title) + 1, LEN(Title)), 
				 CHARINDEX(' ', SUBSTRING(Replace(Title, 'For Sale', ''), CHARINDEX(' ', Title) + 1, LEN(Title))) + 1) + 1) + 1, 
				 LEN(SUBSTRING(Replace(Title, 'For Sale', ''), CHARINDEX(' ', Title) + 1, LEN(Title)))
			)
		WHEN Title LIKE '%8 Series%' 
			THEN SUBSTRING(SUBSTRING(Replace(Title, 'For Sale', ''), CHARINDEX(' ', Title) + 1, LEN(Title)), 
				 CHARINDEX(' ', SUBSTRING(Replace(Title, 'For Sale', ''), CHARINDEX(' ', Title) + 1, LEN(Title)), 
				 CHARINDEX(' ', SUBSTRING(Replace(Title, 'For Sale', ''), CHARINDEX(' ', Title) + 1, LEN(Title)), 
				 CHARINDEX(' ', SUBSTRING(Replace(Title, 'For Sale', ''), CHARINDEX(' ', Title) + 1, LEN(Title))) + 1) + 1) + 1, 
				 LEN(SUBSTRING(Replace(Title, 'For Sale', ''), CHARINDEX(' ', Title) + 1, LEN(Title))))
			
		WHEN Title LIKE '%Grand Creta%'	
			THEN SUBSTRING(SUBSTRING(Replace(Title, 'For Sale', ''), CHARINDEX(' ', Title) + 1, LEN(Title)), 
				 CHARINDEX(' ', SUBSTRING(Replace(Title, 'For Sale', ''), CHARINDEX(' ', Title) + 1, LEN(Title)), 
				 CHARINDEX(' ', SUBSTRING(Replace(Title, 'For Sale', ''), CHARINDEX(' ', Title) + 1, LEN(Title)), 
				 CHARINDEX(' ', SUBSTRING(Replace(Title, 'For Sale', ''), CHARINDEX(' ', Title) + 1, LEN(Title))) + 1) + 1) + 1, 
				 LEN(SUBSTRING(Replace(Title, 'For Sale', ''), CHARINDEX(' ', Title) + 1, LEN(Title))))
			
		WHEN Title LIKE '%Grand Voyager%' 
			THEN SUBSTRING(SUBSTRING(Replace(Title, 'For Sale', ''), CHARINDEX(' ', Title) + 1, LEN(Title)), 
				 CHARINDEX(' ', SUBSTRING(Replace(Title, 'For Sale', ''), CHARINDEX(' ', Title) + 1, LEN(Title)), 
				 CHARINDEX(' ', SUBSTRING(Replace(Title, 'For Sale', ''), CHARINDEX(' ', Title) + 1, LEN(Title)), 
				 CHARINDEX(' ', SUBSTRING(Replace(Title, 'For Sale', ''), CHARINDEX(' ', Title) + 1, LEN(Title))) + 1) + 1) + 1, 
				 LEN(SUBSTRING(Replace(Title, 'For Sale', ''), CHARINDEX(' ', Title) + 1, LEN(Title))))
			
		WHEN Title LIKE '%Grand i10%'		
			THEN SUBSTRING(SUBSTRING(Replace(Title, 'For Sale', ''), CHARINDEX(' ', Title) + 1, LEN(Title)), 
				 CHARINDEX(' ', SUBSTRING(Replace(Title, 'For Sale', ''), CHARINDEX(' ', Title) + 1, LEN(Title)), 
				 CHARINDEX(' ', SUBSTRING(Replace(Title, 'For Sale', ''), CHARINDEX(' ', Title) + 1, LEN(Title)), 
				 CHARINDEX(' ', SUBSTRING(Replace(Title, 'For Sale', ''), CHARINDEX(' ', Title) + 1, LEN(Title))) + 1) + 1) + 1, 
				 LEN(SUBSTRING(Replace(Title, 'For Sale', ''), CHARINDEX(' ', Title) + 1, LEN(Title))))
			
		WHEN Title LIKE '%Grand Sedona%'	
			THEN SUBSTRING(SUBSTRING(Replace(Title, 'For Sale', ''), CHARINDEX(' ', Title) + 1, LEN(Title)), 
				 CHARINDEX(' ', SUBSTRING(Replace(Title, 'For Sale', ''), CHARINDEX(' ', Title) + 1, LEN(Title)), 
				 CHARINDEX(' ', SUBSTRING(Replace(Title, 'For Sale', ''), CHARINDEX(' ', Title) + 1, LEN(Title)), 
				 CHARINDEX(' ', SUBSTRING(Replace(Title, 'For Sale', ''), CHARINDEX(' ', Title) + 1, LEN(Title))) + 1) + 1) + 1, 
				 LEN(SUBSTRING(Replace(Title, 'For Sale', ''), CHARINDEX(' ', Title) + 1, LEN(Title))))
			
		WHEN Title LIKE '%Grand Cherokee%'
			THEN SUBSTRING(SUBSTRING(Replace(Title, 'For Sale', ''), CHARINDEX(' ', Title) + 1, LEN(Title)), 
				 CHARINDEX(' ', SUBSTRING(Replace(Title, 'For Sale', ''), CHARINDEX(' ', Title) + 1, LEN(Title)), 
				 CHARINDEX(' ', SUBSTRING(Replace(Title, 'For Sale', ''), CHARINDEX(' ', Title) + 1, LEN(Title)), 
				 CHARINDEX(' ', SUBSTRING(Replace(Title, 'For Sale', ''), CHARINDEX(' ', Title) + 1, LEN(Title))) + 1) + 1) + 1, 
				 LEN(SUBSTRING(Replace(Title, 'For Sale', ''), CHARINDEX(' ', Title) + 1, LEN(Title))))
			
		WHEN Title LIKE '%Grand Vitara%'	
			THEN SUBSTRING(SUBSTRING(Replace(Title, 'For Sale', ''), CHARINDEX(' ', Title) + 1, LEN(Title)), 
				 CHARINDEX(' ', SUBSTRING(Replace(Title, 'For Sale', ''), CHARINDEX(' ', Title) + 1, LEN(Title)), 
				 CHARINDEX(' ', SUBSTRING(Replace(Title, 'For Sale', ''), CHARINDEX(' ', Title) + 1, LEN(Title)), 
				 CHARINDEX(' ', SUBSTRING(Replace(Title, 'For Sale', ''), CHARINDEX(' ', Title) + 1, LEN(Title))) + 1) + 1) + 1, 
				 LEN(SUBSTRING(Replace(Title, 'For Sale', ''), CHARINDEX(' ', Title) + 1, LEN(Title))))

		WHEN Title LIKE '%Super Seven%'	
			THEN SUBSTRING(SUBSTRING(Replace(Title, 'For Sale', ''), CHARINDEX(' ', Title) + 1, LEN(Title)), 
				 CHARINDEX(' ', SUBSTRING(Replace(Title, 'For Sale', ''), CHARINDEX(' ', Title) + 1, LEN(Title)), 
				 CHARINDEX(' ', SUBSTRING(Replace(Title, 'For Sale', ''), CHARINDEX(' ', Title) + 1, LEN(Title)), 
				 CHARINDEX(' ', SUBSTRING(Replace(Title, 'For Sale', ''), CHARINDEX(' ', Title) + 1, LEN(Title))) + 1) + 1) + 1, 
				 LEN(SUBSTRING(Replace(Title, 'For Sale', ''), CHARINDEX(' ', Title) + 1, LEN(Title))))

		WHEN Title LIKE '%Super Series%'	
			THEN SUBSTRING(SUBSTRING(Replace(Title, 'For Sale', ''), CHARINDEX(' ', Title) + 1, LEN(Title)), 
				 CHARINDEX(' ', SUBSTRING(Replace(Title, 'For Sale', ''), CHARINDEX(' ', Title) + 1, LEN(Title)), 
				 CHARINDEX(' ', SUBSTRING(Replace(Title, 'For Sale', ''), CHARINDEX(' ', Title) + 1, LEN(Title)), 
				 CHARINDEX(' ', SUBSTRING(Replace(Title, 'For Sale', ''), CHARINDEX(' ', Title) + 1, LEN(Title))) + 1) + 1) + 1, 
				 LEN(SUBSTRING(Replace(Title, 'For Sale', ''), CHARINDEX(' ', Title) + 1, LEN(Title))))
			
	---------------------------------------------------------
	ELSE SUBSTRING(SUBSTRING(Replace(Title,'For Sale',''), CHARINDEX(' ', Title) + 1, LEN(Title)), 
		 CHARINDEX(' ', SUBSTRING(Replace(Title,'For Sale',''), CHARINDEX(' ', Title) + 1, LEN(Title)), 
		 CHARINDEX(' ', SUBSTRING(Replace(Title,'For Sale',''), CHARINDEX(' ', Title) + 1, LEN(Title))) + 1) + 1, 
		 LEN(SUBSTRING(Replace(Title,'For Sale',''), CHARINDEX(' ', Title) + 1, LEN(Title))))
	END AS Variant,

		-----------------------------------------------------------------------------------------------------------------
		--================================================================================================================
		------------------------------------------MILEAGE
	CASE 
		WHEN Mileage LIKE 'A%' OR Mileage Like 'M%' 
			THEN 
				CASE WHEN Transmission LIKE '%km' 
				THEN TRY_CAST(REPLACE(REPLACE(REPLACE(REPLACE([Mileage], 'km', ''), ' ', ''), 'Â', ''), CHAR(160), '') AS NUMERIC)
				ELSE Transmission END
		ELSE TRY_CAST(REPLACE(REPLACE(REPLACE(REPLACE([Mileage], 'km', ''), ' ', ''), 'Â', ''), CHAR(160), '') AS NUMERIC) 
		END AS Mileage,

		------------------------------------------PRICE
		TRY_CAST(REPLACE(REPLACE(Price, 'R', ''), CHAR(160), '') AS NUMERIC) AS Price,
		
		---------------------------------- [Engine capacity (litre)]

		TRIM(REPLACE(REPLACE([Engine capacity (litre)], 'L',''), '.', ',')) AS [Engine capacity (litre)], ---- [Engine capacity (litre)]

	---------------------------------------------FUEL CAPACITY-------------------------------------------------------------------
	CASE
        WHEN CHARINDEX('(total', [Fuel capacity]) > 0 THEN SUBSTRING([Fuel capacity], 
			 CHARINDEX('(total', [Fuel capacity]) + 7, CHARINDEX(')', [Fuel capacity]) - CHARINDEX('(total', [Fuel capacity]) - 7)
		
		WHEN CHARINDEX('+', [Fuel capacity]) > 0
            THEN SUBSTRING([Fuel capacity], CHARINDEX('(', [Fuel capacity]) + 1, CHARINDEX(')', [Fuel capacity]) - CHARINDEX('(', [Fuel capacity]) - 1)
       
		WHEN [Fuel capacity] = '-' THEN REPLACE([Fuel capacity],'-',NULL) 
										------REMOVES (opt)--------
		WHEN [Fuel capacity] LIKE '%(o%' THEN 
			CASE
				WHEN SUBSTRING([Fuel capacity], 3, 1) LIKE '%(%' THEN LEFT([Fuel capacity], 2)
				ELSE (LEFT([Fuel capacity], 3)) END
        ELSE TRIM([Fuel capacity])
		END AS [Fuel capacity],

	----------------------------------------------[Power maximum (detail)]-------------------------------------------------------------------
	CASE
        WHEN CHARINDEX('(total', [Power maximum (detail)]) > 0 THEN
		CASE
			WHEN [Power maximum (detail)] LIKE '%OUTPUT %'
			THEN TRIM(SUBSTRING([Power maximum (detail)], CHARINDEX('output ', [Power maximum (detail)]) + LEN('output '), 4))
		ELSE
             SUBSTRING([Power maximum (detail)], CHARINDEX('(total', [Power maximum (detail)]) + 7, 
			 CHARINDEX(')', [Power maximum (detail)], CHARINDEX('(total', [Power maximum (detail)]) + 7) - CHARINDEX('(total', [Power maximum (detail)]) - 7)
        END
		WHEN SUBSTRING([Power maximum (detail)], 5, 2) LIKE '%to%' 
		THEN LEFT([Power maximum (detail)], 3)

		WHEN [Power maximum (detail)] LIKE 'total%' AND [Power maximum (detail)] NOT LIKE 'total output%'  
		THEN SUBSTRING([Power maximum (detail)], 7, 3)

		WHEN [Power maximum (detail)] LIKE 'total output%' 
		THEN SUBSTRING([Power maximum (detail)], 14, 3)

		WHEN [Power maximum (detail)] LIKE '%on overboost%' 
		THEN TRIM(LEFT([Power maximum (detail)], 3))

		WHEN SUBSTRING([Power maximum (detail)], 5, 2) LIKE '%el%' 
		THEN LEFT([Power maximum (detail)], 3)
		
		ELSE TRIM(Replace([Power maximum (detail)], 'kW',''))
		END AS [Power maximum (detail)],

	------------------------------------------------------[Maximum/top speed]------------------------------------------------------------------------
	CASE
		WHEN SUBSTRING([Maximum/top speed], 3, 1) LIKE '%(%' THEN TRIM(LEFT([Maximum/top speed], 3))
		 

		WHEN [Maximum/top speed] LIKE '%n/a%' THEN TRIM(REPLACE([Maximum/top speed],'n/a', NULL))
		WHEN [Maximum/top speed] LIKE '-%' THEN TRIM(REPLACE([Maximum/top speed],'-', NULL))
		ELSE TRIM(LEFT([Maximum/top speed], 3))
		END AS [Maximum/top speed],
	-------------------------------------------------[CO2 emissions (average)]------------------------------------------------------------------------
	CASE
		WHEN [CO2 emissions (average)] LIKE '%n/a%' THEN TRIM(REPLACE([CO2 emissions (average)],'n/a', NULL))
		WHEN [CO2 emissions (average)] LIKE '-%' THEN TRIM(REPLACE([CO2 emissions (average)],'-', NULL))
		WHEN [CO2 emissions (average)] LIKE 'electri%' THEN TRIM(REPLACE(REPLACE([CO2 emissions (average)], 'electric', 0), 'g/km', ''))
		ELSE TRIM(Replace([CO2 emissions (average)] , 'g/km', '')) 
		END AS [CO2 emissions (average)],
	------------------------------------------------------[Torque maximum]
	CASE 
		WHEN [Torque maximum] LIKE 'engine%' THEN TRIM(REPLACE(REPLACE([Torque maximum], 'engine',''),'Nm', ''))
	ELSE TRIM(Replace([Torque maximum], 'Nm', '')) 
	END AS [Torque maximum(Nm)],
	------------------------------------------------------[Fuel range (average)]
	CASE
		WHEN SUBSTRING([Fuel range (average)], 6, 1) LIKE '%(%' THEN TRIM(LEFT([Fuel range (average)], 5))
		WHEN SUBSTRING([Fuel range (average)], 5, 1) LIKE '%(%' THEN TRIM(LEFT([Fuel range (average)], 4)) 
		WHEN SUBSTRING([Fuel range (average)], 5, 1) LIKE '%e%' THEN TRIM(LEFT([Fuel range (average)], 4))
		WHEN SUBSTRING([Fuel range (average)], 4, 1) LIKE '%e%' THEN TRIM(LEFT([Fuel range (average)], 3))
		WHEN SUBSTRING([Fuel range (average)], 9, 2) LIKE '%el%' THEN TRIM(LEFT([Fuel range (average)], 7))
		WHEN SUBSTRING([Fuel range (average)], 4, 1) LIKE '%i%' THEN TRIM(LEFT([Fuel range (average)], 3))
		WHEN SUBSTRING([Fuel range (average)], 3,1) LIKE '%-%' THEN TRIM(LEFT([Fuel range (average)], 5)) 
		WHEN [Fuel range (average)] LIKE '%?%' THEN TRIM(REPLACE(REPLACE([Fuel range (average)], '?', ''), 'km',''))
	
		WHEN [Fuel range (average)] LIKE 'up%' THEN TRIM(SUBSTRING([Fuel range (average)], 7, 4))
		WHEN [Fuel range (average)] LIKE '%n/a%' THEN TRIM(REPLACE([Fuel range (average)],'n/a', NULL))
		WHEN [Fuel range (average)] LIKE '#%' THEN TRIM(REPLACE([Fuel range (average)],'#', NULL))
		WHEN [Fuel range (average)] LIKE '%Â%' THEN TRIM(REPLACE(REPLACE([Fuel range (average)], 'Â', ''), 'km',''))
		
		ELSE TRIM(REPLACE(REPLACE(REPLACE([Fuel range (average)] , 'km', ''),'.',','), CHAR(160),'' ))
	END AS [Fuel range (average)],

	------------------------------------------------[Fuel consumption (average) **]
	CASE
		WHEN [Fuel consumption (average) **] LIKE 'n/a%' THEN TRIM(REPLACE([Fuel consumption (average) **],'n/a', NULL))
		WHEN [Fuel consumption (average) **] LIKE 'electri%' THEN TRIM(REPLACE(REPLACE([Fuel consumption (average) **], 'electric', 0) , '/100km', ''))
	ELSE TRIM(Replace([Fuel consumption (average) **] , '/100km', '')) 

	END AS [Fuel consumption (average)]
--INTO Flat_Updated			-- run once to create table
FROM overnight_table

	--	UPDATES EXISTING TABLE
WHERE NOT EXISTS (
    SELECT 1
    FROM Flat_Updated
    WHERE Flat_Updated.Car_ID = overnight_table.Car_ID
);


END

--EXEC overnight_table_SP; -- executes overnight_table_SP