
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
    CustomerID INT --PRIMARY KEY
    ,
    CustomerName VARCHAR(50),
    LastName VARCHAR(50),
    Country VARCHAR(50),
    Age INT --CHECK (Age >= 0 AND Age <= 99)
    ,
    Phone int(10)

    -- adding constraints to the table ==> better way to add constraints is to add them after the column definition and give them a name so that we can identify them in case of errors and also we can drop them easily if required.
    constraint Age_check check (Age >= 0 AND Age <= 99)
    constraint pk_CustomerID PRIMARY KEY (CustomerID)
);


--command to list tables
show TABLES ;

-- command to describe the table
describe Customer;

-- command to drop the table
drop table if exists salesman;

-- To get the schema or defination of the table
show create table Customer;
-- why create table is used ? => because it shows the complete definition of the table including the constraints and their names.



-- command to insert data in tables
--Method 1 : when we only specify the table name then we have to insert values for all columns in the same order as they are defined in the table .
insert into Customer values(1, 'Shubh', 'Chopra', 'India','23','435356353'),
       (2, 'ema ', 'smith', 'Australia','21','435356353'),
       (3, 'Naval', 'Thakur', 'Sri lanka','24','435356353');

-- if we skip any column then the code will throw an error
insert into Customer values(4, 'Amit', 'Kumar', 'India',25);

--Method 2 : when we specify the column names then we can insert values for only those columns and the rest will be set to default or NULL.
INSERT INTO Customer (CustomerID, CustomerName, LastName, Country, Phone)
VALUES (4, 'Shubh', 'Thakur', 'India','435356353'),
       (5, 'ema ', 'Chopra', 'Australia','435356353'),
       (6, 'sam', 'Tulasi', 'Sri lanka','435356353'),
       (7, 'Aditya', 'Arpan', 'Austria','435356353'),
       (8, 'Nishant. Salchichas S.A.', 'Jain', 'Spain','435356353');
       



-- use select to view the data in the table .
SELECT * FROM Customer;




-- COUNT(*) VS COUNT(column_name) => COUNT(*) counts all rows in the table including NULL values whereas COUNT(column_name) counts only the rows where the column value is not NULL.

select count(*) from Customer;
select count(age) from Customer;

select * from Customer where age is null;

select * from Customer where age > 0;       -- this also can skip the null values because null is not greater than 0 it is simply unknown value so it will not be included in the result set.

-- "<>" means not equal to in SQL. It is used to filter the data based on a condition where the value of a column is not equal to a specified value.
select * from Customer where age <> 21; -- skip null and  21 .





-- EXAMPLE  for integrity constraint 
CREATE TABLE IF NOT EXISTS Orders (
    OrderID INT ,
    CustomerID INT NOT NULL,
    OrderDate DATE DEFAULT '2025-07-16',
    UNIQUE(OrderID),
    check(OrderID > 5)
) ;

-- better way to add constraints is to add them after the column definition and give them a name so that we can identify them in case of errors and also we can drop them easily if required.


-- CREATE TABLE IF NOT EXISTS Orders (
--     OrderID INT ,
--     CustomerID INT NOT NULL ,
--     OrderDate DATE DEFAULT '2025-07-16',

--     constraint UNIQUE_orderid UNIQUE(OrderID),
--     constraint orderId_check check(OrderID > 5)
-- ) ;



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

