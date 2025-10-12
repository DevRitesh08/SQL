----
-- Joins
----

-- In SQL (Structured Query Language), a JOIN is a way to combine data from two or more database tables
-- based on a related column between them .

-- Joins are used when we want to query information that is distributed across multiple tables in a database ,
-- and the information we need is not contained in a single table .
-- By joining tables together , we can create a virtual table that contains all of the information we need for our query .

-- To perform a JOIN , it is necessary to have a common column between the tables being joined .


-- creating sample tables
CREATE DATABASE joins_db;

USE joins_db;
CREATE TABLE users (
    user_id INT PRIMARY KEY,
    user_name VARCHAR(50),
    email VARCHAR(100)
);

CREATE TABLE orders (
    order_id INT PRIMARY KEY,
    user_id INT,
    product VARCHAR(100),
    amount DECIMAL(10, 2)
);

INSERT INTO users (user_id, user_name, email) VALUES
(1, 'Alice', 'alice@example.com'),
(2, 'Bob', 'bob@example.com'),
(3, 'Charlie', 'charlie@example.com'),
(4, 'David', 'david@example.com'),
(5, 'Eve', 'eve@example.com'),
(6, 'Frank', 'frank@example.com'),
(7, 'Grace', 'grace@example.com');

INSERT INTO orders (order_id, user_id, product, amount) VALUES
(101, 1, 'Laptop', 1200.00),
(102, 2, 'Smartphone', 800.00),
(103, 1, 'Tablet', 300.00),
(104, 3, 'Headphones', 150.00),
(105, 4, 'Monitor', 400.00),
(106, 9, 'Keyboard', 100.00), -- Note: user_id 9 does not exist in users table
(107, 10, 'Mouse', 50.00),    -- Note: user_id 10 does not exist in users table
(108, 11, 'Charger', 25.00);  -- Note: user_id 11 does not exist in users table
-- Sample Data
-- Users Table
SELECT * FROM users;
-- Orders Table
SELECT * FROM orders;
-------------------------------------------------------------------------------------------------------------------


---
-- Cross Join
----

SELECT * FROM joins_db.users t1
CROSS JOIN joins_db.orders t2;

-- The CROSS JOIN returns the Cartesian product of the two tables ,
-- meaning it combines each row from the first table with every row from the second table .

---
-- Inner Join
----

SELECT * FROM joins_db.users t1
INNER JOIN joins_db.orders t2 ON t1.user_id = t2.user_id;       -- also just "JOIN" can be used since INNER is default

-- The INNER JOIN returns only the rows that have matching values in both tables .

---
-- Left Join (or Left Outer Join)
----
SELECT * FROM joins_db.users t1
LEFT JOIN joins_db.orders t2 ON t1.user_id = t2.user_id;

-- The LEFT JOIN returns all rows from the left table (users) ,
-- and the matched rows from the right table (orders) .
-- If there is no match , the result is NULL on the side of the right table .

---
-- Right Join (or Right Outer Join)
----
SELECT * FROM joins_db.users t1
RIGHT JOIN joins_db.orders t2 ON t1.user_id = t2.user_id;

-- The RIGHT JOIN returns all rows from the right table (orders) ,
-- and the matched rows from the left table (users) .
-- If there is no match , the result is NULL on the side of the left table .

---
-- Full Join (or Full Outer Join)
----
SELECT * FROM joins_db.users t1
FULL JOIN joins_db.orders t2 
ON t1.user_id = t2.user_id;

-- Can't be run in MySQL as it does not support FULL JOIN directly. so using UNION of LEFT JOIN and RIGHT JOIN we can achieve the same result.
-- The FULL JOIN returns all rows when there is a match in either left (users) or right (orders) table .
-- If there is no match , the result is NULL from the side that does not have a match .
