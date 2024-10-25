/****** Object:  StoredProcedure [dbo].[SplitDealers_SP]    Script Date: 26/06/2023 09:02:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[SplitDealers_SP]
AS
BEGIN
	TRUNCATE TABLE DealersNLocations;
	TRUNCATE table DimDeal_All;
	TRUNCATE TABLE All_Autotrader_Dealers;
	
	INSERT INTO All_Autotrader_Dealers
	SELECT Distinct [Dealership], [Suburb]
	FROM Autotrader_dataset;
	
	INSERT INTO DealersNLocations
	SELECT Distinct [Dealership], [Suburb]
	FROM Autotrader_dataset;

			-- Splitting Dealers --
	INSERT INTO DimDeal_ALL
	SELECT * , 
	CASE 
		WHEN dealer LIKE '%AUTO INVESTMENTS%' THEN  
		UPPER(SUBSTRING(dealer, 1, CHARINDEX(' ', dealer, CHARINDEX(' ', dealer) + 1)))
	
		WHEN dealer LIKE '%RONNIES MOTORS%' THEN  
		UPPER(SUBSTRING(dealer, 1, CHARINDEX(' ', dealer, CHARINDEX(' ', dealer) + 1)))
		
		WHEN dealer LIKE '%DALY%' THEN 
		UPPER(SUBSTRING(dealer,1,charIndex(' ', dealer)))

		WHEN dealer LIKE '%ORANJE%' THEN 
		UPPER(SUBSTRING(dealer,1,charIndex(' ', dealer)))

		WHEN dealer LIKE '%Autocity%' THEN 
		UPPER(SUBSTRING(dealer,1,charIndex(' ', dealer)))

		WHEN dealer LIKE '%Barons%' THEN 
		UPPER(SUBSTRING(dealer,1,charIndex(' ', dealer)))

		WHEN dealer LIKE '%Avis%' THEN 
		UPPER(SUBSTRING(dealer,1,charIndex(' ', dealer)))
 
		WHEN dealer LIKE '%LEON%'THEN  
		UPPER(SUBSTRING(dealer,1,charIndex(' ', dealer)))

		WHEN dealer  LIKE '%EASTVAAL%' THEN 
		UPPER(SUBSTRING(dealer,1,charIndex(' ', dealer)))
		
		WHEN dealer LIKE '%ACTION%' THEN 
		UPPER(SUBSTRING(dealer,1,charIndex(' ', dealer)))

		WHEN dealer LIKE '%WESTVAAL%'  THEN 
		UPPER(SUBSTRING(dealer,1,charIndex(' ', dealer)))

		WHEN dealer LIKE '%MORGAN%' THEN 
		UPPER(SUBSTRING(dealer,1,charIndex(' ', dealer)))
 
		WHEN dealer LIKE '%TAVCOR%' THEN 
		UPPER(SUBSTRING(dealer,1,charIndex(' ', dealer)))

		WHEN dealer LIKE '%KOUGA%' THEN 
		UPPER(SUBSTRING(dealer,1,charIndex(' ', dealer)))

		WHEN dealer LIKE '%NMG%'THEN 
		UPPER(SUBSTRING(dealer,1,charIndex(' ', dealer)))
		
		WHEN dealer LIKE '%NMI%' THEN 
		UPPER(SUBSTRING(dealer,1,charIndex(' ', dealer)))
		
		WHEN dealer LIKE '%PROTEA%' THEN 
		UPPER(SUBSTRING(dealer,1,charIndex(' ', dealer)))

		WHEN dealer LIKE '%ROLA%'THEN 
		UPPER(SUBSTRING(dealer,1,charIndex(' ', dealer)))

		WHEN dealer LIKE '%DONFORD%'THEN 
		UPPER(SUBSTRING(dealer,1,charIndex(' ', dealer)))

		WHEN dealer LIKE '%PENTA%'THEN 
		UPPER(SUBSTRING(dealer,1,charIndex(' ', dealer)))

		WHEN dealer LIKE '%PRODUKTA%' THEN 
		UPPER(SUBSTRING(dealer,1,charIndex(' ', dealer)))

		WHEN dealer LIKE '%ALGOA%' THEN 
		UPPER(SUBSTRING(dealer,1,charIndex(' ', dealer)))

		WHEN dealer LIKE '%TWK%' THEN 
		UPPER(SUBSTRING(dealer,1,charIndex(' ', dealer)))

		WHEN dealer LIKE '%BUFFALO TO%'THEN 
		UPPER(SUBSTRING(dealer,1,charIndex(' ', dealer)))

		WHEN dealer LIKE '%KAROO%'THEN 
		UPPER(SUBSTRING(dealer,1,charIndex(' ', dealer)))

		WHEN dealer LIKE '%MEKOR%'THEN 
		UPPER(SUBSTRING(dealer,1,charIndex(' ', dealer)))
		
		WHEN dealer LIKE '%CMH%'THEN 
		UPPER(SUBSTRING(dealer,1,charIndex(' ', dealer)))

		WHEN dealer LIKE '%BB%'THEN 
		UPPER(SUBSTRING(dealer,1,charIndex(' ', dealer)))

		WHEN dealer LIKE 'MCCARTHY%'THEN 
		UPPER(SUBSTRING(dealer,1,charIndex(' ', dealer)))

		WHEN dealer LIKE '%MARKET TOYOTA%'THEN 
		UPPER(SUBSTRING(dealer,1,charIndex(' ', dealer)))

		WHEN dealer LIKE '%AUTO INVESTMENTS%'THEN 
		UPPER(SUBSTRING(dealer, 1, CHARINDEX(' ', dealer, CHARINDEX(' ', dealer) + 1)))

		WHEN dealer LIKE '%AUTO BALTIC%'THEN 
		UPPER(SUBSTRING(dealer, 1, CHARINDEX(' ', dealer, CHARINDEX(' ', dealer) + 1)))

		WHEN dealer LIKE '%AUTO Alpina%'THEN 
		UPPER(SUBSTRING(dealer, 1, CHARINDEX(' ', dealer, CHARINDEX(' ', dealer) + 1)))

		WHEN dealer LIKE '%DIRK ELLIS%' THEN 
		UPPER(SUBSTRING(dealer, 1, CHARINDEX(' ', dealer, CHARINDEX(' ', dealer) + 1)))

		WHEN dealer LIKE 'audi centre%' THEN 
		upper('audi centre')
		
		WHEN dealer LIKE '%PORSCHE CENTRE%'THEN 
		UPPER(SUBSTRING(dealer, 1, CHARINDEX(' ', dealer, CHARINDEX(' ', dealer) + 1)))

		WHEN dealer LIKE '%BIDVEST%' THEN 
		'BIDVEST MCCARTHY'

		WHEN dealer LIKE '%GROUP 1%'THEN 
		UPPER(SUBSTRING(dealer, 1, CHARINDEX(' ', dealer, CHARINDEX(' ', dealer) + 1)))

		WHEN dealer LIKE '%INTERTOY%' THEN 
		UPPER(SUBSTRING(dealer,1,charIndex(' ', dealer)))

		WHEN dealer LIKE '%Halfway%'THEN 
		upper('Halfway')			
		
		ELSE null
	END AS Dealer_Group 
	FROM DealersNLocations;

			-- Update Dealers --
	UPDATE dealers
	SET CarMake = 'Volkswagen'
	where CarMake like '%vw%';

	UPDATE dealers
	SET CarMake = 'Mercedes-Benz'
	where DealerName like '%mercedes%';

	UPDATE DimDeal_ALL
	set [Dealer_Group] = upper(CarMake) + ' GROUP'
	from dealers
	where dealers.DealerName = DimDeal_ALL.dealer
	AND
	[Dealer_Group] is null;

	UPDATE DimDeal_ALL
	SET Dealer_Group = upper('Generic group')
	where [Dealer_Group] is null;
	

END;


