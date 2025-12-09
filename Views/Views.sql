----
-- View
----

-- view is a virtual table that presents data from one or more tables
-- it does not store data physically, but retrieves data dynamically when queried
-- views are used to simplify complex queries, enhance security by restricting access to specific data, and present data in a specific format
-- syntax to create a view:
-- CREATE VIEW view_name AS SELECT column1, column2, ... FROM table_name WHERE condition;



-- view of only indigo Airline flights
SELECT * FROM flights_data.flights;

CREATE View indo_airline_flights AS
SELECT * FROM flights_data.flights
WHERE airline = 'IndiGo';

-- to query the view
SELECT * FROM indo_airline_flights;

-- to see all views in the current database ==> sql treats views as tables
show tables ;

-- Creating a complex view for zomato database so that it helps us writing complex queries easily , and we don't have to write complex joins again and again

CREATE VIEW Joined_orders_details AS
SELECT name , order_id , amount , r_name , date , delivery_time , delivery_rating , restaurant_rating from zomato.orders t1
JOIN zomato.users t2
ON t1.user_id = t2.user_id
JOIN zomato.restaurants t3
ON t1.r_id = t3.r_id ;

-- find all orders with amount greater than 500 and delivery rating of 5 using the view
SELECT * FROM Joined_orders_details
WHERE amount > 500 AND delivery_rating = 5 ;

-- find top 2 restaurants based on amount spent in orders
SELECT r_name , SUM(amount) AS total_amount FROM Joined_orders_details
GROUP BY r_name
ORDER BY total_amount DESC LIMIT 2;

-- find month wise total amount spent on orders for each restaurant
SELECT r_name , MONTHNAME(date) AS order_month , SUM(amount) AS total_amount FROM Joined_orders_details
GROUP BY r_name , order_month
ORDER BY r_name , order_month ;

---
-- changing data in table to see if view reflects the changes
SELECT * from indo_airline_flights ; 
-- changing gource from banglore to bangaluru
UPDATE flights_data.flights
SET source = 'Bengaluru'
WHERE airline = 'IndiGo' AND source = 'Banglore' ;

-- querying the view again to see the changes
SELECT * from indo_airline_flights ;
-- we can see that the changes are reflected in the view as well

-- now making changes in the view to observe in the base table

----
-- changing delhi to new delhi in the view
UPDATE indo_airline_flights
SET destination = 'New Delhi'
WHERE destination = 'Delhi' ;

-- querying the base table to see the changes
SELECT * FROM flights_data.flights
WHERE airline = 'IndiGo' AND destination = 'New Delhi' ;
-- we can see that the changes made in the view are reflected in the base table as well

---
-- Read only view example ==> 
DELETE FROM joined_orders_details
WHERE order_id =1021;   -- this will give error as we cannot delete from a read only view


SELECT * FROM joined_orders_details;
