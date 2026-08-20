create DATABASE IF NOT EXISTS xyz;

use xyz;

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

select (emp_name) from employee;