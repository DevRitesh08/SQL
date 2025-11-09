SELECT * FROM flights_data.flights

--------
---- Questions
--------




-- 1. Find the month with most number of flights
SELECT MONTHNAME(Date_of_Journey) AS Month, COUNT(*) AS Number_of_Flights
FROM flights_data.flights
GROUP BY MONTHNAME(Date_of_Journey)
ORDER BY COUNT(*) DESC LIMIT 1;


-- 2. Which week day has most costly flights
SELECT DAYNAME(Date_of_Journey) AS Weekday, AVG(Price) AS Average_Cost
FROM flights_data.flights
GROUP BY DAYNAME(Date_of_Journey)
ORDER BY Average_Cost DESC LIMIT 1;


-- 3. Find number of indigo flights every month
SELECT MONTHNAME(Date_of_Journey) AS `MONTH` , COUNT(*) AS `Number_of_Indigo_Flights`
FROM flights_data.flights
WHERE Airline = 'IndiGo'
GROUP BY MONTHNAME(Date_of_Journey);


-- 4. Find list of all flights that depart between 10AM and 2PM from Banglore to New Delhi
SELECT *
FROM flights_data.flights
WHERE Dep_Time >= '10:00:00' AND Dep_Time <= '14:00:00' AND Source = 'Banglore' AND Destination = 'New Delhi'  ;
-- or
SELECT *
FROM flights_data.flights
WHERE Dep_Time BETWEEN '10:00:00' AND '14:00:00' AND Source = 'Banglore' AND Destination = 'New Delhi'  ;


-- 5. Find the number of flights departing on weekends from Bangalore
SELECT COUNT(*) AS Weekend_Flights
FROM flights_data.flights
WHERE Source = 'Banglore' AND DAYNAME(Date_of_Journey) IN ('Sunday', 'Saturday');
-- or
SELECT COUNT(*) AS Weekend_Flights
FROM flights_data.flights
WHERE Source = 'Banglore' AND DAYOFWEEK(Date_of_Journey) IN (1, 7);  -- 1 = Sunday, 7 = Saturday


-----------------------------------------------------------------------------------------------------------------------------------
---------- Level Up - Advanced SQL Queries ----------
-----------------------------------------------------------------------------------------------------------------------------------


-- 6. Calculate the arrival time for all flights by adding the duration to the departure time.
-- creating a column that has both date and time for departure
ALTER TABLE flights_data.flights
ADD COLUMN Dep_DateTime DATETIME;

UPDATE flights_data.flights
SET Dep_DateTime = STR_TO_DATE(CONCAT(Date_of_Journey, ' ', Dep_Time), '%Y-%m-%d %H:%i');
-- review above two queries if already done
SELECT * FROM flights_data.flights ;
-- creating a column to store duration in minutes
ALTER TABLE flights_data.flights
ADD COLUMN Duration_in_Minutes INT after Duration;


SELECT duration,
REPLACE(SUBSTRING_INDEX(duration, ' ', 1), 'h', '')*60  +       -- cant use aliasing before hand because SQL executes linearly
CASE when   SUBSTRING_INDEX(duration, ' ', 1) = SUBSTRING_INDEX(duration, ' ', -1)     -- because some durations are like '2h 0m' then our simple reverse extraction will give 2 instead of 0 .
     THEN 0
     ELSE REPLACE(SUBSTRING_INDEX(duration, ' ', -1), 'm', '')
END AS Minutes
FROM flights_data.flights;

UPDATE flights_data.flights
SET Duration_in_Minutes = ( REPLACE(SUBSTRING_INDEX(duration, ' ', 1), 'h', '')*60  + 
CASE when   SUBSTRING_INDEX(duration, ' ', 1) = SUBSTRING_INDEX(duration, ' ', -1)   
     THEN 0
     ELSE REPLACE(SUBSTRING_INDEX(duration, ' ', -1), 'm', '')
END );

--review above two queries if already done
SELECT * FROM flights_data.flights ;
-- finally calculating arrival time
ALTER TABLE flights_data.flights
ADD COLUMN Arrival_Time DATETIME after Dep_DateTime;

UPDATE flights_data.flights
SET Arrival_Time = DATE_ADD(Dep_DateTime, INTERVAL Duration_in_Minutes MINUTE); 

-- review above two queries if already done
SELECT Airline, Dep_DateTime, Duration_in_Minutes, Arrival_Time
FROM flights_data.flights;
-- now lets finally extract the arrival time
SELECT TIME(arrival_time) AS Arrival_Time
FROM flights_data.flights;



-- 7. Calculate the arrival date for all the flights
SELECT DATE(arrival_time) AS Arrival_Date
FROM flights_data.flights;


-- 8. Find the number of flights which travel on multiple dates , i.e., the arrival date is different from the departure date.
SELECT COUNT(*) AS Multi_Date_Flights
FROM flights_data.flights
WHERE DATE(Dep_DateTime) != DATE(Arrival_Time);


-- 9. Calculate the average duration of flights between all city pairs.
SELECT Source, Destination, AVG(Duration_in_Minutes) AS Average_Duration_Minutes
FROM flights_data.flights
GROUP BY Source, Destination;
-- lets find out the avg duration in xh ym format
SELECT Source, Destination, TIME_FORMAT(SEC_TO_TIME(AVG(Duration_in_Minutes)*60), '%kh %m') AS Average_Duration
FROM flights_data.flights
GROUP BY Source, Destination;
-- or
SELECT Source, Destination ,
       CONCAT(AVG(Duration_in_Minutes) DIV 60, 'h ', AVG(Duration_in_Minutes) MOD 60, 'm') AS Average_Duration
FROM flights_data.flights
GROUP BY Source, Destination ;

-- 10. Find all flights which departed before midnight but arrived at their destination after midnight having 0 stop.
SELECT * FROM flights_data.flights
WHERE Total_Stops = 'non-stop' AND DAY(Date_of_Journey) < DAY(Arrival_Time) ;


-- 11. Find quarter wise number of flights for each airline
SELECT  Airline, QUARTER(Dep_DateTime), COUNT(*) AS number_of_flights 
FROM flights_data.flights
GROUP BY `Airline` ,  QUARTER(Dep_DateTime) ;


-- 12. Find the longest flight distance(between cities in terms of time) in India
SELECT Airline , Source , Destination , MAX(Duration_in_Minutes) AS Longest_Duration_Minutes
FROM flights_data.flights
GROUP BY Source, Destination , Airline
ORDER BY Longest_Duration_Minutes DESC LIMIT 1;


-- 13. Average time duration for flights that have 1 stop vs more than 1 stops
SELECT 
    CASE 
        WHEN Total_Stops = '1 stop' THEN '1 stop'
        else 'more than 1 stop'  -- Handle NULL or unexpected values
    END AS Stop_Category,
    TIME_FORMAT(SEC_TO_TIME(AVG(Duration_in_Minutes)*60),'%kh %im') AS 'avg_duration'
FROM flights_data.flights
WHERE Total_Stops != 'non-stop' AND Total_Stops IS NOT NULL
GROUP BY Stop_Category;
-- or using cte
WITH temp_table AS (SELECT *,
CASE 
	WHEN total_stops = '1 stop' THEN '1 stop'
    ELSE 'more than 1 stop'
END AS 'temp'
FROM flights_data.flights
WHERE Total_Stops != 'non-stop' AND Total_Stops IS NOT NULL)
SELECT temp,
TIME_FORMAT(SEC_TO_TIME(AVG(Duration_in_Minutes)*60),'%kh %im') AS 'avg_duration',
AVG(price) AS 'avg_price'
FROM temp_table
GROUP BY temp;



-- 14. Find all Air India flights in a given date range originating from Delhi ==> date range 2019-03-08 to 2019-03-18
SELECT * 
FROM flights_data.flights
where Source = 'delhi'  AND Airline = 'Air India' and 
DATE(Date_of_Journey) BETWEEN '2019-03-08' AND '2019-03-18' ;



-- 15. Find the longest flight of each airline
SELECT Airline , MAX(`Duration_in_Minutes`) AS max_duration
FROM flights_data.flights 
GROUP BY Airline
ORDER BY max_duration DESC ;
-- or
SELECT Airline , TIME_FORMAT(SEC_TO_TIME(MAX(Duration_in_Minutes)*60),'%kh %im') AS 'max_duration'
FROM flights_data.flights 
GROUP BY Airline 
ORDER BY MAX(Duration_in_Minutes)*60 DESC;


-- 16. Find all the pair of cities having average time duration > 3 hours
SELECT `Source` , `Destination` , TIME_FORMAT(SEC_TO_TIME(AVG(Duration_in_Minutes)*60),'%kh %im') AS 'average_duration'
FROM flights_data.flights
GROUP BY `Source` , `Destination`
HAVING AVG(Duration_in_Minutes) > 180;



----------------------------------------------------------------------------------------------------------------------------------
---------- Expert Level SQL Queries ----------
----------------------------------------------------------------------------------------------------------------------------------

-- 17. Make a weekday vs time grid showing frequency of flights from Banglore and Delhi ==> time slots : 00-06 , 06-12 , 12-18 , 18-24
SELECT  
FROM flights_data.flights
WHERE Source IN ('Banglore', 'Delhi')


SELECT * FROM flights_data.flights;
