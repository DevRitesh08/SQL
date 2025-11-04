-- Creating backup for laptopData table
SELECT * FROM electronics.laptopdata;
-- Creating a backup table
CREATE TABLE electronics.laptopdata_backup AS
SELECT * FROM electronics.laptopdata;

-- Alternative way to create backup table

-- CREATE TABLE electronics.laptopdata_backup LIKE electronics.laptopdata;      -- creates empty table with same structure
-- INSERT INTO electronics.laptopdata_backup SELECT * FROM electronics.laptopdata;   -- copies data into backup table


-- Checking memory usage for reference
SHOW TABLE STATUS FROM electronics LIKE 'laptopdata';       -- here Data_length shows the size of data in bytes
-- converting bytes to KB
SELECT Data_length/1024 AS Data_size_in_KB FROM information_schema.tables
WHERE table_schema = 'electronics' AND table_name = 'laptopdata';

-- Analysing the structure of laptopdata table
DESCRIBE electronics.laptopdata;


----
-- Removing non-essential columns
----

SELECT * FROM electronics.laptopdata LIMIT 5;  -- checking existing columns
-- Dropping columns that are not needed for analysis like Unnamed: 0
ALTER TABLE electronics.laptopdata
DROP COLUMN `Unnamed: 0`;   -- here  ` ` is used because 
-- Verifying the structure after dropping the column
SELECT * FROM electronics.laptopdata;

----
-- Handling missing values (Removing rows with all null values)
----

-- finding rows that has all null values
SELECT * FROM electronics.laptopdata
WHERE Company IS NULL AND TypeName IS NULL AND Inches IS NULL AND ScreenResolution IS NULL AND Cpu IS NULL AND Ram IS NULL AND Memory IS NULL AND Gpu IS NULL AND OpSys IS NULL AND Weight IS NULL AND Price IS NULL;

-- now deleting them 
DELETE FROM electronics.laptopdata
WHERE `index` IN (SELECT * FROM electronics.laptopdata
                    WHERE Company IS NULL AND TypeName IS NULL AND Inches IS NULL AND ScreenResolution IS NULL AND Cpu IS NULL AND Ram IS NULL AND Memory IS NULL AND Gpu IS NULL AND OpSys IS NULL AND Weight IS NULL AND Price IS NULL
                    );


----
-- Removing duplicate rows
----

-- Dropping the duplicate rows (this data has no duplicates so lets practise on duplicates table of temp database that has duplicates)

-- to find duplicates we can use :
-- GROUP BY

-- Add id column to duplicates table
-- ALTER TABLE temp.duplicates
-- ADD COLUMN id INT AUTO_INCREMENT UNIQUE FIRST; -- use of FIRST to add column at the beginning

-- Finding duplicate rows based on all columns except id
SELECT name , gender , age , count(*) FROM temp.duplicates
GROUP BY name, gender, age
HAVING count(*) > 1;
-- Deleting duplicate rows keeping one copy
DELETE FROM temp.duplicates
WHERE id NOT IN (
    SELECT * FROM (
        SELECT MIN(id) FROM temp.duplicates     -- MIN(id) will keep the first occurrence
        GROUP BY name, gender, age
    ) AS subquery
);
-- Verifying duplicates are removed
SELECT name , gender , age , count(*) FROM temp.duplicates
GROUP BY name, gender, age;

-- other methods are also possible like using joins , window functions etc.


----
-- Column Analysis and Cleaning
----

-- using Distinct to find unique values in all columns since it also helps in finding null values
SELECT DISTINCT * FROM electronics.laptopdata;

---- 
-- Data type conversions
----


SELECT * FROM electronics.laptopdata LIMIT 5;  -- checking existing data types

-- Checking current data types
DESCRIBE electronics.laptopdata;


-- Converting 'Inches' from VARCHAR to FLOAT
ALTER TABLE electronics.laptopdata
MODIFY COLUMN Inches DECIMAL(4,2);  -- 4 total digits , 2 after decimal

--Ramoving 'GB' from 'Ram' and converting it to INT
UPDATE electronics.laptopdata
SET Ram = REPLACE(Ram, 'GB', '');
-- alternate way using correlated subquery
-- UPDATE electronics.laptopdata AS l1
-- SET Ram = (SELECT REPLACE(Ram, 'GB', '') FROM electronics.laptopdata l2 WHERE l2.`index` = l1.`index`);

-- Changing data type of Ram to INT
ALTER TABLE electronics.laptopdata
MODIFY COLUMN Ram INT;


-- Converting 'Weight' from VARCHAR to FLOAT
UPDATE electronics.laptopdata
SET Weight = REPLACE(Weight, 'kg', '');
-- alternate way using correlated subquery
-- UPDATE electronics.laptopdata AS l1
-- SET Weight = (SELECT REPLACE(Weight, 'kg', '') FROM electronics.laptopdata l2 WHERE l2.`index` = l1.`index`);


-- Handle empty strings - convert them to NULL before changing data type
UPDATE electronics.laptopdata
SET Weight = NULL
WHERE Weight = '' OR Weight IS NULL;

-- Changing data type of Weight to DECIMAL
ALTER TABLE electronics.laptopdata
MODIFY COLUMN Weight DECIMAL(4,2);  -- 4 total digits , 2 after decimal


-- Below is an extended version to handle more complex scenarios like invalid numeric values
-- ----

-- -- First, let's see what values are causing the issue
-- SELECT DISTINCT Weight FROM electronics.laptopdata 
-- WHERE Weight NOT REGEXP '^[0-9]+(\\.[0-9]+)?$' AND Weight IS NOT NULL AND Weight != '';

-- -- Converting 'Weight' from VARCHAR to FLOAT
-- UPDATE electronics.laptopdata
-- SET Weight = REPLACE(Weight, 'kg', '');

-- -- Handle empty strings AND invalid numeric values - convert them to NULL
-- UPDATE electronics.laptopdata
-- SET Weight = NULL
-- WHERE Weight = '' 
--    OR Weight IS NULL 
--    OR TRIM(Weight) = ''
--    OR Weight NOT REGEXP '^[0-9]+(\\.[0-9]+)?$';  -- Keep only valid decimal numbers

-- -- Now change data type to DECIMAL
-- ALTER TABLE electronics.laptopdata
-- MODIFY COLUMN Weight DECIMAL(4,2);  -- 4 total digits , 2 after decimal


-- reviewing the changes
DESCRIBE electronics.laptopdata;

-- Converting 'Price' from DOUBLE to INT after rounding off the values
UPDATE electronics.laptopdata
SET Price = ROUND(Price);
ALTER TABLE electronics.laptopdata
MODIFY COLUMN Price INT;
-- using correlated subquery
-- UPDATE electronics.laptopdata AS l1
-- SET Price = (SELECT ROUND(Price) FROM electronics.laptopdata l2 WHERE l2.`index` = l1.`index`);


