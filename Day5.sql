
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


-- Query - Calculate the date wise rolling average of amazon sales
select * from amazon_sales_data;
