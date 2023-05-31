-- Procedure creates DimDealerGropus & DimGenericDealers tables
CREATE PROCEDURE dbo.SplitDealers_SP
AS
BEGIN
    -- Code for the stored procedure goes here
	SELECT [region], [dealer], [Location]
	INTO DealersNLocations
	FROM Recent_dealers;
	alter table DealersNLocations add Dealer_Group varchar(20);
	alter table DealersNLocations add Brand varchar(20);

-- Splitting Dealers --
UPDATE [dbo].[DealersNLocations]
SET Dealer_Group = UPPER(SUBSTRING(dealer,1,charIndex(' ', dealer)))
WHERE dealer LIKE '%DALY%'

 
UPDATE [dbo].[DealersNLocations]
SET Dealer_Group = UPPER(SUBSTRING(dealer,1,charIndex(' ', dealer)))
WHERE dealer LIKE '%ORANJE%'

 

UPDATE [dbo].[DealersNLocations]
SET Dealer_Group = UPPER(SUBSTRING(dealer,1,charIndex(' ', dealer)))
WHERE dealer LIKE '%LEON%'

 

UPDATE [dbo].[DealersNLocations]
SET Dealer_Group = UPPER(SUBSTRING(dealer,1,charIndex(' ', dealer)))
WHERE dealer LIKE '%EASTVAAL%'

 

UPDATE [dbo].[DealersNLocations]
SET Dealer_Group = UPPER(SUBSTRING(dealer,1,charIndex(' ', dealer)))
WHERE dealer LIKE '%ACTION%'

 

UPDATE [dbo].[DealersNLocations]
SET Dealer_Group = UPPER(SUBSTRING(dealer,1,charIndex(' ', dealer)))
WHERE dealer LIKE '%WESTVAAL%'

 

UPDATE [dbo].[DealersNLocations]
SET Dealer_Group = UPPER(SUBSTRING(dealer,1,charIndex(' ', dealer)))
WHERE dealer LIKE '%MORGAN%'

 

UPDATE [dbo].[DealersNLocations]
SET Dealer_Group = UPPER(SUBSTRING(dealer,1,charIndex(' ', dealer)))
WHERE dealer LIKE '%TAVCOR%'

 

UPDATE [dbo].[DealersNLocations]
SET Dealer_Group = UPPER(SUBSTRING(dealer,1,charIndex(' ', dealer)))
WHERE dealer LIKE '%KOUGA%'

 

UPDATE [dbo].[DealersNLocations]
SET Dealer_Group = UPPER(SUBSTRING(dealer,1,charIndex(' ', dealer)))
WHERE dealer LIKE '%NMG%'

 

UPDATE [dbo].[DealersNLocations]
SET Dealer_Group = UPPER(SUBSTRING(dealer,1,charIndex(' ', dealer)))
WHERE dealer LIKE '%NMI%'

 

UPDATE [dbo].[DealersNLocations]
SET Dealer_Group = UPPER(SUBSTRING(dealer,1,charIndex(' ', dealer)))
WHERE dealer LIKE '%PROTEA%'

 

UPDATE [dbo].[DealersNLocations]
SET Dealer_Group = UPPER(SUBSTRING(dealer,1,charIndex(' ', dealer)))
WHERE dealer LIKE '%ROLA%'

 

UPDATE [dbo].[DealersNLocations]
SET Dealer_Group = UPPER(SUBSTRING(dealer,1,charIndex(' ', dealer)))
WHERE dealer LIKE '%DONFORD%'

 

UPDATE [dbo].[DealersNLocations]
SET Dealer_Group = UPPER(SUBSTRING(dealer,1,charIndex(' ', dealer)))
WHERE dealer LIKE '%PENTA%'

 

UPDATE [dbo].[DealersNLocations]
SET Dealer_Group = UPPER(SUBSTRING(dealer,1,charIndex(' ', dealer)))
WHERE dealer LIKE '%PRODUKTA%'

 

UPDATE [dbo].[DealersNLocations]
SET Dealer_Group = UPPER(SUBSTRING(dealer,1,charIndex(' ', dealer)))
WHERE dealer LIKE '%ALGOA%'

 

UPDATE [dbo].[DealersNLocations]
SET Dealer_Group = UPPER(SUBSTRING(dealer,1,charIndex(' ', dealer)))
WHERE dealer LIKE '%TWK%'

 

UPDATE [dbo].[DealersNLocations]
SET Dealer_Group = UPPER(SUBSTRING(dealer,1,charIndex(' ', dealer)))
WHERE dealer LIKE '%BUFFALO TO%'

 

UPDATE [dbo].[DealersNLocations]
SET Dealer_Group = REPLACE(Dealer_Group, 'HEYHALFWAY', 'HALFWAY');

 

UPDATE [dbo].[DealersNLocations]
SET Dealer_Group = UPPER(SUBSTRING(dealer,1,charIndex(' ', dealer)))
WHERE dealer LIKE '%KAROO%'

 

UPDATE [dbo].[DealersNLocations]
SET Dealer_Group = UPPER(SUBSTRING(dealer,1,charIndex(' ', dealer)))
WHERE dealer LIKE '%MEKOR%'

 

UPDATE [dbo].[DealersNLocations]
SET Dealer_Group = UPPER(SUBSTRING(dealer,1,charIndex(' ', dealer)))
WHERE dealer LIKE '%CMH%'

 

UPDATE [dbo].[DealersNLocations]
SET Dealer_Group = UPPER(SUBSTRING(dealer,1,charIndex(' ', dealer)))
WHERE dealer LIKE '%BB%'

 

UPDATE [dbo].[DealersNLocations]
SET Dealer_Group = UPPER(SUBSTRING(dealer,1,charIndex(' ', dealer)))
WHERE dealer LIKE 'MCCARTHY%'

 
UPDATE [dbo].[DealersNLocations]
SET Dealer_Group = UPPER(SUBSTRING(dealer,1,charIndex(' ', dealer)))
WHERE dealer LIKE '%MARKET TOYOTA%'
 

UPDATE [dbo].[DealersNLocations]
SET Dealer_Group = UPPER(SUBSTRING(dealer, 1, CHARINDEX(' ', dealer, CHARINDEX(' ', dealer) + 1)))
WHERE dealer LIKE '%AUTO INVESTMENTS%';

 

UPDATE [dbo].[DealersNLocations]
SET Dealer_Group = UPPER(SUBSTRING(dealer, 1, CHARINDEX(' ', dealer, CHARINDEX(' ', dealer) + 1)))
WHERE dealer LIKE '%RONNIES MOTORS%';

 

UPDATE [dbo].[DealersNLocations]
SET Dealer_Group = UPPER(SUBSTRING(dealer, 1, CHARINDEX(' ', dealer, CHARINDEX(' ', dealer) + 1)))
WHERE dealer LIKE '%AUTO BALTIC%';

 

UPDATE [dbo].[DealersNLocations]
SET Dealer_Group = UPPER(SUBSTRING(dealer, 1, CHARINDEX(' ', dealer, CHARINDEX(' ', dealer) + 1)))
WHERE dealer LIKE '%DIRK ELLIS%';

 

UPDATE [dbo].[DealersNLocations]
SET Dealer_Group = UPPER(SUBSTRING(dealer, 1, CHARINDEX(' ', dealer, CHARINDEX(' ', dealer) + 1)))
WHERE dealer LIKE '%AUDI CENTRE%';

 

UPDATE [dbo].[DealersNLocations]
SET Dealer_Group = UPPER(SUBSTRING(dealer, 1, CHARINDEX(' ', dealer, CHARINDEX(' ', dealer) + 1)))
WHERE dealer LIKE '%PORSCHE CENTRE%';

 

UPDATE [dbo].[DealersNLocations]
SET Dealer_Group = UPPER(SUBSTRING(dealer, 1, CHARINDEX(' ', dealer, CHARINDEX(' ', dealer) + 1)))
WHERE dealer LIKE '%BIDVEST MCCARTHY%';

 

UPDATE [dbo].[DealersNLocations]
SET Dealer_Group = UPPER(SUBSTRING(dealer, 1, CHARINDEX(' ', dealer, CHARINDEX(' ', dealer) + 1)))
WHERE dealer LIKE '%BIDVEST  MCCARTHY%';


UPDATE [dbo].[DealersNLocations]
SET Dealer_Group = UPPER(SUBSTRING(dealer, 1, CHARINDEX(' ', dealer, CHARINDEX(' ', dealer) + 1)))
WHERE dealer LIKE '%GROUP 1%';

 

UPDATE [dbo].[DealersNLocations]
SET Dealer_Group = UPPER(SUBSTRING(dealer,1,charIndex(' ', dealer)))
WHERE dealer LIKE '%INTERTOY%';


update DealersNLocations
set Dealer_Group = CarMake
from dealers
where dealers.DealerName = DealersNLocations.Dealer
AND
[Dealer_Group] is null;

update DealersNLocations
set Brand = CarMake
from dealers
where dealers.DealerName = DealersNLocations.Dealer;

update DealersNLocations
set Brand = 'Volkswagen'
where Brand LIKE '%VW%';

-- DimDealerGs & DimGeneric Table
Create table DimDealerGs(
    D_Id int primary key identity (1,1),
    Dealer_Region varchar(20),
    Dealer_location varchar(40),
    Deal_Group varchar(20),
    Deal_Brand varchar(20)
);
INSERT Into DimDealerGs(Dealer_Region, Dealer_location, Deal_Group, Deal_Brand)
SELECT region, [Location], Dealer_Group, Brand 
FROM DealersNLocations
WHERE DealersNLocations.Dealer_Group <> 'null';

UPDATE DimDealerGs
SET Deal_Brand = 'Variety'
WHERE [Deal_Brand] is null; 

Create table DimGeneric(
    Gene_Id int primary key identity (1,1),
    Dealer varchar(50),
    Region varchar(20),
    [Dealer_Location] varchar(40)
);

INSERT Into DimGeneric(Dealer, Region, Dealer_Location)
SELECT dealer, region, [Location]
FROM DealersNLocations
WHERE [Dealer_Group] is null;

-- Table Creation Done --
END;

 

EXEC dbo.SplitDealers_SP;