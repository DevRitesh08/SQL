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
-- PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY Price) AS Q2,    -- But works fine in other SQL variants like PostgreSQL, Oracle , SQL Server etc.
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

WITH ordered AS (
  SELECT 
    price,
    NTILE(4) OVER (ORDER BY price) AS quartile
  FROM electronics.laptopdata
),
quartiles AS (
  SELECT 
    MAX(CASE WHEN quartile = 1 THEN price END) AS Q1,
    MAX(CASE WHEN quartile = 3 THEN price END) AS Q3
  FROM ordered
)
SELECT 
  t.*,
  q.Q1,
  q.Q3,
  (q.Q3 - q.Q1) AS IQR
FROM electronics.laptopdata t
CROSS JOIN quartiles q
WHERE t.price < (q.Q1 - 1.5 * (q.Q3 - q.Q1)) 
   OR t.price > (q.Q3 + 1.5 * (q.Q3 - q.Q1));

-- Explanation:

-- 1. First CTE (ordered): Assigns quartile numbers to each price
-- 2. Second CTE (quartiles): Calculates Q1 and Q3 from the quartile assignments
-- 3. Main Query: Uses CROSS JOIN to attach Q1 and Q3 values to every row in the laptopdata table, then filters for outliers


-- Horizontal / Vertical Histograms

SELECT t.Price_Range, REPEAT('*', COUNT(*)/10) AS Count
FROM (SELECT Price ,
                CASE WHEN Price BETWEEN 0 AND 20000 THEN '0-20k'
                    WHEN Price BETWEEN 20001 AND 40000 THEN '20k-40k'
                    WHEN Price BETWEEN 40001 AND 60000 THEN '40k-60k'
                    WHEN Price BETWEEN 60001 AND 80000 THEN '60k-80k'
                    WHEN Price BETWEEN 80001 AND 100000 THEN '80k-100k'
                    WHEN Price BETWEEN 100001 AND 120000 THEN '100k-120k'
                    WHEN Price BETWEEN 120001 AND 140000 THEN '120k-140k'
                    ELSE '140k+' 
                END AS Price_Range
                FROM electronics.laptopdata ) t
GROUP BY t.Price_Range ;

-- Now creating a Vertical histogram



----
-- for Categorical Columns
----


-- value counts -> pie chart
SELECT Company , COUNT(Company) 
FROM electronics.laptopdata
GROUP BY Company ; -- now just use exel for pie chart

-- Missing Value 
-- since their is no group of missing value ==> so no missing values 

--------
---- Bivariate Analysis
--------



----
-- for numerical-numerical Columns
----


-- Side by Side 8 number Analysis 
WITH price_stats AS (
    SELECT 
        Price,
        NTILE(4) OVER (ORDER BY Price) AS quartile
    FROM electronics.laptopdata
)
SELECT 
    'Price' AS Column_Name,
    COUNT(*) AS Count,
    MIN(Price) AS Min,
    MAX(Price) AS Max,
    AVG(Price) AS Mean,
    STDDEV(Price) AS StdDev,
    MAX(CASE WHEN quartile = 1 THEN Price END) AS Q1,
    MAX(CASE WHEN quartile = 2 THEN Price END) AS Q2,
    MAX(CASE WHEN quartile = 3 THEN Price END) AS Q3
FROM price_stats;


-- ScatterPlot

SELECT `CPU_Speed(in GHz)`, Price FROM electronics.laptopdata ; -- can plot it in excel


-- Correlation
-- SELECT CORR(`CPU_Speed(in GHz)`, Price) FROM electronics.laptopdata;  -- not working



----
-- for Categorical-Categorical Columns
----


-- Contigency table -> stacked bar chart
SELECT `Company`, 
SUM(CASE WHEN Touchscreen_or_Not = 1 THEN 1 ELSE 0 END) AS 'TouchScreen_Yes',
SUM(CASE WHEN Touchscreen_or_Not = 0 THEN 1 ELSE 0 END) AS 'TouchScreen_No'
FROM electronics.laptopdata
GROUP BY `Company`;
-- for cpu_brand
SELECT `Company`, 
SUM(CASE WHEN CPU_Brand = 'Intel' THEN 1 ELSE 0 END) AS 'Intel',
SUM(CASE WHEN CPU_Brand = 'AMD' THEN 1 ELSE 0 END) AS 'AMD',
SUM(CASE WHEN CPU_Brand = 'Samsung' THEN 1 ELSE 0 END) AS 'Samsung'
FROM electronics.laptopdata
GROUP BY `Company`;

SELECT DISTINCT `CPU_Brand` FROM electronics.laptopdata ;



----
-- for Numerical-Categorical Columns
----



-- Compare distribution across categories
SELECT Company , Min(Price) , MAX(Price)  , AVG(Price) , STD(Price) 
FROM electronics.laptopdata
GROUP BY Company ;



----
-- Dealing with Missing Values
----




-- Dealing with missing values ==> we don't have them so lets insert some missing values for demonstration
update electronics.laptopdata
SET Price = NULL
WHERE Price IN (50136 , 30743 , 18595 , 71875) ;

SELECT * FROM electronics.laptopdata 
WHERE Price IS NULL ;

-- Now we can either drop or impute missing values
-- to impute we have these common strategies :
-- 1. Mean Imputation of Price

-- UPDATE electronics.laptopdata
-- SET Price = (SELECT AVG(Price) FROM electronics.laptopdata WHERE Price IS NOT NULL)
-- WHERE Price IS NULL;
-- this will not work because we can't specify target table in subquery of update statement in mysql
SET @avg_price = (SELECT AVG(Price) FROM electronics.laptopdata WHERE Price IS NOT NULL);

UPDATE electronics.laptopdata
SET Price = @avg_price
WHERE Price IS NULL;


-- 2. Corresponding Company Price Imputation  ==> again we have to make null values again for demonstration using above update query

  -- UPDATE electronics.laptopdata t1
  -- SET Price = (SELECT AVG(Price) FROM electronics.laptopdata t2 WHERE t1.`Company` = t2.`Company` AND t2.Price IS NOT NULL)
  -- WHERE Price IS NULL;
-- this will not work because we can't specify target table in subquery of update statement in mysql

SET @company_price = (SELECT AVG(Price) FROM electronics.laptopdata t2 WHERE t2.`Company` = (SELECT t1.`Company` FROM electronics.laptopdata t1 WHERE t1.Price IS NULL LIMIT 1) AND t2.Price IS NOT NULL);

UPDATE electronics.laptopdata t1
SET Price = @company_price
WHERE Price IS NULL;

-- 3. Corresponding CPU_Name and Company Price Imputation

-- UPDATE electronics.laptopdata t1
-- SET Price = (SELECT AVG(Price) FROM electronics.laptopdata t2 WHERE t1.`Company` = t2.`Company` AND t1.`CPU_Name` = t2.`CPU_Name` AND t2.Price IS NOT NULL)
-- WHERE Price IS NULL;
-- this will not work because we can't specify target table in subquery of update statement in mysql

SET @cpu_company_price = (SELECT AVG(Price) FROM electronics.laptopdata t2 WHERE t2.`Company` = (SELECT t1.`Company` FROM electronics.laptopdata t1 WHERE t1.Price IS NULL LIMIT 1) AND t2.`CPU_Name` = (SELECT t1.`CPU_Name` FROM electronics.laptopdata t1 WHERE t1.Price IS NULL LIMIT 1) AND t2.Price IS NOT NULL);
UPDATE electronics.laptopdata t1
SET Price = @cpu_company_price
WHERE Price IS NULL;

SELECT * FROM electronics.laptopdata ;




----
-- Feature Engineering : Creating new features
----

-- Creating a new feature ppi (pixels per inch) , PPI = sqrt( X_resolution^2 + Y_resolution^2 ) / screen_size(in inches)
ALTER TABLE electronics.laptopdata
ADD COLUMN PPI FLOAT;

UPDATE electronics.laptopdata
SET PPI = SQRT(POW(Resolution_Width, 2) + POW(Resolution_Height, 2)) / Inches
WHERE Inches IS NOT NULL;

-- Review the updates
SELECT * FROM electronics.laptopdata LIMIT 5;

-- creating a screen size bracket feature
ALTER TABLE electronics.laptopdata
ADD COLUMN Screen_Size_Bracket VARCHAR(20);

-- using CASE statement to categorize screen sizes
UPDATE electronics.laptopdata
SET Screen_Size_Bracket = CASE 
    WHEN Inches < 13 THEN 'Small'
    WHEN Inches BETWEEN 13 AND 15 THEN 'Medium'
    WHEN Inches > 15 THEN 'Large'
    ELSE 'Unknown'
END;

-- using ntile to create screen size brackets

WITH size_brackets AS (
    SELECT 
        Inches,
        NTILE(3) OVER (ORDER BY Inches) AS size_bracket
    FROM electronics.laptopdata
)
UPDATE electronics.laptopdata t
JOIN size_brackets sb ON t.Inches = sb.Inches
SET t.Screen_Size_Bracket = 
    CASE sb.size_bracket
        WHEN 1 THEN 'Small'
        WHEN 2 THEN 'Medium'
        WHEN 3 THEN 'Large'
    END;

-- Review the updates
SELECT * FROM electronics.laptopdata;





----
-- One Hot Encoding Encoding Categorical Variables 
----

-- One Hot Encoding : it creates new binary columns for each category in a categorical variable. 

-- Example: One Hot Encoding for 'Gpu_Brand' column
SELECT 
    Gpu_Brand,
    CASE WHEN Gpu_Brand = 'Nvidia' THEN 1 ELSE 0 END AS Gpu_Brand_Nvidia,
    CASE WHEN Gpu_Brand = 'Intel' THEN 1 ELSE 0 END AS Gpu_Brand_Intel,
    CASE WHEN Gpu_Brand = 'AMD' THEN 1 ELSE 0 END AS Gpu_Brand_AMD ,
    CASE WHEN Gpu_Brand = 'ARM' THEN 1 ELSE 0 END AS Gpu_Brand_ARM
FROM electronics.laptopdata ;

