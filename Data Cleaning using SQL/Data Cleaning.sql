-- Creating backup for laptopData table
SELECT * FROM electronics.laptopdata;
-- Creating a backup table
CREATE TABLE electronics.laptopdata_backup AS
SELECT * FROM electronics.laptopdata;

-- Alternative way to create backup table

-- CREATE TABLE electronics.laptopdata_backup LIKE electronics.laptopdata;      -- creates empty table with same structure
-- INSERT INTO electronics.laptopdata_backup SELECT * FROM electronics.laptopdata;   -- copies data into backup table

