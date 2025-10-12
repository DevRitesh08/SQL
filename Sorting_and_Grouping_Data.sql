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

