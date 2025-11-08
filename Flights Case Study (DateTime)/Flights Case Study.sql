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
SELECT WEEKDAY(Date_of_Journey) AS Weekday, COUNT(*) AS Number_of_Flights
FROM flights_data.flights
GROUP BY WEEKDAY(Date_of_Journey)
ORDER BY COUNT(*) DESC LIMIT 1;


-- 3. Find number of indigo flights every month
SELECT MONTHNAME(Date_of_Journey) AS `MONTH` , COUNT(*) AS `Number_of_Indigo_Flights`
FROM flights_data.flights
WHERE Airline = 'IndiGo'
GROUP BY MONTHNAME(Date_of_Journey);


-- 4. Find list of all flights that depart between 10AM and 2PM from Delhi to Banglore
SELECT * 
FROM flights_data.flights
WHERE ( Dep_Time BETWEEN 10:00:00 AND 14:00:00 ) AND ( Source = 'New Delhi' AND Destination = 'Banglore' ) ;