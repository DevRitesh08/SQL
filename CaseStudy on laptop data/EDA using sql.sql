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

SELECT count(price), MIN(Price) , Max(Price) , STD(Price) , AVG(Price) , PERCENTILE_CONT(0.25)
from electronics.laptopdata ;
