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



--------
---- Rank
--------
-- RANK() function assigns a unique rank to each distinct value in the ordered partition of a result set.
-- If there are ties (i.e., multiple rows with the same value), they receive the same rank, and the next rank(s) are skipped.