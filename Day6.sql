CREATE DATABASE day6_db ;
use day6_db ;
CREATE Table employees(
    emp_id INT ,
    emp_name VARCHAR(30) ,
    mobile BIGINT ,
    dept_name VARCHAR(30) ,
    salary INT
);
INSERT INTO employees (emp_id, emp_name, mobile, dept_name, salary) VALUES
(1, 'Shubham', 9876543210, 'Software', 10000),
(2, 'Aman', 9876543211, 'Software', 11000),
(3, 'Naveen', 9876543212, 'Software', 12000),
(4, 'Aditya', 9876543213, 'Finance', 15000),
(5, 'Nishant', 9876543214, 'Finance', 15000),
(6, 'Yukti', 9876543215, 'IT', 13000),
(7, 'Sahil', 9876543216, 'HR', 12000),
(8, 'Tushar', 9876543217, 'HR', 11000),
(9, 'Anukriti', 9876543218, 'IT', 14000),
(10, 'Ajay', 9876543219, 'Software', 11500);

SELECT * FROM employees;

-- Create views
CREATE View software_employees AS
SELECT * FROM employees WHERE dept_name = 'Software';

CREATE View employee_data_for_finance AS
SELECT emp_id , emp_name , salary FROM employees ;

-- all operations on views are same as that of tables , we can perform select , insert , update and delete operations on views .
SELECT * FROM employee_data_for_finance;
-- view occupy no space in the database , they are just a logical representation of the data in the table.
-- the above query is actually querying the underlying table, like this :
SELECT * FROM (SELECT emp_id , emp_name , salary FROM employees);

CREATE VIEW department_wise_salary AS
SELECT dept_name , sum(salary) as total_salary FROM employees GROUP BY dept_name;

-- with views we always get the latest data from the underlying tables , even if the data in the base table changes.
-- we can not alter the data in the view directly, we have to alter the data in the base table.


-- Union and Union All
create table student    
(
    stu_id int,
    name varchar(50), 
    email varchar(50),  
    city varchar(50)
 );
 
insert into student values(1,'Shashank','abc@gmail.com', 'lucknow');
insert into student values(2,'Rahul','abc1@gmail.com', 'mp');
insert into student values(3,'Amit','ab2@gmail.com', 'noida');
insert into student values(4,'Nikhil','abc3@gmail.com', 'bangalore');
insert into student values(5,'Sunny','ab4@gmail.com', 'bangalore');
    
create table student2
(
    stu_id int,
    name varchar(50), 
    email varchar(50), 
    city varchar(50)
 );


insert into student2 values(1,'Shashank','abc@gmail.com', 'lucknow');
insert into student2 values(6,'Anuj','abc5@gmail.com', 'mp');
insert into student2 values(8,'Mohit','ab7@gmail.com', 'noida');
insert into student2 values(10,'Sagar','abc10@gmail.com', 'bangalore');
insert into student2 values(5,'Sunny','ab4@gmail.com', 'bangalore');
    
select * from student2;


--- We are organizing an tournament between College-1 and College-2, we need details of all students from both college
select * from student
UNION
select * from student2;

--- how to use union all
select * from student
UNION ALL
select * from student2;

