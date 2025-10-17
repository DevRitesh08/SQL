----
-- using Group by 
----

SELECT branch, AVG(cgpa) as average_cgpa FROM temp.students GROUP BY branch;



----
-- using Window Functions
----

SELECT branch,AVG(cgpa) OVER (PARTITION BY branch) as average_cgpa FROM temp.students;  -- this will give average cgpa for each student in that branch but repeated for all students of that branch
-- To get distinct branch with average cgpa use DISTINCT
SELECT DISTINCT branch,AVG(cgpa) OVER (PARTITION BY branch) as average_cgpa FROM temp.students;