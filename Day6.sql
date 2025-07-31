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