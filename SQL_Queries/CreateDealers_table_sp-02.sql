/****** Object:  StoredProcedure [dbo].[CreateDealerTables]    Script Date: 26/06/2023 08:59:55 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[CreateDealerTables]
AS
BEGIN
	TRUNCATE TABLE DeGenerics;

	INSERT INTO DeGenerics (dealer, [Location], Dealer_group)
	SELECT *
	FROM DimDeal_ALL
	where DimDeal_ALL.dealer NOT like '%new'
	AND 
	DimDeal_ALL.dealer NOT LIKE '%new car%';

	UPDATE DeGenerics
	SET brand = upper(CarMake)
	FROM dealers
	WHERE dealers.DealerName = DeGenerics.Dealer;

	UPDATE DeGenerics
	SET brand = upper('Variety')
	WHERE [brand] is null; 
END;

