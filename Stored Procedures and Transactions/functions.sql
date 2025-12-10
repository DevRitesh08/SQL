----
-- User-defined function
----

CREATE Function hello_world()
RETURNS VARCHAR(50)
DETERMINISTIC       -- it always returns the same result for the same input
-- NO SQL              -- it does not contain any SQL statements that read or write data
BEGIN
    RETURN 'Hello, World!';
END;

-- Calling the function
SELECT hello_world() AS greeting;

-- Using the function in a query on a table ==> the function is called for each row in the table
SELECT hello_world() from zomato.users;
-- similar to built-in functions like NOW(), CURDATE(), etc.
SELECT UPPER(name) from zomato.users;  -- built-in function

-- Parameterized function

-- take dob as input and return age from dump.customers_with_dob table
CREATE Function calculate_age(dob DATE)
RETURNS INT
DETERMINISTIC
BEGIN
    DECLARE age INT;
    SET age = TIMESTAMPDIFF(YEAR, dob, CURDATE());  -- calculate age in years using TIMESTAMPDIFF
    RETURN age;
END;

-- Using the parameterized function in a query

SELECT calculate_age('2005-07-08') AS age;
SELECT calculate_age(dob) AS age FROM dump.customers_with_dob;

SELECT * FROM dump.customers_with_dob