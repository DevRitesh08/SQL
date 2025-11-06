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


-- we'll create a new column from the existing column 'OpSys' to standardize the operating system names like windows , macOS , Linux , No OS and Others(android , Chrome OS etc.)
SELECT Opsys from electronics.laptopdata GROUP BY Opsys;  -- checking existing values
ALTER TABLE electronics.laptopdata
ADD COLUMN OpSys_Standardized VARCHAR(50);

UPDATE electronics.laptopdata
SET OpSys_Standardized = CASE       -- can also do implace update without creating new column like SET OpSys = CASE ...
    WHEN OpSys LIKE '%Windows%' THEN 'Windows'
    WHEN OpSys LIKE '%mac%' OR OpSys LIKE '%Mac%' THEN 'macOS'
    WHEN OpSys LIKE '%Linux%' THEN 'Linux'
    WHEN OpSys IS NULL OR OpSys = '' OR OpSys = 'No OS' THEN 'N/A'
    ELSE 'Others'
END;

-- Drop the old OpSys column if not needed
ALTER TABLE electronics.laptopdata
DROP COLUMN OpSys;

-- verifying the changes
SELECT * FROM electronics.laptopdata ;


-- Now lets  break Gpu column into GPU Brand and GPU Model for better analysis
SELECT Gpu FROM electronics.laptopdata GROUP BY Gpu;  -- checking existing values

-- Adding new columns
ALTER TABLE electronics.laptopdata
ADD COLUMN Gpu_Brand VARCHAR(100) AFTER Gpu,
ADD COLUMN Gpu_Model VARCHAR(100) AFTER Gpu_Brand;

-- Updating new columns by splitting Gpu column
UPDATE electronics.laptopdata
SET Gpu_Brand = SUBSTRING_INDEX(Gpu, ' ', 1),   -- gets the first word
    Gpu_Model = REPLACE(Gpu, SUBSTRING_INDEX(Gpu, ' ', 1) , '');  -- removes the first word to get the model ==> or just use REPLACE(Gpu, Gpu_Brand, '') ,but this way is better to avoid issues with similar names like 'Intel Intel UHD Graphics';

-- alternatively using correlated subquery
-- UPDATE electronics.laptopdata AS l1
-- SET Gpu_Brand = (SELECT SUBSTRING_INDEX(Gpu, ' ', 1) FROM electronics.laptopdata l2 WHERE l2.`index` = l1.`index`),
--     Gpu_Model = (SELECT REPLACE(Gpu, SUBSTRING_INDEX(Gpu, ' ', 1) , '') FROM electronics.laptopdata l2 WHERE l2.`index` = l1.`index`);

-- Dropping the old Gpu column if not needed
ALTER TABLE electronics.laptopdata
DROP COLUMN Gpu;

-- verifying the changes
SELECT * FROM electronics.laptopdata ;


-- now creating three new columns from cpu column : CPU_Brand , CPU_Name , CPU_Speed
SELECT CPU FROM electronics.laptopdata GROUP BY CPU;  -- checking existing values
ALTER TABLE electronics.laptopdata
ADD COLUMN CPU_Brand VARCHAR(100) AFTER CPU,
ADD COLUMN CPU_Name VARCHAR(100) AFTER CPU_Brand,
ADD COLUMN `CPU_Speed(in GHz)` DECIMAL(5,2) AFTER CPU_Name;

-- Updating new columns by splitting Cpu column using correlated subquery
UPDATE electronics.laptopdata AS l1
SET CPU_Brand = (SELECT SUBSTRING_INDEX(CPU,' ',1) 
				 FROM electronics.laptopdata l2 WHERE l2.index = l1.index);

UPDATE electronics.laptopdata AS l1
SET `CPU_Speed(in GHz)` = (SELECT CAST(REPLACE(SUBSTRING_INDEX(CPU,' ',-1),'GHz','')
				AS DECIMAL(10,2)) FROM electronics.laptopdata l2 
                WHERE l2.index = l1.index);

UPDATE electronics.laptopdata AS l1
SET CPU_Name = (SELECT
					REPLACE(REPLACE(CPU,CPU_Brand,''),SUBSTRING_INDEX(REPLACE(CPU,CPU_Brand,''),' ',-1),'')
					FROM electronics.laptopdata l2 
					WHERE l2.index = l1.index);

-- using single update with correlated subquery
-- UPDATE electronics.laptopdata AS l1
-- SET CPU_Brand = (SELECT SUBSTRING_INDEX(CPU,' ',1) 
-- 				 FROM electronics.laptopdata l2 WHERE l2.index = l1.index),
--     `CPU_Speed(in GHz)` = (SELECT CAST(REPLACE(SUBSTRING_INDEX(CPU,' ',-1),'GHz','')
-- 				AS DECIMAL(10,2)) FROM electronics.laptopdata l2
--                 WHERE l2.index = l1.index),
--     CPU_Name = (SELECT REPLACE(REPLACE(CPU,CPU_Brand,''),SUBSTRING_INDEX(REPLACE(CPU,CPU_Brand,''),' ',-1),'')
-- 					FROM electronics.laptopdata l2 WHERE l2.index = l1.index);


-- using substring and string functions without correlated subquery
UPDATE electronics.laptopdata
SET CPU_Brand = SUBSTRING_INDEX(CPU,' ',1),
    `CPU_Speed(in GHz)` = CAST(REPLACE(SUBSTRING_INDEX(CPU,' ',-1),'GHz','') AS DECIMAL(10,2)),
    CPU_Name = REPLACE(REPLACE(CPU,CPU_Brand,''),SUBSTRING_INDEX(REPLACE(CPU,CPU_Brand,''),' ',-1),'');

-- Dropping the old Cpu column if not needed
ALTER TABLE electronics.laptopdata
DROP COLUMN CPU;

-- reviewing the changes
SELECT * FROM electronics.laptopdata ;


-- Now lets  break the screenresolution column into 

SELECT ScreenResolution FROM electronics.laptopdata;

-- now lets extract screen resolution width and height
SELECT ScreenResolution ,
        SUBSTRING_INDEX(SUBSTRING_INDEX(ScreenResolution , " ", -1) , 'x' , 1),
        SUBSTRING_INDEX(SUBSTRING_INDEX(ScreenResolution , " " , -1) , 'x' , -1)
FROM electronics.laptopdata ;


Alter TABLE electronics.laptopdata
ADD COLUMN `Resolution_Width` INTEGER after ScreenResolution ,
ADD COLUMN `Resolution_Height` INTEGER after Resolution_Width ,
ADD COLUMN `Touchscreen_or_Not` BOOLEAN after Resolution_Height ;

-- reviewing the changes 
SELECT * FROM electronics.laptopdata ;

UPDATE electronics.laptopdata
SET `Resolution_Width` = SUBSTRING_INDEX(SUBSTRING_INDEX(ScreenResolution , " ", -1) , 'x' , 1),
    `Resolution_Height` = SUBSTRING_INDEX(SUBSTRING_INDEX(ScreenResolution , " ", -1) , 'x' , -1),
    `Touchscreen_or_Not` = ScreenResolution LIKE '%Touch%' ;

-- Dropping the ScreenResolution column if not needed
ALTER TABLE electronics.laptopdata
DROP COLUMN ScreenResolution;

-- further cleaning of cpu_name column 
SELECT CPU_Name FROM electronics.laptopdata ; -- for now it has many sub- categories in i3,i5 and so on

SELECT CPU_Name , SUBSTRING_INDEX(TRIM(CPU_Name) , " " , 2)
FROM electronics.laptopdata;
