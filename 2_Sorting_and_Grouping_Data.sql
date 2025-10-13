----
-- Sorting Data
----


-- Sort the results by price in ascending order
SELECT * FROM temp.smartphones ORDER BY price ASC;

-- Sort the results by price in descending order
SELECT * FROM temp.smartphones ORDER BY price DESC;

-- Sort the results by multiple columns
SELECT * FROM temp.smartphones ORDER BY brand_name ASC, price DESC;

--------------------------------------------------------------------------------------------------------------------------------------------------------------------

---
-- Questions on sorting data and filtering data
---

-- find top 5 samsung phones with Biggest screen size
SELECT * from temp.smartphones 
WHERE brand_name = 'Samsung' 
ORDER BY screen_size DESC
LIMIT 5;                        -- LIMIT is used to restrict the number of rows returned  

-- sort all the phone in desc number for number of cameras
SELECT model , (num_rear_cameras + num_front_cameras) AS number_of_cameras from temp.smartphones 
ORDER BY number_of_cameras DESC;

-- sort data on the basis of ppi in dec order .
SELECT model ,
ROUND(SQRT(resolution_width*resolution_width + resolution_height*resolution_height)/screen_size , 3) AS PPI
from temp.smartphones
ORDER BY PPI DESC;

-- find the phone with 2nd largest battery capacity
SELECT model , battery_capacity from temp.smartphones
ORDER BY battery_capacity DESC
LIMIT 1 OFFSET 1;  -- OFFSET is used to skip a specific number of rows before starting to return rows from the query .
-- Here we skip the first row (the phone with the largest battery capacity) and return the next row (the phone with the 2nd largest battery capacity).
 -- syntax : LIMIT <number_of_rows> OFFSET <number_of_rows_to_skip>
-- third largest battery capacity
SELECT model , battery_capacity from temp.smartphones
ORDER BY battery_capacity DESC
LIMIT 1 OFFSET 2;  -- skip first two rows and return the next row
-- fourth largest and fifth largest battery capacity
SELECT model , battery_capacity from temp.smartphones   
ORDER BY battery_capacity DESC
LIMIT 2 OFFSET 3;  -- skip first three rows and return the next two rows
-- offset can also be written as
    -- syntax : LIMIT <number_of_rows_to_skip> , <number_of_rows>
    --here the first number is the offset and the second number is the limit


-- find the name and rating of worst rated iphones
SELECT model , rating from temp.smartphones
WHERE brand_name = 'Apple'
ORDER BY rating ASC
LIMIT 1;

-- sort phones alphabetically and then on the basis of rating in desc order         
SELECT model , brand_name , rating from temp.smartphones
ORDER BY brand_name ASC , rating DESC;

-- sort phones on the basis of brand_name in asc order and then on the basis of price in desc order
SELECT model , price from temp.smartphones
ORDER BY brand_name ASC , price DESC;



--------------------------------------------------------------------------------------------------------------------------------------------------------------------



----
-- Grouping Data
----
-- categorical data is grouped together to form a summary , 
-- used with aggregate functions to group the result set by one or more columns 
-- Aggregate functions : COUNT , SUM , AVG , MIN , MAX


-- Count of phones by brand
SELECT brand_name , COUNT(*) AS number_of_phones from temp.smartphones
GROUP BY brand_name;

-- Group smartphones by brand and get the count , avg price and max rating , avg screen size and avg battery capacity
SELECT brand_name , count(*) as 'Num Phones', ROUND(AVG(price), 2) as 'Avg Price', MAX(rating) as 'Max Rating', ROUND(AVG(screen_size),2 ) as 'Avg Screen Size', ROUND(AVG(battery_capacity),2) as 'Avg Battery Capacity'
from temp.smartphones
GROUP BY brand_name;

--  group smartphones by whether they have an NFC and get the avg price and rating .
SELECT has_nfc as 'NFC', ROUND(AVG(price),2) as 'Avg Price', ROUND(AVG(rating),3) as 'Avg Rating' from temp.smartphones GROUP BY has_nfc;

--Average price of 5g phones and non 5g phones
SELECT has_5g as '5G' , ROUND(AVG(price),2) as average_price
FROM temp.smartphones
GROUP BY has_5g;

--group smartphones by whether they are 5g or not and get the avg price , rating and battery capacity.
SELECT has_5g as '5G', ROUND(AVG(price),2) as 'Avg Price', ROUND(AVG(rating),3) as 'Avg Rating', ROUND(AVG(battery_capacity),2) as 'Avg Battery Capacity' from temp.smartphones GROUP BY has_5g;



----
-- Group by on multiple columns
-- till now we have rows acc. to the grouped column like for has_nfc it has only 2 values either 0 or 1 so we got only 2 rows but ,
-- In case of multiple columns it will be their cartesian product ex for a group of has_5g and has_nfc we'll have 4 groups (2*2 = 4)


-- Group smartphones by the brand and processor brand and get the count of models and average primary camera resolution .
Select brand_name , processor_brand ,count(*) as models , ROUND(AVG(primary_camera_rear),3) as average_primary_camera_rear
FROM temp.smartphones
GROUP BY brand_name , processor_brand
ORDER BY brand_name ASC , processor_brand ASC;      -- ordering the result set by brand_name and processor_brand in ascending order

-- Find top 5 most costly phone brands
SELECT brand_name , ROUND(AVG(price),2) as average_price_of_brand
FROM  temp.smartphones
GROUP BY brand_name 
ORDER BY average_price_of_brand DESC
LIMIT 5;

-- Which brand make the smartphones wth the smallest screen 
SELECT brand_name , ROUND(AVG(screen_size),2) as average_screen_size
FROM temp.smartphones
GROUP BY brand_name
ORDER BY average_screen_size ASC
LIMIT 1;

-- Group smartphones by the brand , and find the brand with the highest number of models that have both NFC and an IR blaster.
SELECT brand_name , count(*) as no_oF_phones_with_both_ir_blaster_and_nfc
from temp.smartphones
WHERE has_nfc =  'True' and has_ir_blaster = 'True'
GROUP BY brand_name
ORDER BY no_oF_phones_with_both_ir_blaster_and_nfc DESC LIMIT 1 ;

-- Find all samsung 5g enabled smartphones and find out the average price for nfc and non-nfc phones  
SELECT has_nfc , ROUND(AVG(price),2) as average_price
FROM temp.smartphones
WHERE brand_name = 'Samsung' AND has_5g = 'True'
GROUP BY has_nfc;



--------------------------------------------------------------------------------------------------------------------------------------------------------------------


-----
--- Having Clause
-----
-- used to filter the results of a GROUP BY query based on a specified condition ==> SELECT KE LIYE JO KAAM WHERE KARTA HAI , WAHI KAAM HAVING KARTA HAI GROUP BY KE LIYE
-- similar to WHERE clause but WHERE is used to filter rows before grouping whereas HAVING is used to filter groups after grouping.
-- HAVING is used with aggregate functions to filter the results based on the aggregated values.
-- HAVING is used after GROUP BY clause only.
-- syntax : SELECT column1, column2, aggregate_function(column3)
--          FROM table_name
--          GROUP BY column1, column2
--          HAVING condition;


-- Find average price of phones by brand and filter the brands that has atleast 10 models
SELECT brand_name, COUNT(*) as model_count, ROUND(AVG(price), 2) as average_price
FROM temp.smartphones
GROUP BY brand_name
-- HAVING COUNT(*) >= 10
ORDER BY average_price DESC;


-- Find the average rating of smart phone brands which have more than 20 models
SELECT brand_name, COUNT(*) as model_count, ROUND(AVG(rating), 2) as average_rating
FROM temp.smartphones
GROUP BY brand_name
HAVING COUNT(*) > 20;

-- find the top 3 brands with the highest avg ram that have a refresh rate of atleast 90 hz and fast charging avilable and don't consider brands which have less than 10 models .
SELECT brand_name , COUNT(*) as model_count , ROUND(AVG(ram_capacity),1) as average_ram
FROM temp.smartphones
WHERE refresh_rate >= 90 and fast_charging_available = 1 
GROUP BY brand_name 
HAVING count(*) >= 10
ORDER BY average_ram DESC LIMIT 3 ;

-- find the avg price of all the phone brands with avg rating > 70  and num_phones > 10 among all 5g phones available . === > for aggregte operations we use having that are avg and count , and in where we have 5g enabled phones 
SELECT brand_name , ROUND(AVG(price),2) as average_price 
FROM temp.smartphones
WHERE has_5g = 'TRUE'
GROUP BY brand_name 
HAVING AVG(rating) > 70 and COUNT(*) > 10 ;


-----
--- Difference between WHERE and HAVING Clause
-- WHERE Clause is used to filter rows before grouping and HAVING Clause is used to filter groups after grouping
-- WHERE Clause cannot be used with aggregate functions and HAVING Clause is used with aggregate functions
-- Row me filtering ke liye WHERE Clause use hoga or Aggregate function ke basis pe filter karna ke liye HAVING clause use hoga
-----



---------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- find the to 5 batsman in ipl history with highest total runs scored and have played atleast 100 matches
SELECT batter , SUM(batsman_run) as runs
FROM temp.ipl_complete
GROUP BY batter
order by runs  DESC LIMIT 5 ;

-- find the 2nd highest six hitter in ipl history who have played atleast 50 matches
SELECT batter , COUNT(*) as num_sixes
FROM temp.ipl_complete
where batsman_run = 6
GROUP BY batter
HAVING COUNT(*) >= 50
ORDER BY num_sixes DESC LIMIT 1 OFFSET 1;

-- find virat kohli's runs against all ipl teams and sort the teams by the runs scored in desc order . (info not available in ipl_complete table bcoz. bowling team column is not present there so we use ipl_matches table to get the team names)


-- find the batsman who have scored more than 100 runs in a single match and sort them in desc order of runs scored
SELECT batter , ID , sum(batsman_run) as total_runs
FROM temp.ipl_complete
GROUP BY batter , ID
HAVING total_runs >= 100
ORDER BY total_runs DESC

-- find the top 5 batsman with highest strke rate who have faced atleast 1000 balls in ipl history
SELECT batter , SUM(batsman_run) as total_runs , COUNT(*) as num_balls , ROUND(SUM(batsman_run) * 100 / NULLIF(COUNT(*), 0), 2) as strike_rate      -- NULLIF is     used to avoid division by zero error
FROM temp.ipl_complete
GROUP BY batter
HAVING num_balls >= 1000
ORDER BY strike_rate DESC
LIMIT 5;