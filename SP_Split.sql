CREATE PROCEDURE dbo.SplitDealers_SP
AS
BEGIN
	TRUNCATE TABLE DealersNLocations;
	TRUNCATE table DimDeal_All;
	
	INSERT INTO DealersNLocations
	SELECT [dealer], [Location]
	FROM Recent_dealers;

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

		WHEN dealer LIKE '%DIRK ELLIS%' THEN 
		UPPER(SUBSTRING(dealer, 1, CHARINDEX(' ', dealer, CHARINDEX(' ', dealer) + 1)))

		WHEN dealer LIKE '%AUDI CENTRE%' THEN 
		UPPER(SUBSTRING(dealer, 1, CHARINDEX(' ', dealer, CHARINDEX(' ', dealer) + 1)))
		
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
		
		ELSE NULL
	END AS Dealer_Group 
	FROM DealersNLocations;

			-- Update Dealers --
	UPDATE DimDeal_ALL
	set Dealer_Group = upper(CarMake) + ' GROUP'
	from dealers
	where dealers.DealerName = DimDeal_ALL.Dealer
	AND
	[Dealer_Group] is null;

	UPDATE DimDeal_ALL
	SET Dealer_Group = upper('Generic group')
	where [Dealer_Group] is null;

END;

