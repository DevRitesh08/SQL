CREATE DATABASE IF NOT EXISTS day4_db; 
USE day4_db;

CREATE Table order_data(
    order_id INT  AUTO_INCREMENT PRIMARY KEY,
    customer_id INT ,
    country VARCHAR(100) ,
    state VARCHAR(100) 
);

INSERT INTO order_data (customer_id, country, state) VALUES
(100, 'India', 'Delhi'),
(282, 'India', 'Mumbai'),
(3928, 'USA', 'California'),
(4092, 'India', 'Delhi'),
(52, 'USA', 'Texas'),
(682, 'India', 'Mumbai'),
(792, 'USA', 'California'),
(8829, 'India', 'Delhi'),
(9920, 'USA', 'Texas'),
(1021, 'UK', 'London'),
(1122, 'India', 'Delhi'),
(1223, 'USA', 'California'),
(1324, 'India', 'Mumbai'),
(1425, 'UK', 'Manchester'),
(1526, 'USA', 'California'),
(1627, 'India', 'Delhi'),
(1728, 'India', 'Mumbai'),
(1829, 'USA', 'Texas'),
(1920, 'UK', 'London'),
(2021, 'India', 'Delhi'),
(2122, 'USA', 'California'),
(1324, 'Uk', 'London'),
(1425, 'UK' , 'Manchester'),
(1526, 'USA', 'California'),
(1627, 'India', 'Delhi'),
(1728, 'India', 'Mumbai'),
(1829, 'USA', 'Texas'),
(1920, 'UK', 'London'),
(2021, 'India', 'Delhi'),
(2122, 'USA', 'California');

SELECT * FROM order_data;






-- use of having clause
-- having clause is used to filter the data after grouping it using group by clause , it is used with aggregate functions like count, sum, avg, max, min etc.
-- Example: Get the count of orders for each country where the count is greater than 2

-- write a query to find the country where exactly 6 orders are placed .
SELECT country from order_data GROUP BY country having count(*) = 6 ;

-- where and group by clause  --> what should be the proper sequence in an sql query ?
-- firstly "where clause" followed by "group by" , think it has these operations are very expensive  in  the case of very very large data so so always try to reduce the data as much as possible , hence by using the " where clause " we can reduce our domain and then we can group the data by using " group by clause " .
-- so always remember the sequence of operations in an sql query is " where clause " followed by " group by clause " and then " having clause " .





-- how to use group_concat function
-- group_concat function is used to concatenate the values of a column into a single string, separated by a specified separator.
-- write a query to print the country and the list of states in that country , separated by a comma .
SELECT country , GROUP_CONCAT( DISTINCT state) AS states_in_country FROM order_data GROUP BY country;

-- can also change the order 
SELECT country , GROUP_CONCAT( DISTINCT state ORDER BY state DESC) AS states_in_country FROM order_data GROUP BY country;
-- can also change the separator
SELECT country , GROUP_CONCAT( DISTINCT state ORDER BY state DESC SEPARATOR ' | ') AS states_in_country FROM order_data GROUP BY country;
