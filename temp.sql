-- DML Queries
--    -- Insert , Update , Delete , Select




----
-- Insert queries
----

    -- Inserting data into a table
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