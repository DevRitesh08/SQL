
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
       sum(sales_amount) over(order by sales_amount desc) as total_sum_of_sales
from shop_sales_data;

-- If we only use Partition By
select *,
       sum(sales_amount) over(partition by shop_id) as total_sum_of_sales
from shop_sales_data;

-- If we only use Partition By & Order By together
select *,
       sum(sales_amount) over(partition by shop_id order by sales_amount desc) as total_sum_of_sales
from shop_sales_data;

select shop_id, count(*) as total_sale_count_by_shops from shop_sales_data group by shop_id;


create table amazon_sales_data
(
    sales_data date,
    sales_amount int
);

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
SELECT emp.* FROM    
    (SELECT * , 
        ROW_NUMBER() OVER(PARTITION BY dept_name ORDER BY salary DESC) as row_num
    from employees) as emp
WHERE emp.row_num = 1;

-- Query - get one employee from each department who are getting maximum salary .
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




-- lag and lead :

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
SELECT * FROM daily_sales ;


SELECT * ,
        sum(sales_amount) OVER(ORDER BY sales_date ROWS BETWEEN 1 PRECEDING and 1 FOLLOWING) as prev_plus_next_sales 
FROM daily_sales;
