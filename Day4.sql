fCREATE DATABASE IF NOT EXISTS day4_db; 
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






-- Subquaries in sql

CREATE table employee (
    emp_id int AUTO_INCREMENT PRIMARY KEY ,
    emp_name varchar(50) ,
    salary int 
);

INSERT INTO employee (emp_name, salary) VALUES
('Shubham', 50000),
('Aman', 60000),
('Naveen', 55000),
('Aditya', 21000),
('Nishant', 60000),
('yukti', 50000),
('sahil', 21000),
('tushar', 60000),
('anukriti', 90000),
('ajay', 50000);

-- write a query to find the employee that has greater salary then ajay .

--way 1 (not recommended since here we hard coded the salary of ajay)
SELECT * FROM employee WHERE salary > 50000;
--way 2 (recommended way)
-- here we are using a subquery to get the salary of ajay and then using that salary to filter the employees with greater salary.
SELECT * FROM employee WHERE salary > (SELECT salary FROM employee WHERE emp_name = 'Ajay') ;

-- executing the subquery first and then using the result in the main query .
SELECT salary FROM employee WHERE emp_name = 'Ajay' ;





-- USE of IN and NOT IN operator
SELECT * FROM order_data ;

-- write a query to print all orders which were placed in delhi or texas .
-- Method 1 : using OR operator
SELECT * FROM order_data WHERE state = 'Delhi' OR state = 'Texas';
-- Method 2 : using IN operator
SELECT * FROM order_data WHERE state IN ('Delhi', 'Texas');







CREATE table customer_order_data(
    order_id INT  AUTO_INCREMENT PRIMARY KEY,
    customer_id INT ,
    supplier_id INT,
    country VARCHAR(100) ,
    state VARCHAR(100) 
);

INSERT INTO customer_order_data(customer_id , supplier_id , country , state) VALUES(001 , 7575 , 'USA' , 'California'),
(002 , 7576 , 'USA' , 'Texas'),
(003 , 7577 , 'India' , 'Delhi'),
(004 , 7578 , 'India' , 'Mumbai'),
(005 , 7579 , 'UK' , 'London'),
(006 , 7580 , 'UK' , 'Manchester'),
(007 , 7581 , 'India' , 'Delhi'),
(008 , 7582 , 'USA' , 'California'),
(009 , 7583 , 'India' , 'Mumbai'),
(010 , 7584 , 'UK' , 'London');

SELECT * FROM customer_order_data;


CREATE table supplier_order_data(
    supplier_id INT,
    sup_country VARCHAR(100) 
);


INSERT INTO supplier_order_data VALUES
(7577, 'India'),
(7584, 'UK');

SELECT * FROM supplier_order_data;

-- write a query to print all the customer orders data where all customers are from the same countries as the supplier .
SELECT * from customer_order_data WHERE cust_country IN
(SELECT DISTINCT sup_country FROM supplier_order_data);



-- case when statement
-- case when statement is used to perform conditional logic in sql queries, it is similar to if-else statements in programming languages.


CREATE Table student_marks (
    std_id int PRIMARY KEY AUTO_INCREMENT , 
    std_name VARCHAR(50) , 
    total_marks int 
);

INSERT into student_marks(std_name , total_marks ) values(
    'Shubham' , 90),
    ('Aman' , 80),
    ('Naveen' , 90),
    ('Aditya' , 60),
    ('Nishant' , 50),
    ('Yukti' , 30),
    ('Sahil' , 94),
    ('Tushar' , 86),
    ('Anukriti' , 68),
    ('Ajay' , 100),
    ('Rohan' , 85),
    ('Sonia' , 95),
    ('Rahul' , 75),
    ('Priya' , 98),
    ('Karan' , 55),
    ('Anushka' , 25),
    ('Bharti' , 35),
    ('Harsh' , 65),
    ('Megha' , 58), 
    ('Purav' , 53);

SELECT * FROM student_marks;


-- write a query to print the student name and their grade based on their total marks .
-- marks >= 90 : A+ , marks >= 80 : A , marks >= 70 : B+ , marks >= 60 : B , marks >= 50 : C+ , marks >= 40 : C , marks < 40 : D

SELECT std_name , 
    CASE
        WHEN total_marks >= 90 THEN 'A+'
        WHEN total_marks >= 80 THEN 'A'
        WHEN total_marks >= 70 THEN 'B+'
        WHEN total_marks >= 60 THEN 'B'
        WHEN total_marks >= 50 THEN 'C+'
        WHEN total_marks >= 40 THEN 'C'
        ELSE 'D'
    END AS grade
FROM student_marks;


-- UBER INTERVIEW QUESTION
-- A table named tree is given , that contains the following columns: node , parent . 
-- Write a query to print the type of each node in the tree, where the type is defined as follows:
-- 1. If the node is a root node (i.e., it has no parent), then its type is 'Root'.
-- 2. If the node is a leaf node (i.e., it has no children), then its type is 'Leaf'.
-- 3. If the node is neither a root nor a leaf, then its type is 'Intermediate'.
CREATE TABLE tree (
    node INT,
    parent INT
);

INSERT INTO tree VALUES
    (15 , NULL) ,
    (12 , 15) ,
    (17 , 15) ,
    (11 , 12) ,
    (14 , 12) , 
    (20 , 17) ,
    (16 , 17) ,
    (10 , 11) ,
    (13 , 11) ,
    (8 , 14)  ,
    (18 , 14) ;

SELECT * FROM tree ;

--  Query to find the type of each node in the tree
SELECT node ,
    CASE 
        WHEN parent is null THEN 'Root' 
        WHEN node IN (SELECT DISTINCT parent FROM tree) THEN 'Intermediate'
        -- or   WHEN node IN (SELECT DISTINCT parent FROM tree WHERE parent NOT NULL) THEN 'Intermediate'
        ELSE  'Leaf'
    END as Node_Type
FROM tree ;

