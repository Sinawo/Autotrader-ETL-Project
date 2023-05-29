--STEP 1: From the uncleaned table which is overnight_table lets take the new dataset and insert it to the Flat_Updated_Data
INSERT INTO Flat_Updated_Data (Car_ID, Title, Price, [Car Type], [Registration Year], Mileage, Transmission, [Fuel Type], Dealership, Suburb, [Introduction date], [End date], [Engine position], [Engine detail], [Engine capacity (litre)], [Cylinder layout and quantity], [Fuel capacity], [Fuel consumption (average) **], [Fuel range (average)], [Power maximum (detail)], [Torque maximum], [Maximum/top speed], [CO2 emissions (average)], [Acceleration 0-100 km/h], [Last Updated], [Previous Owners], [Service History], [Colour], [Body Type])
SELECT Car_ID, Title, Price, [Car Type], [Registration Year], Mileage, Transmission, [Fuel Type], Dealership, Suburb, [Introduction date], [End date], [Engine position], [Engine detail], [Engine capacity (litre)], [Cylinder layout and quantity], [Fuel capacity], [Fuel consumption (average) **], [Fuel range (average)], [Power maximum (detail)], [Torque maximum], [Maximum/top speed], [CO2 emissions (average)], [Acceleration 0-100 km/h], [Last Updated], [Previous Owners], [Service History], [Colour], [Body Type]
FROM overnight_table
WHERE Car_ID NOT IN (SELECT Car_ID FROM Flat_Updated_Data);

--STEP 2: Clean the data from the Flat_Updated_Data

--STEP 2: Clean the data from the Flat_Updated_Data
		-- remove for sale
		update Flat_Updated_Data
		set Title = Replace(Title,'For Sale','');
		-- remove for sale
		update Flat_Updated_Data
		set Price = Replace(Price,'R','');
		-- remove year
		update Flat_Updated_Data
		set Title = SUBSTRING(Title, CHARINDEX(' ', Title) + 1, LEN(Title))
				-- remove km
		update Flat_Updated_Data
		set [Mileage(km)] = Replace([Mileage(km)], 'km','')
		-- remove L
		update Flat_Updated_Data
		set [Engine capacity (litre)] = Replace([Engine capacity (litre)], 'L','')
		-- remove kW
		update Flat_Updated_Data
		set [Power maximum (detail)(kW)] = Replace([Power maximum (detail)(kW)], 'kW','')
		-- remove km/h
		update Flat_Updated_Data
		set [Maximum/top speed(km/h)] = Replace([Maximum/top speed(km/h)], 'km/h','')
		-------------------------------------------------------------------------------------------
		-- remove g/km
		UPDATE Flat_Updated_Data
		set [CO2 emissions (average)(g/km)] = Replace([CO2 emissions (average)(g/km)] , 'g/km', '');
		-- remove Nm
		UPDATE Flat_Updated_Data
		set [Torque maximum(Nm)] = Replace([Torque maximum(Nm)] , 'Nm', '');
		-- remove km
		UPDATE Flat_Updated_Data
		set [Fuel range (average)(km)] = Replace([Fuel range (average)(km)] , 'km', '');
		-- remove /100km
		UPDATE Flat_Updated_Data
		set [Fuel consumption (average)/100km] = Replace([Fuel consumption (average)/100km] , '/100km', '');

	
--STEP 3: Create Car make, model, and series columns to the Flat_Updated_Data


	---After the columns are added, extract the values to create the make, model and variant
	--CAR MAKE
	UPDATE Flat_Updated_Data
	SET Make = 
	  CASE
		WHEN Title LIKE 'Alfa Romeo%' THEN 'Alfa Romeo'
		WHEN Title LIKE 'Land Rover%' THEN 'Land Rover'
		WHEN Title LIKE 'Aston Martin%' THEN 'Aston Martin'
		ELSE LEFT(Title, CHARINDEX(' ', Title) - 1)
	  END;
	--CAR MODEL
	UPDATE Flat_Updated_Data
	SET Model = 
	  CASE
		WHEN Title LIKE 'Alfa Romeo%' THEN SUBSTRING(Title, CHARINDEX('Romeo', Title) + 6, CHARINDEX(' ', Title, CHARINDEX('Romeo', Title) + 6) - CHARINDEX('Romeo', Title) - 6)
		WHEN Title LIKE '%Range Rover%' THEN 'Range Rover'
		WHEN Title LIKE '%FJ Cruiser%' THEN 'FJ Cruiser'
		WHEN Title LIKE '%Land Cruiser%' THEN 'Land Cruiser'
		WHEN Title LIKE '%Urban Cruiserr%' THEN 'Urban Cruiser'
		WHEN Title LIKE '%1 Series%' THEN '1 Series'
		WHEN Title LIKE '%2 Series%' THEN '2 Series'
		WHEN Title LIKE '%3 Series%' THEN '3 Series'
		WHEN Title LIKE '%4 Series%' THEN '4 Series'
		WHEN Title LIKE '%5 Series%' THEN '5 Series'
		WHEN Title LIKE '%6 Series%' THEN '6 Series'
		WHEN Title LIKE '%7 Series%' THEN '7 Series'
		WHEN Title LIKE '%8 Series%' THEN '8 Series'
		WHEN Title LIKE '%Grand Creta%' THEN 'Grand Creta'
		WHEN Title LIKE '%Grand Voyager%' THEN 'Grand Voyager'
		WHEN Title LIKE '%Grand i10%' THEN 'Grand i10'
		WHEN Title LIKE '%Grand Sedona%' THEN 'Grand Sedona'
		WHEN Title LIKE '%Grand Cherokee%' THEN 'Grand Cherokee'
		WHEN Title LIKE '%Grand Vitara%' THEN 'Grand Vitara'
		---------------------------------------------------------
		WHEN Title LIKE 'Land Rover%' THEN SUBSTRING(Title, CHARINDEX('Rover', Title) + 6, CHARINDEX(' ', Title, CHARINDEX('Rover', Title) + 6) - CHARINDEX('Rover', Title) - 6)
		WHEN Title LIKE 'Aston Martin%' THEN SUBSTRING(Title, CHARINDEX('Martin', Title) + 7, CHARINDEX(' ', Title, CHARINDEX('Martin', Title) + 7) - CHARINDEX('Martin', Title) - 7)
		ELSE SUBSTRING(Title, CHARINDEX(' ', Title) + 1, CHARINDEX(' ', Title, CHARINDEX(' ', Title) + 1) - CHARINDEX(' ', Title) - 1)
	  END;
	--CAR VARIANT
	UPDATE Flat_Updated_Data
	SET Variant = 
		CASE 
		------------------------------------------------------------------------
		----------get everything after the 4th word------------------------------
			WHEN Title LIKE '%Range Rover%' THEN SUBSTRING(Title, CHARINDEX(' ', Title, CHARINDEX(' ', Title, CHARINDEX(' ', Title, CHARINDEX(' ', Title) + 1) + 1) + 1) + 1, LEN(Title))
		-----------------------------------------------------------------------
		----------get everything after the third word--------------------------
			WHEN Title LIKE 'Alfa Romeo%' THEN SUBSTRING(Title, CHARINDEX(' ', Title, CHARINDEX(' ', Title, CHARINDEX(' ', Title) + 1) + 1) + 1, LEN(Title))
			WHEN Title LIKE 'Land Rover%' THEN SUBSTRING(Title, CHARINDEX(' ', Title, CHARINDEX(' ', Title, CHARINDEX(' ', Title) + 1) + 1) + 1, LEN(Title))
			WHEN Title LIKE 'Aston Martin%' THEN SUBSTRING(Title, CHARINDEX(' ', Title, CHARINDEX(' ', Title, CHARINDEX(' ', Title) + 1) + 1) + 1, LEN(Title))	
			WHEN Title LIKE '%FJ Cruiser%' THEN SUBSTRING(Title, CHARINDEX(' ', Title, CHARINDEX(' ', Title, CHARINDEX(' ', Title) + 1) + 1) + 1, LEN(Title))
			WHEN Title LIKE '%Land Cruiser%' THEN SUBSTRING(Title, CHARINDEX(' ', Title, CHARINDEX(' ', Title, CHARINDEX(' ', Title) + 1) + 1) + 1, LEN(Title))
			WHEN Title LIKE '%Urban Cruiserr%' THEN SUBSTRING(Title, CHARINDEX(' ', Title, CHARINDEX(' ', Title, CHARINDEX(' ', Title) + 1) + 1) + 1, LEN(Title))
			WHEN Title LIKE '%1 Series%' THEN SUBSTRING(Title, CHARINDEX(' ', Title, CHARINDEX(' ', Title, CHARINDEX(' ', Title) + 1) + 1) + 1, LEN(Title))
			WHEN Title LIKE '%2 Series%' THEN SUBSTRING(Title, CHARINDEX(' ', Title, CHARINDEX(' ', Title, CHARINDEX(' ', Title) + 1) + 1) + 1, LEN(Title))
			WHEN Title LIKE '%3 Series%' THEN SUBSTRING(Title, CHARINDEX(' ', Title, CHARINDEX(' ', Title, CHARINDEX(' ', Title) + 1) + 1) + 1, LEN(Title))
			WHEN Title LIKE '%4 Series%' THEN SUBSTRING(Title, CHARINDEX(' ', Title, CHARINDEX(' ', Title, CHARINDEX(' ', Title) + 1) + 1) + 1, LEN(Title))
			WHEN Title LIKE '%5 Series%' THEN SUBSTRING(Title, CHARINDEX(' ', Title, CHARINDEX(' ', Title, CHARINDEX(' ', Title) + 1) + 1) + 1, LEN(Title))
			WHEN Title LIKE '%6 Series%' THEN SUBSTRING(Title, CHARINDEX(' ', Title, CHARINDEX(' ', Title, CHARINDEX(' ', Title) + 1) + 1) + 1, LEN(Title))
			WHEN Title LIKE '%7 Series%' THEN SUBSTRING(Title, CHARINDEX(' ', Title, CHARINDEX(' ', Title, CHARINDEX(' ', Title) + 1) + 1) + 1, LEN(Title))
			WHEN Title LIKE '%8 Series%' THEN SUBSTRING(Title, CHARINDEX(' ', Title, CHARINDEX(' ', Title, CHARINDEX(' ', Title) + 1) + 1) + 1, LEN(Title))
			WHEN Title LIKE '%Grand Creta%' THEN SUBSTRING(Title, CHARINDEX(' ', Title, CHARINDEX(' ', Title, CHARINDEX(' ', Title) + 1) + 1) + 1, LEN(Title))
			WHEN Title LIKE '%Grand Voyager%' THEN SUBSTRING(Title, CHARINDEX(' ', Title, CHARINDEX(' ', Title, CHARINDEX(' ', Title) + 1) + 1) + 1, LEN(Title))
			WHEN Title LIKE '%Grand i10%' THEN SUBSTRING(Title, CHARINDEX(' ', Title, CHARINDEX(' ', Title, CHARINDEX(' ', Title) + 1) + 1) + 1, LEN(Title))
			WHEN Title LIKE '%Grand Sedona%' THEN SUBSTRING(Title, CHARINDEX(' ', Title, CHARINDEX(' ', Title, CHARINDEX(' ', Title) + 1) + 1) + 1, LEN(Title))
			WHEN Title LIKE '%Grand Cherokee%' THEN SUBSTRING(Title, CHARINDEX(' ', Title, CHARINDEX(' ', Title, CHARINDEX(' ', Title) + 1) + 1) + 1, LEN(Title))
			WHEN Title LIKE '%Grand Vitara%' THEN SUBSTRING(Title, CHARINDEX(' ', Title, CHARINDEX(' ', Title, CHARINDEX(' ', Title) + 1) + 1) + 1, LEN(Title))
		---------------------------------------------------------
		ELSE SUBSTRING(Title, CHARINDEX(' ', Title, CHARINDEX(' ', Title) + 1) + 1, LEN(Title))
		END;

