
CREATE DATABASE if not exists day3_db ;
use day3_db ;
CREATE table workers (
    worker_id INT,
    worker_name varchar(50), 
    worker_age INT ,
    salary INT, 
    city varchar(50)
)

INSERT INTO workers VALUES(1 , 'akash' , 25 , 25000 , 'jaipur') , (2,'ajay' , 27 , 22000 , 'jaipur') , (3,'aman' , 26 , 24000 , 'agra') , (4,'aditya' , 28 , 26000 , 'jaipur') , (5,'nishant' , 29 , 27000 , 'indore');

SELECT * FROM workers ;

-- Performing multi updates 
UPDATE workers SET 
    worker_age = worker_age + 1,
    salary = salary + 5000
WHERE city = 'jaipur';




-- auto increment 

-- auto increment is used to generate unique values for a column automatically when a new record is inserted.
CREATE TABLE IF NOT EXISTS classmates (
    id INT AUTO_INCREMENT,
    name VARCHAR(50) ,
    age INT,
    PRIMARY KEY(id) -- auto increment is used with primary key as it is unique and cannot have NULL values .
);
INSERT INTO classmates (name, age) VALUES ('Shubham', 23), ('Aman', 21), ('Naveen', 24), ('Aditya', 21), ('Nishant', 22) , ('yukti' , 21) , ('sahil' , 22) , ('tushar' , 23) , ('anukriti' , 24) , ('ajay' , 25);

SELECT * FROM classmates;



-- use of limit clause
SELECT * FROM classmates LIMIT 6; -- it will always be placed at the end of the query .
SELECT * FROM classmates LIMIT 3, 5; -- it will skip the first 3 records and return the next 5 records.


-- sorting data by using order by clause
SELECT * FROM classmates ORDER BY name; -- here the sorting order is ascending in nature .
SELECT * FROM classmates ORDER BY name DESC; -- here the sorting order is descending in nature .





-- Multi level ordering 
use day3_db;
-- create table employee the sort data in desc order by salary and if salaries are same for more than one employee arrange their data in ascending order of name .
CREATE table if not exists employee (
    emp_id int AUTO_INCREMENT PRIMARY KEY ,
    emp_name varchar(50) ,
    salary int ,
    city varchar(20) DEFAULT 'jaipur'
)

INSERT into employee(emp_name , salary ) VALUES('Shubham', 50000),
        ( 'Aman', 60000 ),
        ( 'Naveen', 55000) ,
        ('Aditya', 21000),
        ('Nishant', 60000) , 
        ('yukti' , 50000) , 
        ('sahil' , 21000) , 
        ('tushar' , 60000) , 
        ('anukriti' , 90000) , 
        ('ajay' , 50000);


SELECT * FROM employee ORDER BY salary desc , emp_name ASC; -- by default it is in asc order , we can apply multiple level of ordering by using " , " next ordering will be executed when the earlier level is having duplicate values .
SELECT * FROM employee ;



-- Write a query to find the employee with the maximum salary .
select * FROM employee ORDER BY salary desc limit 1 ;


-- Write a query to find the employee with the minimum salary .
select * FROM employee ORDER BY salary  limit 1 ;




-- Conditional Operators : > , < , >= , <=
-- Logical Operators : AND , OR , NOT
use day3_db ;

INSERT into employee(emp_name , salary ) VALUES('shantanu', 58000),
        ( 'rishu', 30000 ),
        ( 'ritesh', 25000) ,
        ('ankush', 20000),
        ('anu', 46000) , 
        ('payal' , 51000) , 
        ('sameer' , 61000) , 
        ('mohit' , 72000) , 
        ('suryansh' , 84000) , 
        ('anju' , 39000);
SELECT * FROM employee ;

-- List all employee whose salary is more than 60k
SELECT * FROM employee WHERE salary > 60000 ;

-- List all employee whose salary is equal to 50k , here in sql equality is " = " only . 
SELECT * FROM employee WHERE salary = 50000 ;

-- List all employee whose salary is between 50k  and 75k
SELECT * FROM employee WHERE salary >= 50000 and salary <= 75000;

-- List all employee whose salary is not equal to 50k
--Method 1
SELECT * FROM employee WHERE salary != 50000 ;
--Method 2
SELECT * FROM employee WHERE salary <> 50000 ;
-- hence both " != " and " <> " can be used for the not equal to condition .




--How to use between operation in where clause 

-- List all employee whose salary is between 46k  and 61k
SELECT * FROM employee WHERE salary BETWEEN 46000 AND 61000 ;




-- How to use like operation in where clause , like operation work for only string type columns ,  like operation is case sensitive .

-- wild-card characters below 
-- " % " : zero , one , or more characters .
-- " _ " : only one character .

-- get all those employee whose name start with "r" .
SELECT * FROM employee where emp_name LIKE 'r%' ;

-- get all those employee whose name start with "rit" .
SELECT * FROM employee where emp_name LIKE 'rit%' ;

-- get all those employee whose name ends with "i" .
SELECT * FROM employee where emp_name LIKE '%i' ;

-- get all  those employee whose name starts with "a" and ends with "u" .
SELECT * FROM employee where emp_name LIKE 'a%u' ;

-- get all  those employee whose name starts with "y" and second last character is  "t" .
SELECT * FROM employee where emp_name LIKE 'y%t_' ;

-- get all those employees whose name have exactly 5 characters .
SELECT * FROM employee where emp_name LIKE '_____' ; -- use '_' 5 times .

-- get all those employees whose name have at least 7 characters .
SELECT * FROM employee where emp_name LIKE '%_______%' ;  -- use '_' 7 times .





-- How to use is null and is not null in where clause
INSERT into employee(emp_name , salary ) VALUES('anushka', 58000),
        ( 'bharti', 30000 ),
        ( 'harsh', 25000) ,
        ('megha', 20000),
        ('purav', 46000) , 
        (NULL , 51000) , 
        ('salman' , NULL) , 
        ('aashish' , NULL) , 
        ('chirag' , 84000) , 
        (null , 39000);
    
SELECT * FROM employee ;

-- get all those employee whose salary is null
SELECT * FROM employee where salary is null ;

---- get all those employee whose salary is not last list only 6 data from the last .
SELECT * FROM employee where salary is not null ORDER BY emp_id DESC LIMIT 6;






-- Grouping data using group by clause
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

-- Grouping data by country and counting the number of orders in each country

-- Error: Only grouped columns or aggregate functions can be selected; customer_id is not allowed here.
SELECT country,customer_id , count(*) as order_count from order_data GROUP BY country;
-- Corrected query: Only grouped columns or aggregate functions can be selected; customer_id is not allowed here.
SELECT country , count(*) as order_count from order_data GROUP BY country;



SELECT * FROM classmates;
-- group data by age and count the number of students in each age group
SELECT age , count(*) as age_count FROM classmates GROUP BY age;



SELECT * FROM employee;
DELETE FROM employee WHERE emp_name = NULL OR salary = NULL; -- this will not delete any record as NULL is not equal to NULL , the correct way to check for NULL is using " IS NULL " or " IS NOT NULL "
DELETE FROM employee WHERE emp_name IS NULL OR salary IS NULL; -- this will delete all records where emp_name or salary is NULL

create table worker(
    worker_id INT AUTO_INCREMENT PRIMARY KEY,
    worker_name VARCHAR(50),
    worker_age INT,
    salary INT,
    city VARCHAR(50)
);
INSERT into worker(worker_name, worker_age, salary, city) VALUES
('Akash', 25, 25000, 'Jaipur'),
('Ajay', 21, 82000, 'Jaipur'),
('Aman', 26, 24000, 'Agra'),
('Aditya', 28, 26000, 'Jaipur'),
('Nishant', 26, 27000, 'Indore'),
('Yukti', 21, 23000, 'Delhi'),
('Sahil', 23, 72000, 'Mumbai'),
('Tushar', 23, 24000, 'Bangalore'),
('Anukriti', 28, 95000, 'Chennai'),
('Ajay', 25, 26000, 'Kolkata'),
('Rohan', 30, 28000, 'Pune'),
('Sonia', 26, 29000, 'Hyderabad'),
('Rahul', 28, 30000, 'Ahmedabad'),
('Priya', 30, 49000, 'Chennai'),
('Karan', 26, 32000, 'Delhi');

DROP TABLE IF EXISTS worker;

SELECT * FROM worker;
-- Grouping data by city and counting the number of workers in each city
SELECT city, COUNT(*) AS worker_count FROM worker GROUP BY city;

-- Grouping data by age and counting the tatal salary of each age group .
SELECT worker_age, sum(salary) AS tatal_salary_of_each_age_group FROM worker GROUP BY worker_age;

-- calculate different aggregated matrices for salary .
SELECT worker_age,
        sum(salary) AS tatal_salary_of_each_age_group ,
        max(salary) as Max_salary_of_each_age_group ,
        min(salary) as Min_salary_of_each_age_group ,
        avg(salary) as Avg_salary_of_each_age_group ,
        count(*) as Total_workers_of_each_age_group
        FROM worker GROUP BY worker_age;


