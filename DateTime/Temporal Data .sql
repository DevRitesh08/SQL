-- Creating and populating temporal_data table
-- creating a table UBER with columns for ride_id, customer_id,cab_id , start_time, end_time, and passenger_count
-- CREATE TABLE temp.UBER (
--     ride_id INT PRIMARY KEY,
--     customer_id INT,
--     cab_id INT,
--     start_time TIMESTAMP,
--     end_time TIMESTAMP,
--     passenger_count INT
-- );



-- Inserting sample data into UBER table
-- INSERT INTO temp.UBER (ride_id, customer_id, cab_id, start_time, end_time, passenger_count)
-- VALUES
--     (1, 101, 201, '2023-10-01 08:00:00', '2023-10-01 08:30:00', 2),
--         (2, 102, 202, '2023-10-01 09:00:00', '2023-10-01 09:15:00', 1),
--         (3, 103, 203, '2023-10-01 10:00:00', '2023-10-01 10:45:00', 3),
--         (4, FLOOR(RAND()*10000), 204, '2023-10-01 11:00:00', '2023-10-01 11:20:00', 2),
--         (28, FLOOR(RAND()*10000), 228, '2023-10-03 15:00:00', '2023-10-03 15:20:00', 1),
--         (29, FLOOR(RAND()*10000), 229, '2023-10-03 16:00:00', '2023-10-03 16:45:00', 4),
--         (98, FLOOR(RAND()*10000), 298, '2023-10-10 15:00:00', '2023-10-10 15:55:00', 4),
--         (99, FLOOR(RAND()*10000), 299, '2023-10-10 16:00:00', '2023-10-10 16:35:00', 2),
--         (100, FLOOR(RAND()*10000), 300, '2023-10-10 17:00:00', '2023-10-10 17:25:00', 3);

SELECT * FROM temp.UBER;


--------
---- Date and Time Functions
--------


-- 1. CURRENT_DATE: Returns the current date
SELECT CURRENT_DATE(); -- Returns the current date in 'YYYY-MM-DD' format from the system clock


-- 2. CURRENT_TIME: Returns the current time
SELECT CURRENT_TIME(); -- Returns the current time in 'HH:MM:SS' format from the system clock


-- 3. CURRENT_TIMESTAMP: Returns the current date and time 
SELECT CURRENT_TIMESTAMP(); -- Returns the current date and time in 'YYYY-MM-DD HH:MM:SS' format from the system clock


-- 4. NOW(): Returns the current date and time
SELECT NOW(); -- Returns the current date and time in 'YYYY-MM-DD HH:MM:



----
-- Extracting Date and Time Components
----


-- 1. DATE(): Extracts the date part from a datetime expression
-- 2. TIME(): Extracts the time part from a datetime expression

SELECT ride_id , DATE(start_time) AS ride_date, TIME(start_time) AS ride_time 
FROM temp.UBER;

-- 3. YEAR(), MONTH(), DAY(): Extracts the year, month, and day from a date respectively
-- 4. MONTHNAME() , DAYNAME() , WEEKDAY() , DAYOFWEEK : Extracts the month name, day name, and weekday index from a date respectively
SELECT ride_id, YEAR(start_time) AS ride_year, MONTH(start_time) AS ride_month, DAY(start_time) AS ride_day , MONTHNAME(start_time) AS ride_month_name, DAYNAME(start_time) AS ride_day_name, WEEKDAY(start_time) AS ride_weekday_index
FROM temp.UBER;

-- 5. HOUR(), MINUTE(), SECOND(): Extracts the hour, minute, and second from a time respectively
-- 6. QUARTER(): Extracts the quarter from a date
-- 7. WEEK(): Extracts the week number from a date
-- 8. WEEK() , WeekOfYear(): Extracts the week number of the year from a date .
-- 9. LAST_DAY(): Returns the last day of the month for a given date
-- 10. TIMESTAMPDIFF(): Returns the difference between two date or datetime expressions , in the specified unit (e.g., MINUTE, HOUR, DAY) . syntax: TIMESTAMPDIFF(unit, datetime_expr1, datetime_expr2)
SELECT ride_id, HOUR(start_time) AS ride_hour, MINUTE(start_time) AS Start_time_MINUTE , SECOND(start_time) AS Start_time_SECOND,
       QUARTER(start_time) AS ride_quarter, WEEK(start_time) AS ride_week_number,
       DAYOFYEAR(start_time) AS ride_day_of_year, DAYOFWEEK(start_time) AS ride_day_of_week ,WEEKOFYEAR(start_time) AS ride_week_of_year,
       LAST_DAY(start_time) AS last_day_of_month,
       TIMESTAMPDIFF(MINUTE, start_time, end_time) AS ride_duration_minutes
FROM temp.UBER;

