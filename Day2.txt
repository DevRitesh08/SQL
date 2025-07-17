
CREATE DATABASE if not exists Day2_db ;

use Day2_db;
CREATE table if not exists employee (
    emp_id int ,

    emp_name varchar(50) ,
    salary int ,
    city varchar(20)
)

INSERT into employee VALUES(1, 'Shubham', 50000, 'Delhi'),
       (2, 'Aman', 60000, 'Mumbai'),
       (3, 'Naveen', 55000, 'Bangalore');

SELECT * FROM employee ;


-- Add new column to the table
alter table employee add dob date DEFAULT '2025-07-17' ;

-- modify existing column in a table or change its data type
ALTER Table employee modify column emp_name VARCHAR(100) ;


-- delete existing column from a table
alter Table employee drop column dob ;

-- rename existing column in a table
alter table employee rename column emp_name to employee_name ;

-- rename the table
alter table employee rename to emp_details ;
 
-- add unique integrity constraint to a column .
alter table emp_details add constraint unique_emp_id unique(emp_id);

INSERT into emp_details values(1, 'Shubh', 5000, 'Delhi') ;

-- drop the unique constraint
alter table emp_details drop constraint unique_emp_id ; -- that is why it is important to give alias to the constraints
INSERT into emp_details values(1, 'Shubh', 5000, 'Delhi') ;





--- create table with primary key 

--- Method 1 (not recommended)
-- CREATE table if not exists student(
--     std_id  int , 
--     std_name varchar(50) ,
--     std_age int ,
--     primary key(std_id)
-- );

-- Method 2 (better approach)
CREATE TABLE IF NOT EXISTS student (
    std_id INT,
    std_name VARCHAR(50),
    std_age INT,
    CONSTRAINT pk_std_id PRIMARY KEY(std_id)
);

insert into student values(1, 'Shubham', 23),
       (2, 'Aman', 21),
       (3, 'Naveen', 24),
       (4, 'Aditya', 21),
       (5, 'Nishant', 22);

insert into student values(1, 'Shubh', 23); -- error will be thrown as primary key cannot have duplicate values
insert into student values(NULL, 'Shubh', 23); -- this will also throw an error as primary key cannot have NULL values

-- Difference between primary key and unique constraint 
alter table student add constraint uni_std_name UNIQUE(std_name); -- add unique constraint to std_name column

INSERT INTO student VALUES(6 , 'aman', 21); -- error will be thrown as unique constraint is violated

INSERT into student VALUES(7, NULL , 53) --no error since name has unique constraint that can take null .

INSERT into student VALUES(8, NULL, 22); -- no error as NULL is not considered duplicate

SELECT * FROM student;






-- create table with foreign key constraint (rest will be discussed ahead)

create table employee (
    cust_id int ,
    cust_name varchar(50) ,
    age int ,
    constraint pk PRIMARY KEY(cust_id)
)

create table orders (
    order_id int ,
    order_no int ,
    customer_id int ,
    constraint pk PRIMARY KEY(order_id) ,
    constraint fk FOREIGN KEY(customer_id) REFERENCES employee(cust_id)
)



-- difference between drop and truncate command

select * from student;
TRUNCATE Table student ; -- truncate command will delete the data but preserve the schema of table .
DROP table student ; -- drop command completely deletes the table .



use day2_db ;



-- operations with select command
create table teachers(
    teacher_id int ,
    teacher_name varchar(50) ,
    salary int , 
    teacher_Subject varchar(25) , 
    city varchar(50)
)

INSERT into teachers VALUES(1,'rahul' , 23000 , 'maths' , 'jaipur') , (2 , 'aditi' , 25000 , 'physics' , 'surat') , (3 , 'tushar' , 34000 , 'biology' , 'surat') , (4,'anukriti' , 33000 , 'DSA' , 'jaipur') , (5 , 'ajay' , 28000 , 'maths' , 'indore') ;

SELECT * from teachers ;

-- counting the total number of records .
SELECT COUNT(*) from teachers ; --normal way
SELECT COUNT(*) as total_records FROM teachers ; -- using alias


-- Display all columns in the final result .
SELECT * from teachers ;

-- Display specific columns in the final result .
SELECT teacher_name , salary from teachers ;
SELECT teacher_name as Name, salary as Salary from teachers ; -- alias for multiple columns .

-- print distinct city from the table
SELECT DISTINCT(city) as distinct_city  FROM teachers;

-- how many distinct city in table
SELECT COUNT(DISTINCT(city)) as distinct_city_count FROM teachers ; 





use day2_db ;
select * from teachers ;


-- increment salary of each teacher by 20% and display the result .

SELECT  teacher_id ,
        teacher_name ,
        salary as old_salary ,
        (salary + salary*0.2) as new_salary
FROM teachers;





-- Update command

UPDATE teachers SET city = 'jaipur' ;

-- update salary of each teacher by 20%  .
UPDATE teachers SET salary = salary + salary*0.2 ;




-- how to filter the data using where clause
SELECT * FROM teachers WHERE teacher_id >= 2;

-- update the salary of teachers whose subject is maths to 50000
UPDATE teachers set salary = 50000 WHERE teacher_subject = 'maths' ;





-- Delete command

-- delete the record of teacher whose id is 1
DELETE FROM teachers WHERE teacher_id = 1; 
