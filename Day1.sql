
-- command to create databases
Create Database Sql_Bootcamp ;
create Database test ;

--Command to show databases :
show databases ;

use sql_bootcamp;

-- command to create tables
create table salesman(
    salesmanid INT PRIMARY KEY,
    salesmanname VARCHAR(50)
);

CREATE TABLE if not exists Customer(
    CustomerID INT PRIMARY KEY,
    CustomerName VARCHAR(50),
    LastName VARCHAR(50),
    Country VARCHAR(50),
    Age INT CHECK (Age >= 0 AND Age <= 99),
    Phone int(10)
);

--command to list tables
show TABLES ;

-- command to describe the table
describe Customer;

-- command to drop the table
drop table if exists salesman;

-- to get the schema or defination of the table
show create table Customer;



-- command to insert data in tables
--Method 1 : when we only specify the table name then we have to insert values for all columns in the same order as they are defined in the table .
insert into Customer values(1, 'Shubham', 'Thakur', 'India','23','435356353'),
       (2, 'Aman ', 'Chopra', 'Australia','21','435356353'),
       (3, 'Naveen', 'Tulasi', 'Sri lanka','24','435356353');

-- if we skip any column then the code will throw an error
insert into Customer values(4, 'Amit', 'Kumar', 'India',25);

--Method 2 : when we specify the column names then we can insert values for only those columns and the rest will be set to default or NULL.
INSERT INTO Customer (CustomerID, CustomerName, LastName, Country, Age, Phone)
VALUES (1, 'Shubham', 'Thakur', 'India','23','435356353'),
       (2, 'Aman ', 'Chopra', 'Australia','21','435356353'),
       (3, 'Naveen', 'Tulasi', 'Sri lanka','24','435356353'),
       (4, 'Aditya', 'Arpan', 'Austria','21','435356353'),
       (5, 'Nishant. Salchichas S.A.', 'Jain', 'Spain','22','435356353');
       



-- use select to view the data in the table .
SELECT* FROM Customer;








-- EXAMPLE  for integrity constraint
CREATE TABLE IF NOT EXISTS Orders (
    OrderID INT ,
    CustomerID INT NOT NULL,
    OrderDate DATE DEFAULT '2025-07-16',
    UNIQUE(OrderID),
    check(OrderID > 5)
) ;

-- error will be thrown if we try to insert a value for OrderID that is less than or equal to 5 .
INSERT into orders values(3, 1, '2025-07-16');

-- error will be thrown if we try to insert null value for CustomerID .
INSERT into orders values(4, null, '2025-07-16');

-- default value for OrderDate will be used
INSERT into orders(OrderID,CustomerID) values(6, 1);

--error duplicate value for OrderID will throw an error
INSERT into orders(OrderID,CustomerID) values(6, 1);

select * from Orders ;






-- add alias for the constraints ==> it helps in identifying the constraints in case of errors
CREATE TABLE IF NOT EXISTS Orders_alias (
    OrderID INT ,
    CustomerID INT NOT NULL,
    OrderDate DATE DEFAULT '2025-07-16',
    constraint UNIQUE_orderid UNIQUE(OrderID),
    constraint orderId_check check(OrderID > 5)
) ;

-- error will be thrown if we try to insert a value for OrderID that is less than or equal to 5 .
INSERT into Orders_alias values(3, 1, '2025-07-16');

-- error will be thrown if we try to insert null value for CustomerID .
INSERT into Orders_alias values(4, null, '2025-07-16');

-- default value for OrderDate will be used
INSERT into Orders_alias(OrderID,CustomerID) values(6, 1);

--error duplicate value for OrderID will throw an error
INSERT into Orders_alias(OrderID,CustomerID) values(6, 1);

