--------
---- using Group by 
--------
-- It returns one row per group




SELECT branch, AVG(cgpa) as average_cgpa 
FROM temp.students GROUP BY branch;




--------
---- using Window Functions
--------
-- It returns one row per original row




SELECT branch,AVG(cgpa) OVER (PARTITION BY branch) as average_cgpa 
FROM temp.students;  -- this will give average cgpa for each student in that branch but repeated for all students of that branch
-- better way to see it
SELECT *, AVG(cgpa) OVER (PARTITION BY branch) as average_cgpa 
FROM temp.students;
-- To get distinct branch with average cgpa use DISTINCT
SELECT DISTINCT branch,AVG(cgpa) OVER (PARTITION BY branch) as average_cgpa 
FROM temp.students;



--------
---- Aggregate Functions with over()
--------



---- Question ----
-- find all students who have cgpa greater than average cgpa of their branch .
SELECT *,AVG(cgpa) OVER() 
FROM temp.students; -- gives overall average cgpa of all students, not partitioned by branch

SELECT *,AVG(cgpa) OVER(PARTITION BY branch) 
FROM temp.students;

SELECT * FROM temp.students s
WHERE cgpa > (SELECT AVG(cgpa) 
FROM temp.students 
WHERE branch = s.branch);


---- Question ----
-- find the lowest and highest cgpa. 
SELECT *, MIN(cgpa) OVER(), MAX(cgpa) OVER() 
FROM temp.students;
-- we can observe that data got sorted based on cgpa by default but it's not guaranteed it depends on db engine.
-- we can use order by clause in over() to get sorted data based on some column like id

-- findding lowest and highest cgpa per branch
SELECT *, MIN(cgpa) OVER(PARTITION BY branch), MAX(cgpa) OVER(PARTITION BY branch)
FROM temp.students;
-- printing it like group by 
SELECT DISTINCT branch, MIN(cgpa) OVER(PARTITION BY branch) as min_cgpa, MAX(cgpa) OVER(PARTITION BY branch) as max_cgpa
FROM temp.students;


---- Question ----
-- Find all the students who have cgpa greater than average cgpa of their respective branch.
 SELECT * , AVG(cgpa) OVER(PARTITION BY branch) as avg_cgpa_branch
 FROM temp.students;
 -- now filtering those students who have cgpa > avg_cgpa_branch
SELECT * FROM (SELECT * , AVG(cgpa) OVER(PARTITION BY branch) as avg_cgpa_branch
FROM temp.students) t
WHERE t.cgpa > t.avg_cgpa_branch;



--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------


------------------------------------  RANK() , DENSE_RANK() and ROW_NUMBER()



--------
---- Rank
--------
-- RANK() function assigns a unique rank to each distinct value in the ordered partition of a result set , starting from 1 for the highest value.
-- If there are ties (i.e., multiple rows with the same value), they receive the same rank, and the next rank(s) are skipped.
-- For example, if two rows are tied for rank 1, both will receive rank 1, and the next rank assigned will be 3.
-- syntax: RANK() OVER (PARTITION BY column_name ORDER BY column_name ASC|DESC)



---- Question ---
-- Find the rank of students based on their cgpa .
SELECT *, RANK() OVER(ORDER BY cgpa DESC) as rank_cgpa
FROM temp.students;


---- Question ---
-- Find the rank of students within each branch based on their cgpa .
SELECT *, RANK() OVER(PARTITION BY branch ORDER BY cgpa DESC) as rank_cgpa_branch
FROM temp.students;



--------
---- Dense Rank
--------
-- DENSE_RANK() function assigns a unique rank to each distinct value in the ordered partition of a result set , starting from 1 for the highest value.
-- If there are ties (i.e., multiple rows with the same value), they receive the same rank, but unlike RANK(), the next rank is not skipped.
-- For example, if two rows are tied for rank 1, both will receive rank 1, and the next rank assigned will be 2.
-- syntax: DENSE_RANK() OVER (PARTITION BY column_name ORDER BY column_name ASC|DESC)



---- Question ---
-- Find the rank of students based on their cgpa .
SELECT *, DENSE_RANK() OVER(ORDER BY cgpa DESC) as rank_cgpa
FROM temp.students;


---- Question ---
-- Find the rank of students within each branch based on their cgpa .
SELECT *, DENSE_RANK() OVER(PARTITION BY branch ORDER BY cgpa DESC) as rank_cgpa_branch
FROM temp.students;



--------
---- ROW_NUMBER
--------
-- ROW_NUMBER() function assigns a unique sequential integer to rows within a partition of a result set, starting from 1 for the first row in each partition.
-- Unlike RANK() and DENSE_RANK(), ROW_NUMBER() does not consider ties; each row gets a unique number, even if they have the same values in the ordered column.
-- syntax: ROW_NUMBER() OVER (PARTITION BY column_name ORDER BY column_name ASC|DESC)



---- Question ---
-- Find the row number of students based on their cgpa .
SELECT *, ROW_NUMBER() OVER(ORDER BY cgpa DESC) as row_num_cgpa
FROM temp.students;
-- Here even if two students have same cgpa they will get different row numbers.
-- can also be done like this
SELECT *, ROW_NUMBER() OVER() as row_num_cgpa
FROM temp.students


---- Question ---
-- Find the row number of students within each branch based on their cgpa .
SELECT *, ROW_NUMBER() OVER(PARTITION BY branch ORDER BY cgpa DESC) as row_num_cgpa_branch
FROM temp.students;


---- Question ---
-- get the roll number of students where firstly the branch then - with row_number .
SELECT *, 
CONCAT(branch , '-' ,ROW_NUMBER() OVER(PARTITION BY branch ORDER BY name ASC)) as roll_num
FROM temp.students;
-- Here the roll number will be like CSE-1 , CSE-2 , ECE-1 , ECE-2 based on alphabetical order of names in each branch.
-- here if do not use ORDER BY name then the order will be based on how data is stored in db which is not guaranteed to be same always and depends on db engine.


---- Question ---
-- get the top 2 students of each branch based on cgpa .
SELECT * FROM (
    SELECT *, ROW_NUMBER() OVER(PARTITION BY branch ORDER BY cgpa DESC) as row_num_cgpa_branch
    FROM temp.students
) t
WHERE t.row_num_cgpa_branch <= 2;


---- Question ---
-- get the top 2 customers of each month based on total amount spent , in orders table of zomato database.
SELECT * FROM (SELECT MONTHNAME(date) as month_name, user_id , SUM(amount) as total_amount , RANK() OVER(PARTITION BY MONTHNAME(date) ORDER BY SUM(amount) DESC) as month_rank
                FROM zomato.orders
                GROUP BY MONTHNAME(date) , user_id 
                ORDER BY month_name , month_rank) t
WHERE t.month_rank < 3
ORDER BY month_name DESC;



--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------


------------------------------------  FIRST_VALUE() , LAST_VALUE() and NTH_VALUE()
-- they are used to get specific values from ordered set of rows within a partition, they won't work properly without ORDER BY .
-- ordering is done based on some column(s) specified in ORDER BY clause inside OVER() .




--------
---- FIRST_VALUE()
--------
-- FIRST_VALUE() function returns the first value in an ordered set of values.
-- It is often used in conjunction with the OVER() clause to define a window or partition of data.
-- syntax: FIRST_VALUE(column_name) OVER (PARTITION BY column_name ORDER BY column_name ASC|DESC)



---- Question ----
-- find the student with max cgpa
SELECT * , FIRST_VALUE(name) OVER(ORDER BY cgpa DESC) as max_cgpa_student FROM temp.students ;


---- Question ----
-- find the student with max cgpa in each branch
SELECT * , FIRST_VALUE(name) OVER(PARTITION BY branch ORDER BY cgpa DESC) as max_cgpa_student_branch FROM temp.students ;



--------
---- LAST_VALUE()
--------
-- LAST_VALUE() function returns the last value in an ordered set of values.
-- It is often used in conjunction with the OVER() clause to define a window or partition of data.
-- syntax: LAST_VALUE(column_name) OVER (PARTITION BY column_name ORDER BY column_name ASC|DESC)



---- Question ----
-- find the student with min cgpa
SELECT * , LAST_VALUE(name) OVER(ORDER BY cgpa ASC) as min_cgpa_student FROM temp.students ; -- this may not work as expected because window frame by default is RANGE BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW ==>> can also change the order to DESC and use FIRST_VALUE instead of LAST_VALUE like below
SELECT * , FIRST_VALUE(name) OVER(ORDER BY cgpa DESC) as min_cgpa_student FROM temp.students ;

-- to make it work as expected we need to change the window frame to UNBOUNDED FOLLOWING 
SELECT * , LAST_VALUE(name) OVER(ORDER BY cgpa ASC ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) as min_cgpa_student FROM temp.students ;


---- Question ----
-- find the student with min cgpa in each branch
SELECT * , LAST_VALUE(name) OVER(PARTITION BY branch ORDER BY cgpa ASC ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) as min_cgpa_student_branch FROM temp.students ;



--------
---- LAST_VALUE()
--------
-- NTH_VALUE() function returns the nth value in an ordered set of values.
-- It is often used in conjunction with the OVER() clause to define a window or partition of data.
-- syntax: NTH_VALUE(column_name, n) OVER (PARTITION BY column_name ORDER BY column_name ASC|DESC)



---- Question ----
-- find the student with 2nd highest cgpa 
SELECT * , NTH_VALUE(name, 2) OVER(ORDER BY cgpa DESC) as second_highest_cgpa_student FROM temp.students ;


-- checking total number of students in each branch
-- SELECT branch , count(*) as total_students FROM temp.students GROUP BY branch


---- Question ----
-- find the student with 16th highest cgpa in each branch (then civil branch will have NULL as there are only 15 students in civil branch)
SELECT * , NTH_VALUE(name, 16) OVER(PARTITION BY branch ORDER BY cgpa DESC ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) as sixteenth_highest_cgpa_student_branch FROM temp.students ;



----------------------------------------------------------------------------------------------------------------------------------- QUESTION's


---- Question ----
-- Print the topper name , branch and cgpa for each branch.
SELECT name , branch , cgpa FROM (
                SELECT * , FIRST_VALUE(name) OVER(PARTITION BY branch ORDER BY cgpa DESC) as topper_name,
                FIRST_VALUE(branch) OVER(PARTITION BY branch ORDER BY cgpa DESC) as topper_branch
                FROM temp.students
) t
WHERE t.topper_name = t.name;
-- or simply
SELECT name , branch , cgpa FROM (
                    SELECT 
                    name,
                    branch,
                    cgpa,
                    FIRST_VALUE(name) OVER (PARTITION BY branch ORDER BY cgpa DESC) AS topper_name
                    FROM temp.students
) t
WHERE t.topper_name = t.name;   -- but not good for cases where name are duplicate


---- Question ----
-- Find the least scorer in each branch 
SELECT name , branch , cgpa FROM (
                SELECT * , LAST_VALUE(name) OVER(PARTITION BY branch ORDER BY cgpa DESC 
                                                    ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) as topper_name ,
                LAST_VALUE(branch) OVER(PARTITION BY branch ORDER BY cgpa DESC 
                                                ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) as topper_branch
                FROM temp.students
) t
WHERE t.topper_name = t.name;
-- here we can observe that the query is too big and we are repeating the part in over function so here we can also write it as :- 
SELECT name , branch , cgpa FROM (
                SELECT * , LAST_VALUE(name) OVER w as 'topper_name' ,
                LAST_VALUE(branch) OVER w as 'topper_branch'
                FROM temp.students
) t
WHERE t.topper_name = t.name
WINDOW w AS (PARTITION BY branch ORDER BY cgpa DESC 
                ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED);

-- The error message near ) at line 8 happens because:

-- You placed the WINDOW clause after the WHERE clause, which is not allowed in SQL syntax.

-- In standard SQL, the correct order is:

-- SELECT
-- FROM
-- WHERE
-- GROUP BY
-- HAVING
-- ORDER BY
-- WINDOW

SELECT name, branch, cgpa
FROM (
    SELECT *,
        LAST_VALUE(name) OVER w AS topper_name,
        LAST_VALUE(branch) OVER w AS topper_branch
    FROM temp.students
    WINDOW w AS (
        PARTITION BY branch 
        ORDER BY cgpa DESC
        ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING
    )
) t
WHERE t.topper_name = t.name;


---- Question ----
-- Find the student name , branch and cgpa who is just above the average cgpa of their branch.
SELECT * FROM (
    SELECT *,
    AVG(cgpa) OVER(PARTITION BY branch) as avg_cgpa_branch,
    RANK() OVER(PARTITION BY branch ORDER BY cgpa DESC) as rank_cgpa_branch
    FROM temp.students
) t
WHERE t.cgpa > t.avg_cgpa_branch AND t.rank_cgpa_branch = 1 + (SELECT COUNT(*) 
                                                                FROM temp.students s2 
                                                                WHERE s2.branch = t.branch AND s2.cgpa <= t.avg_cgpa_branch
                                                                );




--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------


------------------------------------  LEAD() and LAG()




--------
---- LAG
--------
-- LAG() function provides access to a row at a specified physical offset that comes before the current row within the partition.
-- It is often used in conjunction with the OVER() clause to define a window or partition of data.
-- syntax: LAG(column_name, offset, default_value) OVER (PARTITION BY column_name ORDER BY column_name ASC|DESC)
-- offset is optional and default is 1
-- default_value is optional and default is NULL




---- Question ----
-- Find the previous cgpa of each student
SELECT * , LAG(cgpa) OVER(ORDER BY id) from temp.students;




--------
---- LEAD
--------
-- LEAD() function provides access to a row at a specified physical offset that follows the current row within the partition.
-- It is often used in conjunction with the OVER() clause to define a window or partition of data.
-- syntax: LEAD(column_name, offset, default_value) OVER (PARTITION BY column
-- offset is optional and default is 1
-- default_value is optional and default is NULL




---- Question ----
-- Find the next cgpa of each student
SELECT * , LAG(cgpa) OVER(ORDER BY id) AS lag_cgpa_by_1, lead(cgpa) OVER(ORDER BY id) AS lead_cgpa_by_1 from temp.students;


---- Question ----
-- Find the previous and next cgpa of each student in their respective branch
SELECT * , LAG(cgpa) OVER(PARTITION BY branch ORDER BY id) AS lag_cgpa_by_1, lead(cgpa) OVER(PARTITION BY branch ORDER BY id) AS lead_cgpa_by_1 from temp.students;



----------------------------------------------------------------------------------------------------------------------------------- QUESTION's


---- Question ----
-- Find the MoM revenue growth of zomato 
SELECT MONTHNAME(date) , SUM(amount) , ((SUM(amount) - LAG( SUM(amount)) OVER(ORDER BY MONTH(date)) ) / LAG( SUM(amount)) OVER(ORDER BY MONTH(date)) ) * 100 AS 'MoM revanue'
FROM zomato.orders
GROUP BY MONTHNAME(date) , MONTH(date) 
ORDER BY MONTH(date) 


---- Question ----
-- Find cummulative sum in students table for cgpa 




------------------------------------  RANKING 




SELECT * FROM temp.ipl_complete ;

---- Question ----
-- Find the rank (dense_rank) of top 5 players of each team based on total runs scored .
SELECT * FROM (
    SELECT  BattingTeam , batter , SUM(batsman_run) as total_runs , DENSE_RANK() OVER(PARTITION BY BattingTeam ORDER BY SUM(batsman_run) DESC) as 'rank_in_team'
    FROM temp.ipl_complete
    GROUP BY BattingTeam , batter
) t
WHERE t.rank_in_team <= 5
ORDER BY BattingTeam , rank_in_team;




------------------------------------  Cumulative Sum 
-- Cumulative sum is the running total of a sequence of numbers , updated each time a new number is added to the sequence.
-- It is calculated by adding each number in the sequence to the sum of all previous numbers.




---- Question ----
-- Find career runs of 'V Kohli' after 50th , 100th , 150th and 200th match .
SELECT * FROM 
                (SELECT CONCAT("Match-" , ROW_NUMBER() OVER(ORDER BY ID)) as 'Match_no' , SUM(batsman_run) as 'Runs_Scored' , SUM(SUM(batsman_run)) OVER(ORDER BY ID ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) as 'Career_Runs'
                FROM temp.ipl_complete
                WHERE batter = 'V Kohli' 
                GROUP BY ID ) t
WHERE t.Match_no IN ('Match-50' , 'Match-100' , 'Match-150' , 'Match-200');


---- Question ----
-- Find total number of matches played by virat kohli to reach 5000 runs .
SELECT * FROM 
                (SELECT CONCAT("Match-" , ROW_NUMBER() OVER(ORDER BY ID)) as 'Match_no' , SUM(batsman_run) as 'Runs_Scored' , SUM(SUM(batsman_run)) OVER(ORDER BY ID ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) as 'Career_Runs'
                FROM temp.ipl_complete
                WHERE batter = 'V Kohli' 
                GROUP BY ID ) t
WHERE t.Career_Runs >= 5000
ORDER BY t.Career_Runs
LIMIT 1;




------------------------------------  Cumulative Average
-- Cumulative average is the running average of a sequence of numbers , updated each time a new number is added to the sequence.
-- It is calculated by adding each number in the sequence to the sum of all previous numbers and dividing by the count of numbers in the sequence up to that point.




---- Question ----
-- Find cumulative average of runs scored by 'V Kohli' after each match .
SELECT * FROM 
                (SELECT CONCAT("Match-" , ROW_NUMBER() OVER(ORDER BY ID)) as 'Match_no' ,
                        SUM(batsman_run) as 'Runs_Scored' ,
                        SUM(SUM(batsman_run)) OVER w as 'Career_Runs' ,
                        AVG(SUM(batsman_run)) OVER w as 'Cumulative_Average_Runs' 
                FROM temp.ipl_complete
                WHERE batter = 'V Kohli' 
                GROUP BY ID 
                WINDOW w as (ORDER BY ID ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW)      -- useful when  
                ) t




------------------------------------  Running Average

-- Running average (also known as *moving average*) is a statistical technique that calculates the average value of a dataset over a moving window of consecutive data points.
-- The window size determines the number of data points used to calculate the average, and as the window moves forward in time, the average is recalculated using the new data points and dropping the oldest one. This means that the running average is continuously updated and reflects the most recent trends in the data.
-- For example, a running average of a batsman's runs scored over a window of 10 matches will calculate the average runs scored in the last 10 matches, then move the window one match forward and recalculate the average for the new set of 10 matches, and so on.
-- Running averages are often used in finance, economics, and engineering to smooth out noisy or volatile data series, and to identify trends or patterns that may be obscured by random fluctuations in the data.




---- Question ----
-- Find running average of runs scored by 'V Kohli' after each match with a window of 10 matches.
 SELECT * FROM 
                (SELECT CONCAT("Match-" , ROW_NUMBER() OVER(ORDER BY ID)) as 'Match_no' ,
                        SUM(batsman_run) as 'Runs_Scored' ,
                        SUM(SUM(batsman_run)) OVER w as 'Career_Runs' ,
                        AVG(SUM(batsman_run)) OVER w as 'Cumulative_Average_Runs' ,
                        AVG(SUM(batsman_run)) OVER(ORDER BY ID ROWS BETWEEN 9 PRECEDING AND CURRENT ROW) as 'Running_Average_Runs'
                FROM temp.ipl_complete
                WHERE batter = 'V Kohli' 
                GROUP BY ID 
                WINDOW w as (ORDER BY ID ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW)      -- useful in understanding player performance over time
                ) t
                -- plotted this in window_function.ipynb notebook for better understanding




------------------------------------  Percentage of Total
-- Percentage of total is a statistical measure that expresses the proportion of a specific value or category in relation to the overall total of a dataset.
-- It is calculated by dividing the specific value or category by the total value of the dataset and multiplying by 100 to express the result as a percentage.
-- For example, in a sales dataset, the percentage of total sales for a particular product can be calculated by dividing the sales of that product by the total sales of all products and multiplying by 100.




---- Question ----
-- Find the percentage of total sales for each food item in a restaurant with r_id = 1 .
SELECT f_name , (Total_Sales / SUM(Total_Sales) OVER () )*100 AS 'percent_of_total' FROM 
(SELECT f_id , SUM(amount) AS 'Total_Sales' FROM zomato.orders t1
JOIN zomato.order_details t2 
ON t1.order_id = t2.order_id
WHERE r_id = 1          -- just change r_id to find for different restaurant
GROUP BY f_id ) t
JOIN zomato.food f
ON t.f_id = f.f_id
ORDER BY percent_of_total DESC;




------------------------------------  Percentage Change 
-- Percentage change is a statistical measure that expresses the relative change between two values as a percentage.
-- It is calculated by subtracting the old value from the new value, dividing the result by the old value, and multiplying by 100 to express the result as a percentage.
-- For example, in a sales dataset, the percentage change in sales from one month to the
-- It is commonly used to analyze changes in financial data, such as stock prices, sales figures, or economic indicators, over a specific period of time.




---- Question ----
-- Find the MoM percentage change in sales for a restaurant with r_id = 1 .
SELECT MONTHNAME(t1.date) AS month_name,
       SUM(t1.amount) AS total_sales,
       ((SUM(t1.amount) - LAG(SUM(t1.amount)) OVER(ORDER BY MONTH(t1.date))) / NULLIF(LAG(SUM(t1.amount)) OVER(ORDER BY MONTH(t1.date)), 0)) * 100) AS MoM_percentage_change    -- ADDED NULLIF TO AVOID DIVISION BY ZERO ERROR
FROM zomato.orders t1
JOIN zomato.order_details t2
ON t1.order_id = t2.order_id
WHERE t1.r_id = 1
GROUP BY MONTHNAME(t1.date), MONTH(t1.date)
ORDER BY MONTH(t1.date);




------------------------------------  Percentiles & Quantiles (PERCENTILE_DISC & PERCENTILE_CONT)       ==> syntax issue :( :(
-- A **Quantile** is a measure of the distribution of a dataset that divides the data into any number of equally sized intervals. For example, a dataset could be divided into **deciles** (ten equal parts), **quartiles** (four equal parts), **percentiles** (100 equal parts), or any other number of intervals.
-- Each quantile represents a value below which a certain percentage of the data falls. For example, the 25th percentile (also known as the frst quartile, or Q1) represents the value below which 25% of the data falls. The 50th percentile (also known as the median) represents the value below which 50% of the data falls, and so on.
-- In SQL, percentiles and quantiles can be calculated using window functions such as PERCENTILE_DISC and PERCENTILE_CONT.
-- PERCENTILE_DISC (discrete) returns the smallest value in the dataset that is greater than or equal to the specified percentile.
-- PERCENTILE_CONT (continuous) returns a value that may not exist in the dataset by interpolating between values.




---- Question ----
-- Find the median marks of all the students .
-- median cgpa is the 50th percentile
SELECT * , PERCENTILE_DISC(0.5) WITHIN GROUP (ORDER BY marks) OVER() AS median_marks
FROM temp.students;


---- Question ----
-- Find the 25th , 50th and 75th percentile marks of all the students .
SELECT * , PERCENTILE_DISC(0.25) WITHIN GROUP (ORDER BY marks) OVER() AS 25th_percentile_marks,
        PERCENTILE_DISC(0.5) WITHIN GROUP (ORDER BY marks) OVER() AS 50th_percentile_marks,
        PERCENTILE_DISC(0.75) WITHIN GROUP (ORDER BY marks) OVER() AS 75th_percentile_marks
FROM temp.students;


---- Question ----
-- Find the branch wise median marks of all the students .
SELECT * , PERCENTILE_DISC(0.5) WITHIN GROUP (ORDER BY marks) OVER(PARTITION BY branch) AS median_marks_branch
FROM temp.students;

