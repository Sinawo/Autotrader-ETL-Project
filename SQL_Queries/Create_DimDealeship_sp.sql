/****** Object:  StoredProcedure [dbo].[Update_DimDealerships]    Script Date: 26/06/2023 09:03:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [dbo].[Update_DimDealerships]
AS
BEGIN
	IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'Dim_Dealership')
    BEGIN
	CREATE TABLE Dim_Dealership (
	ID INT IDENTITY(1, 1) PRIMARY KEY,
	Dealer_ID AS 'DEAL-' + RIGHT('000000' + CAST(ID AS NVARCHAR(6)), 6),
	Dealer_Name VARCHAR(50),
	[Location] VARCHAR(50),
	Dealership_Group VARCHAR(50),
	Brand VARCHAR(50)
	);
	END;


	INSERT INTO Dim_Dealership (Dealer_Name, [Location], Dealership_Group, Brand)
	SELECT DISTINCT dealer, Location, Dealer_Group, brand 
	from DeGenerics
	where NOT EXISTS(
		SELECT 1
		FROM Dim_Dealership
		WHERE Dim_Dealership.Dealer_Name = DeGenerics.dealer AND Dim_Dealership.Location = DeGenerics.Location  AND Dim_Dealership.Dealership_Group = DeGenerics.Dealer_Group AND DeGenerics.brand = Dim_Dealership.Brand
)
END;
