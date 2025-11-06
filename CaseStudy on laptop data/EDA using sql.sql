SELECT * FROM electronics.laptopdata ;

----
-- head , tail and sample 
----

-- head
SELECT * 
FROM electronics.laptopdata
ORDER BY 'index' LIMIT 5 ;

-- tail
SELECT * 
FROM electronics.laptopdata
ORDER BY 'index' DESC LIMIT 5 ;

-- sample 
SELECT * 
FROM electronics.laptopdata
ORDER BY RAND() limit 5 ;



--------
---- Univeriate Analysis 
--------



----
-- for numerical Columns
----


-- 5 Number Summary [count , min , max , std , mean , q1 , q2 , q3 ]

SELECT 
count(price), 
MIN(Price) , 
Max(Price) , 
STD(Price) , 
AVG(Price) , 
-- PERCENTILE_CONT(0.25) WITHIN GROUP (ORDER BY Price) AS Q1,   -- PERCENTILE_CONT not supported in SQL
-- PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY Price) AS Q2,
-- PERCENTILE_CONT(0.75) WITHIN GROUP (ORDER BY Price) AS Q3
from electronics.laptopdata ;

-- finding quartiles using
-- Create a Common Table Expression (CTE) named 'ordered'
-- This first step organizes all laptop prices into 4 quartiles (buckets)
-- using the NTILE(4) window function.
-- Each price will be assigned a quartile number between 1 and 4 based on its order.

WITH ordered AS (
  SELECT 
    price,
    NTILE(4) OVER (ORDER BY price) AS quartile   -- Divide prices into 4 quartiles
  FROM electronics.laptopdata
)
-- Now perform the main aggregation query on the 'ordered' CTE
SELECT 
  -- Quartile 1 is the maximum value in the first quartile bucket
  MAX(CASE WHEN quartile = 1 THEN price END) AS Q1,
  -- Quartile 2 is the maximum value in the second quartile bucket  
  MAX(CASE WHEN quartile = 2 THEN price END) AS Q2,
  -- Quartile 3 is the maximum value in the third quartile bucket
  MAX(CASE WHEN quartile = 3 THEN price END) AS Q3
FROM ordered;


-- Missing Values


SELECT COUNT(Price) AS NonMissingCount,
       COUNT(*) - COUNT(Price) AS MissingCount
FROM electronics.laptopdata ;
-- alternative
SELECT COUNT(Price)
FROM electronics.laptopdata 
WHERE Price IS NULL ;


-- Finding Outliers

