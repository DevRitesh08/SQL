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

-- Removing non-essential columns
SELECT * FROM electronics.laptopdata LIMIT 5;  -- checking existing columns
-- Dropping columns that are not needed for analysis like Unnamed: 0
ALTER TABLE electronics.laptopdata
DROP COLUMN `Unnamed: 0`;
-- Verifying the structure after dropping the column
SELECT * FROM electronics.laptopdata;

-- finding rows with NULL values in important columns
SELECT * FROM electronics.laptopdata
WHERE Company IS NULL AND TypeName IS NULL AND Inches IS NULL AND ScreenResolution IS NULL AND Cpu IS NULL AND Ram IS NULL AND Memory IS NULL AND Gpu IS NULL AND OpSys IS NULL AND Weight IS NULL AND Price IS NULL;

SELECT COUNT(*) FROM electronics.laptopdata;