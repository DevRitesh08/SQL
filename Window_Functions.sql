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