select * from Car_Listing_Table
select * from overnight_table
select * from dealer_table

Select * from Autotrader_Data
--- This is the Extracted dataset from Autotrader
select * into Autotrader_Data
from overnight_table
--- Clean the Title -- 
-- remove for sale
update Autotrader_Data
set Title = RTRIM(LTRIM(Replace(Title,'For Sale','')));
-- Remove the R in orice column
update Autotrader
set Price = Replace(Price,'R','');


