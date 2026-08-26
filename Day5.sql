
CREATE DATABASE day5_db ;
use day5_db ;



-- Window Functions
create table shop_sales_data
(
sales_date date,
shop_id varchar(5),
sales_amount int
);

insert into shop_sales_data values('2022-02-14','S1',200);
insert into shop_sales_data values('2022-02-15','S1',300);
insert into shop_sales_data values('2022-02-14','S2',600);
insert into shop_sales_data values('2022-02-15','S3',500);
insert into shop_sales_data values('2022-02-18','S1',400);
insert into shop_sales_data values('2022-02-17','S2',250);
insert into shop_sales_data values('2022-02-20','S3',300);

-- Total count of sales for each shop using window function
-- Working functions - SUM(), MIN(), MAX(), COUNT(), AVG()


-- If we only use Order by In Over Clause
select *,
       sum(sales_amount) over(order by sales_date ASC) as total_sum_of_sales
from shop_sales_data ;

-- If we only use Partition By
select *,
       sum(sales_amount) over(partition by shop_id) as total_sum_of_sales
from shop_sales_data ;

-- If we only use Partition By & Order By together
select *,
       sum(sales_amount) over(partition by shop_id order by sales_amount desc) as total_sum_of_sales
from shop_sales_data;

-- without using window function
select shop_id, sum(sales_amount) as total_sale_amount_by_shops from shop_sales_data group by shop_id;
select shop_id, count(*) as total_sale_count_by_shops from shop_sales_data group by shop_id;


create table amazon_sales_data
(
    sales_date date,
    sales_amount int
);

drop Table if exists amazon_sales_data;

insert into amazon_sales_data values('2022-08-21',500);
insert into amazon_sales_data values('2022-08-22',600);
insert into amazon_sales_data values('2022-08-19',300);
insert into amazon_sales_data values('2022-08-18',200);
insert into amazon_sales_data values('2022-08-25',800);


-- Query - Calculate the date wise rolling average of amazon sales
select * from amazon_sales_data;

select *,
       avg(sales_amount) over(order by sales_date) as rolling_avg
from amazon_sales_data;

-- but how ?
-- Because the window function is applied to each row of the result set, and the order by clause in the over() function specifies the order in which the rows are processed. The avg() function calculates the average of the sales_amount for all rows that have been processed up to that point, which gives us a rolling average.


select *,
       avg(sales_amount) over(order by sales_date) as rolling_avg,
       sum(sales_amount) over(order by sales_date) as rolling_sum
from amazon_sales_data;

-- Rank(), Row_Number(), Dense_Rank() window functions


insert into shop_sales_data values('2022-02-19','S1',400);
insert into shop_sales_data values('2022-02-20','S1',400);
insert into shop_sales_data values('2022-02-22','S1',300);
insert into shop_sales_data values('2022-02-25','S1',200);
insert into shop_sales_data values('2022-02-15','S2',600);
insert into shop_sales_data values('2022-02-16','S2',600);
insert into shop_sales_data values('2022-02-16','S3',500);
insert into shop_sales_data values('2022-02-18','S3',500);
insert into shop_sales_data values('2022-02-19','S3',300);

select *,
       row_number() over(partition by shop_id order by sales_amount desc) as row_num,
       rank() over(partition by shop_id order by sales_amount desc) as rank_val,
       dense_rank() over(partition by shop_id order by sales_amount desc) as dense_rank_val
from shop_sales_data;



create table employees
(
    emp_id int,
    salary int,
    dept_name VARCHAR(30)

);

insert into employees values(1,10000,'Software');
insert into employees values(2,11000,'Software');
insert into employees values(3,11000,'Software');
insert into employees values(4,11000,'Software');
insert into employees values(5,15000,'Finance');
insert into employees values(6,15000,'Finance');
insert into employees values(7,15000,'IT');
insert into employees values(8,12000,'HR');
insert into employees values(9,12000,'HR');
insert into employees values(10,11000,'HR');

select * from employees;


-- Query - get one employee from each department who is getting maximum salary (employee can be random if salary is same)


SELECT * , 
        ROW_NUMBER() OVER(PARTITION BY dept_name ORDER BY salary DESC) as row_num
from employees
WHERE row_num = 1;
-- its not working because we cannot use alias in the same select statement , so we can use a subquery to achieve this.
-- ❌ Doesn't work because row_num is created in the SELECT phase, but WHERE is processed before SELECT.

SELECT emp.* FROM    
    (SELECT * , 
        ROW_NUMBER() OVER(PARTITION BY dept_name ORDER BY salary DESC) as row_num
    from employees) as emp
WHERE emp.row_num = 1 ;

-- Query - get RANK one employee from each department who are getting maximum salary .
SELECT emp.* FROM    
    (SELECT * , 
        RANK() OVER(PARTITION BY dept_name ORDER BY salary DESC) as rank_num
    from employees) as emp
WHERE emp.rank_num = 1;

-- Query - get top 2 ranked employee from each department who are getting maximum salary . 
SELECT emp.* FROM    
    (SELECT * , 
        DENSE_RANK() OVER(PARTITION BY dept_name ORDER BY salary DESC) as dense_rank_num
    from employees) as emp
WHERE emp.dense_rank_num <= 2;




-- lag() and lead() functions :

-- LAG() function is used to access data from a previous row in the same result set without the use of a self-join. It allows you to retrieve values from a specified number of rows before the current row, based on a defined ordering.
-- Syntax: LAG(column_name, offset, default_value) OVER (ORDER BY column_name)           here offset is the number of rows back from the current row from which to retrieve a value. The default_value is optional and is returned when the offset goes beyond the scope of the partition.


-- LEAD() function is used to access data from a subsequent row in the same result set without the use of a self-join. It allows you to retrieve values from a specified number of rows after the current row, based on a defined ordering.
-- Syntax: LEAD(column_name, offset, default_value) OVER (ORDER BY column_name)  

 create table daily_sales
(
sales_date date,
sales_amount int
);


insert into daily_sales values('2022-03-11',400);
insert into daily_sales values('2022-03-12',500);
insert into daily_sales values('2022-03-13',300);
insert into daily_sales values('2022-03-14',600);
insert into daily_sales values('2022-03-15',500);
insert into daily_sales values('2022-03-16',200);

select * from daily_sales;

SELECT * , 
        LAG(sales_amount , 1) OVER(ORDER BY sales_date) as prevoius_day_sale
FROM daily_sales ;

-- Query - Calculate the differnce of sales with previous day sales .
-- Here null will be derived
SELECT * , 
        LAG(sales_amount , 1) OVER(ORDER BY sales_date) as previous_day_sale,
        sales_amount - LAG(sales_amount , 1) OVER(ORDER BY sales_date) as sales_diff
FROM daily_sales;

-- Here we can replace null with 0
-- to handle the NULL values in the previous day sales we can define the third parameter in the LAG function which will be used when there is no previous value available.
SELECT * , 
        LAG(sales_amount , 1 , 0) OVER(ORDER BY sales_date) as previous_day_sale,
        sales_amount - LAG(sales_amount , 1 , 0) OVER(ORDER BY sales_date) as sales_diff
FROM daily_sales;


-- Diff between lead and lag
select *,
      lag(sales_amount, 1) over(order by sales_date) as pre_day_sales
from daily_sales;

select *,
      lead(sales_amount, 1) over(order by sales_date) as next_day_sales
from daily_sales;




-- How to use Frame Clause  -> Rows Between 
-- It is used to define a subset of rows within a partition for the window function to operate on. The frame clause allows you to specify a range of rows relative to the current row, which can be useful for calculating running totals, moving averages, and other aggregate functions.

SELECT * FROM daily_sales ;


SELECT * ,
        sum(sales_amount) OVER(ORDER BY sales_date ROWS BETWEEN 1 PRECEDING and 1 FOLLOWING) as prev_plus_next_sales 
FROM daily_sales;



-- getting sum of sales amount of preceding day and current day sales amount for each day .
SELECT * , 
        sum(sales_amount) OVER(ORDER BY sales_date ROWS BETWEEN 1 PRECEDING and current ROW) as prev_plus_current_sales
FROM daily_sales;

-- getting sum of sales amount of previous day and next day sales amount for each day excluding current day.
-- exclude is not supported by all databases , so it may not work in some SQL environments.
SELECT * ,
        sum(sales_amount) OVER(ORDER BY sales_date ROWS BETWEEN 1 PRECEDING and 1 FOLLOWING EXCLUDE CURRENT ROW) as prev_plus_next_sales_excluding_current
FROM daily_sales;
-- other way
SELECT * ,
        sum(sales_amount) OVER(ORDER BY sales_date ROWS BETWEEN 1 PRECEDING and 1 FOLLOWING ) - sales_amount as prev_plus_next_sales_excluding_current
FROM daily_sales;

-- unbounded
-- getting sum of all preceding day with the current day sales ( Running sum ) .
SELECT * ,
        sum(sales_amount) OVER(ORDER BY sales_date ROWS BETWEEN UNBOUNDED PRECEDING and CURRENT ROW) as prev_plus_next_sales_excluding_current
FROM daily_sales;

-- getting sum of sales from current day to all the following days . 
SELECT * ,
        sum(sales_amount) OVER(ORDER BY sales_date ROWS BETWEEN CURRENT ROW AND UNBOUNDED FOLLOWING) as prev_plus_next_sales_excluding_current
FROM daily_sales;

--both unbounded
SELECT * ,
        sum(sales_amount) OVER(ORDER BY sales_date ROWS BETWEEN UNBOUNDED PRECEDING and UNBOUNDED FOLLOWING) as prev_plus_next_sales_excluding_current
FROM daily_sales;






-- How to work with Range Between
-- The RANGE BETWEEN clause is used in SQL window functions to define a range of values based on the ordering of the rows. It allows you to specify a range of values relative to the current row, which can be useful for calculating running totals, moving averages, and other aggregate functions based on a specific range of values.
-- syntax: RANGE BETWEEN value PRECEDING AND value FOLLOWING
-- example: RANGE BETWEEN 100 PRECEDING AND 200 FOLLOWING :  it will include all rows where the value of the ordering column is between 100 less than the current row's value and 200 more than the current row's value.

 select *,
      sum(sales_amount) over(order by sales_amount range between 100 preceding and 200 following) as prev_plus_next_sales_sum
from daily_sales;
-- so here it will include all rows where the value of the ordering column is between 100 less than the current row's value and 200 more than the current row's value. So for example if we have a row with sales_amount = 500, then it will include all rows where sales_amount is between 400 and 700 (500-100 to 500+200).

-- Calculate the running sum for a week
-- Calculate the running sum for a month
insert into daily_sales values('2022-03-20',900);
insert into daily_sales values('2022-03-23',200);
insert into daily_sales values('2022-03-25',300);
insert into daily_sales values('2022-03-29',250);


select * from daily_sales;

select *,
       sum(sales_amount) over(order by sales_date range between interval '6' day preceding and current row) as running_weekly_sum
from daily_sales;

-- here, the RANGE BETWEEN INTERVAL '6' DAY PRECEDING AND CURRENT ROW clause specifies that the window frame should include all rows where the sales_date is within the last 6 days (including the current row's date). This allows us to calculate the running sum of sales_amount for each day, considering only the sales from the past week.

-- why interval and day are used : The INTERVAL keyword is used to specify a time-based range, and '6' DAY indicates that we want to include rows from 6 days before the current row up to the current row. This is useful for calculating rolling averages or sums over a specific time period.


