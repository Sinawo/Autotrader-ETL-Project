CREATE PROCEDURE dbo.CreateDealerTables
AS
BEGIN
	TRUNCATE TABLE DeGenerics;

	INSERT INTO DeGenerics (dealer, [Location], Dealer_group)
	SELECT *
	FROM DimDeal_ALL;

	UPDATE DeGenerics
	SET brand = CarMake
	FROM dealers
	WHERE dealers.DealerName = DeGenerics.Dealer;

	UPDATE DeGenerics
	SET brand = upper('Variety')
	WHERE [brand] is null; 
END;

