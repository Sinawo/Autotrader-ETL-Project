/****** Object:  StoredProcedure [dbo].[CreateDimVehicle]    Script Date: 26/06/2023 09:01:37 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [dbo].[CreateDimVehicle]
AS
BEGIN
    -- Create the Dim_Vehicle table if it doesn't exist
    IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'Dim_Vehicle')
    BEGIN
        CREATE TABLE Dim_Vehicle (
			ID INT IDENTITY(1, 1) PRIMARY KEY,
		    Vehicle_ID AS 'V-' + RIGHT('000000' + CAST(ID AS NVARCHAR(6)), 6),
            Make VARCHAR(50),
            Model VARCHAR(50),
            Variant VARCHAR(50)
        );
    END;
    -- Insert distinct records from Flat_Updated into Dim_Vehicle
    INSERT INTO Dim_Vehicle (Make, Model, Variant)
    SELECT DISTINCT Make, Model, Variant
    FROM Flat_Updated_table; 
END;
