--STEP 1: From the uncleaned table which is overnight_table lets take the new dataset and insert it to the Autotrader_sp
INSERT INTO Autotrader_sp (Car_ID, Title, Price, [Car Type], [Registration Year], Mileage, Transmission, [Fuel Type], Dealership, Suburb, [Introduction date], [End date], [Engine position], [Engine detail], [Engine capacity (litre)], [Cylinder layout and quantity], [Fuel capacity], [Fuel consumption (average) **], [Fuel range (average)], [Power maximum (detail)], [Torque maximum], [Maximum/top speed], [CO2 emissions (average)], [Acceleration 0-100 km/h], [Last Updated], [Previous Owners], [Service History], [Colour], [Body Type])
SELECT Car_ID, Title, Price, [Car Type], [Registration Year], Mileage, Transmission, [Fuel Type], Dealership, Suburb, [Introduction date], [End date], [Engine position], [Engine detail], [Engine capacity (litre)], [Cylinder layout and quantity], [Fuel capacity], [Fuel consumption (average) **], [Fuel range (average)], [Power maximum (detail)], [Torque maximum], [Maximum/top speed], [CO2 emissions (average)], [Acceleration 0-100 km/h], [Last Updated], [Previous Owners], [Service History], [Colour], [Body Type]
FROM overnight_table
WHERE Car_ID NOT IN (SELECT Car_ID FROM Autotrader_sp);

--STEP 2: Clean the data from the Autotrader_sp



