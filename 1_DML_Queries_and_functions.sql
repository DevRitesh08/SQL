-- DDL Commands
-- -- CREATE , ALTER , DROP , RENAME , TRUNCATE

-- WHY TRUNCATE DDL ??
-- resets/deallocates the table's data storage while keeping the table structure intact. 
-- It is faster than DELETE because it does not generate individual row delete statements and does not log individual row deletions.



-- DML Queries
--    -- Insert , Update , Delete , Select




----
-- Insert queries
----

    -- Inserting data into a table

    create DATABASE IF NOT EXISTS temp;
    use temp ;

    create table ticket (
        ticket_id int PRIMARY KEY AUTO_INCREMENT ,
        u_name varchar(25) Not NULL ,
        travel_date DATETIME DEFAULT CURRENT_TIMESTAMP
    )

    -- inserting a single row into a table
    insert into ticket(u_name , travel_date)
    VALUES('John Doe', '2024-06-10 09:00:00');
        -- We specified the target columns (u_name, travel_date) above.
        -- If you omit the column list in INSERT, you must provide values for every column
        -- in the table in the defined column order. ('Jane Roe', '2024-06-12 14:15:00')

    insert into ticket(u_name ) 
    VALUES('sam altman')

    select * from ticket;

    use temp;
    show TABLES;
    create table if not exists temp.Users_table(
    user_id int	auto_increment primary key ,
    user_name varchar(30) not null ,
    email varchar(50) not null unique ,
    user_password varchar(30) not null DEFAULT 'password123'
    );

    drop table if exists temp.Users_table;


    insert into temp.Users_table (user_id , user_name , email , user_password)
    values(11 , 'alex' , '123alex@gmail.com'  , 'alex123');

    -- inserting multiple rows into a table
    insert into temp.Users_table (email , user_name , user_id)
    values('john123@gmail.com'  , 'john' , 12),
    ('jane123@gmail.com'  , 'jane' , 13),
    ('doe123@gmail.com'  , 'doe' , 14),
    ('smith123@gmail.com'  , 'smith' , 15),
    ('alice123@gmail.com'  , 'alice' , 16),
    ('bob123@gmail.com'  , 'bob' , 17),
    ('charlie123@gmail.com'  , 'charlie' , 18);


----
-- Changing primary key when auto increment is enabled
----

-- We can't directly drop the primary key because the AUTO_INCREMENT column must be defined as a key.
-- So first remove AUTO_INCREMENT, then drop the primary key.

ALTER TABLE temp.Users_table
MODIFY user_id INT;

ALTER TABLE temp.Users_table
DROP PRIMARY KEY;

SELECT * FROM temp.Users_table;


-- if we are going to change the primary key to a different column .
ALTER TABLE temp.Users_table
MODIFY user_id INT,
DROP PRIMARY KEY,
ADD PRIMARY KEY (email);

-- if you want id to remain AUTO_INCREMENT, it must remain indexed/keyed. You can't have:

-- id → AUTO_INCREMENT
-- id → NOT a key

----
-- AUTO_INCREMENT column must be indexed, and usually is the PRIMARY KEY.
----

-- But AUTO_INCREMENT ≠ PRIMARY KEY.

-- It is perfectly possible to have:

-- id INT AUTO_INCREMENT UNIQUE

-- because UNIQUE is also a key/index.


    --------------------------------------------------------------------------------------------------------------------------------------------------------------------


---
-- Select queries
---


    -- select all columns from a table

    select * from temp.smartphones;
    -- alternative way to select all columns
    -- select * from temp.smartphones where 1 ; -- where 1 is always true so it returns all rows



    -- select specific columns from a table

    SELECT user_name , email from temp.Users_table;
    select model , price , rating from temp.smartphones;



    -- Aliasing columns

    SELECT user_name AS Name , email AS Email_Address from temp.Users_table;
    SELECT os as Operating_System , model AS Model_Name , battery_capacity AS Battery , price AS Price_in_INR from temp.smartphones;



    -- Using expressions in select statement

    -- calculating ppi of smartphones
    SELECT model as Model , 
    SQRT(resolution_width*resolution_width + resolution_height*resolution_height)/screen_size as PPI 
    from temp.smartphones ;
    -- Adjusting rating out of 10
    SELECT model , rating/10 as Adjusted_Rating from temp.smartphones;



    -- creating Constants 

    select model , 'smartphone' as 'type_' from temp.smartphones;
    SELECT model  , price*0.82 as Price_without_GST from temp.smartphones; -- assuming 18% GST



    -- Distinct values from a column

    SELECT DISTINCT brand_name from temp.smartphones;
    -- more generic way to select distinct values from a column
    SELECT DISTINCT(brand_name) from temp.smartphones; -- parentheses are better for readability
    -- distinct operating systems
    SELECT DISTINCT(os) as all_Operating_Systems from temp.smartphones;
    -- distinct processor brands
    SELECT DISTINCT(processor_brand) as all_Processors from temp.smartphones;



    -- Distinct Combinations of multiple columns

    -- brand and processor combinations
    SELECT DISTINCT brand_name , processor_brand from temp.smartphones;



    -- Filtering rows using WHERE clause
    
    -- finding all samsung phones
    SELECT * from temp.smartphones where brand_name = 'Samsung';
    -- finding all phones with price greater than 30000
    SELECT * from temp.smartphones where price > 30000;



    -- Between operator

    -- finding phones with price between 20000 and 40000
    SELECT * from temp.smartphones 
    where price BETWEEN 20000 AND 40000;
    -- without between operator
    -- SELECT * from temp.smartphones 
    -- where price >= 20000 AND price <= 40000;
    -- find all phones with rating > 80 and price between 20000 and 25000 and processor brand is Snapdragon
    SELECT * from temp.smartphones 
    where rating > 80 AND price > 20000 AND price < 25000 AND processor_brand = 'Snapdragon';
    -- find all samsung phones with ram > 8
    SELECT * from temp.smartphones 
    where brand_name = 'Samsung' AND ram_capacity > 8;
    -- find all samsung phones with processor brand Exynos or Snapdragon
    SELECT * from temp.smartphones 
    where brand_name = 'Samsung' AND (processor_brand = 'Exynos' OR processor_brand = 'Snapdragon');
    -- find brands who sell smartphones with price > 80000
    SELECT DISTINCT brand_name from temp.smartphones 
    where price > 80000;



    -- IN and NOT IN operators

    -- find all phones with brand either Apple , OnePlus or Samsung
    SELECT * from temp.smartphones                                                        -- without using IN operator , not efficient when their are many values 
    WHERE brand_name = 'Apple' OR brand_name = 'OnePlus' OR brand_name = 'Samsung';     
    SELECT * from temp.smartphones                                                          -- using IN operator
    WHERE brand_name IN ('Apple', 'OnePlus', 'Samsung');
    -- find all phones with brand not Apple and Samsung
    SELECT * from temp.smartphones
    WHERE brand_name NOT IN ('Apple', 'Samsung');


    --------------------------------------------------------------------------------------------------------------------------------------------------------------------


---
-- Update queries
---


    SELECT * from temp.smartphones where processor_brand = 'dimensity';
    -- Changing processor_brand dimensity to Dimensity
    UPDATE temp.smartphones
    SET processor_brand = 'Dimensity'
    WHERE processor_brand = 'dimensity';
    SELECT * from temp.users_table;
    -- Changing email and user_password for user_id 16
    UPDATE temp.users_table
    SET email = 'alice@example.com', user_password = 'alice2024'
    WHERE user_id = 16;


    --------------------------------------------------------------------------------------------------------------------------------------------------------------------


---
-- Delete queries
---


    -- Delete smartphones with price more than 200k
    SELECT * from temp.smartphones where price > 200000;
    DELETE from temp.smartphones where price > 200000;
    -- Delete smartphones that has primary camera more than 100MP and brand_name is samsung
    SELECT * from temp.smartphones where primary_camera_rear > 100 AND brand_name = 'Samsung';
    DELETE FROM temp.smartphones where primary_camera_rear > 100 AND brand_name = 'Samsung';


    -- Update and Delete are irreversible operations. Always take a backup before performing these operations on important data.
    -- Use transactions to group multiple operations into a single unit of work that can be committed or rolled back as needed.



    --------------------------------------------------------------------------------------------------------------------------------------------------------------------
    --------------------------------------------------------------------------------------------------------------------------------------------------------------------

----
-- Functions in sql : 
-- functions in sql are pre-defined operations that perform specific tasks on data and return a result.
-- Their are many built-in functions available in SQL that can be used to manipulate and analyze data.
-- They can be used in SQL queries to manipulate and analyze data.
-- types of functions:
-- 1. Aggregate functions : operate on a set of values and return a single value.
-- 2. Scalar functions : operate on a single value and return a single value.
----



----- Aggregate functions
----



    -- MAX() : returns the maximum value in a column.

    -- finding the most expensive smartphone
    SELECT MAX(price) as Most_Expensive_Smartphone from temp.smartphones;
    -- finding the smartphone with highest rating
    SELECT MAX(rating) as Highest_Rated_Smartphone from temp.smartphones;
    -- find the most expensive samsung smartphone
    SELECT MAX(price) as Most_Expensive_Samsung from temp.smartphones where brand_name = 'Samsung';


    -- MIN() : returns the minimum value in a column.

    -- finding the cheapest smartphone
    SELECT MIN(price) as Cheapest_Smartphone from temp.smartphones;
    -- finding the smartphone with lowest rating
    SELECT MIN(rating) as Lowest_Rated_Smartphone from temp.smartphones;   


    -- AVG() : returns the average value in a column.

    -- finding the average price of apple smartphones
    SELECT AVG(price) as Average_Price_Apple from temp.smartphones where brand_name = 'Apple';


    -- SUM() : returns the sum of all values in a column.

    -- finding the total price of all smartphones
    SELECT SUM(price) as Total_Price_of_Smartphones from temp.smartphones; 


    -- COUNT() : returns the number of rows in a table or the number of non-null values in a column.

    -- finding the total number of one plus smartphones
    SELECT COUNT(*) as Total_OnePlus_Smartphones from temp.smartphones where brand_name = 'OnePlus';
    SELECT COUNT(*) as Total_Smartphones from temp.smartphones; -- counts all rows including duplicates and nulls
    -- counting unique non-null brand names
    SELECT COUNT(DISTINCT(brand_name)) as Unique_Brands from temp.smartphones; -- counts unique non-null brand names
    -- alternative way to count unique non-null brand names
    SELECT COUNT(DISTINCT brand_name) as Unique_Brands from temp.smartphones; -- counts unique non-null brand names
    SELECT COUNT(processor_brand) as Non_Null_Processors from temp.smartphones; -- counts non-null processor brands


    -- STD() : returns the standard deviation of a column.

    -- finding the standard deviation of smartphone screen sizes
    SELECT STD(screen_size) as Screen_Size_Std_Dev from temp.smartphones; 


    -- VARIANCE() : returns the variance of a column.

    -- finding the variance of smartphone screen sizes
    SELECT VARIANCE(screen_size) as Screen_Size_Variance from temp.smartphones;



----- Scalar functions
----



    -- ABS() : returns the absolute value of a number.
    
    -- firstly let's create a table with some negative values
    CREATE TABLE IF NOT EXISTS temp.test_numbers (
        num INT
    );
    -- inserting some negative values
    INSERT INTO temp.test_numbers VALUES (-5), (-10), (-15);
    -- finding the absolute values
    SELECT ABS(num) as Absolute_Value from temp.test_numbers;+


    -- ROUND() : rounds a number to the nearest integer or to a specified number of decimal places.
    SELECT * from temp.smartphones;
    -- table to demonstrate ROUND function
    CREATE TABLE IF NOT EXISTS temp.test_numbers_float (
        num FLOAT
    );
    -- inserting some float values
    INSERT INTO temp.test_numbers_float VALUES (5.67243243), (10.2313232), (15.89232);
    -- rounding to nearest integer
    SELECT ROUND(num) as Rounded_Value from temp.test_numbers_float;
    -- rounding to 2 decimal place
    SELECT ROUND(num, 2) as Rounded_Value from temp.test_numbers_float;


    -- CEIL() : rounds a number up to the next integer. example: CEIL(4.2) = 5 , CEIL(4.8) = 5 , CEIL(-4.2) = -4 , CEIL(-4.9) = -4
    SELECT CEIL(num) as Ceil_Value from temp.test_numbers_float;
    -- FLOOR() : rounds a number down to the previous integer. example: FLOOR(4.2) = 4 , FLOOR(4.8) = 4 , FLOOR(-4.2) = -5 , FLOOR(-4.9) = -5
    SELECT FLOOR(num) as Floor_Value from temp.test_numbers_float;
