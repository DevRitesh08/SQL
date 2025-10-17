------
-- Meta Data Queries
------

-- How to see all the tables in a database 
SELECT Table_name FROM information_schema.TABLES
where table_schema = 'zomato' ;

-- How to print col names of a table
SELECT COLUMN_NAME FROM information_schema.columns
where table_schema = 'movies' and TABLE_NAME = 'movies' ;
SELECT COLUMN_NAME FROM information_schema.columns
where table_schema = 'zomato' and TABLE_NAME = 'orders' ;

-- How to see constraints of a table STILL NEED TO COMPLETE --------------------------------------------
-- SELECT * FROM information_schema.CHECK_CONSTRAINTS
-- where TABLE_NAME = 

-- How to copy table defination  => how to create an empty table with the same structure as another table ?
CREATE Table zomato.empty_orders LIKE zomato.orders;
CREATE Table movies.empty_movies LIKE movies.movies;

SELECT COLUMN_NAME FROM information_schema.columns
where table_schema = 'movies' and TABLE_NAME = 'empty_movies' ;
SELECT COLUMN_NAME FROM information_schema.columns
where table_schema = 'zomato' and TABLE_NAME = 'empty_orders' ;
