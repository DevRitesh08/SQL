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



-- make a proper greeting function that takes name and gender as input and returns greeting message
-- ex : input: 'alice' , 'F' => output: 'Hello,Mrs Alice! Welcome to our platform.'
-- Ms is decided based on gender column

CREATE Function personalized_greeting(user_name VARCHAR(50), user_gender CHAR(1))
RETURNS VARCHAR(100)
DETERMINISTIC
BEGIN
    DECLARE greeting_message VARCHAR(100);
    SET user_name = CONCAT(UPPER(LEFT(user_name, 1)), LOWER(SUBSTRING(user_name, 2))); -- Capitalize first letter of name

    IF user_gender = 'M' THEN
        SET greeting_message = CONCAT('Hello, Mr. ', user_name, '! Welcome to our platform.');
    ELSEIF user_gender = 'F' THEN
        SET greeting_message = CONCAT('Hello, Ms. ', user_name, '! Welcome to our platform.');
    ELSE
        SET greeting_message = CONCAT('Hello, ', user_name, '! Welcome to our platform.');
    END IF;

    RETURN greeting_message;
END;

-- Using the personalized greeting function
SELECT personalized_greeting('alice', 'F') AS greeting;

SELECT * , personalized_greeting(name , gender) AS greeting FROM dump.customers_with_dob;

-- drop the functions after use
DROP FUNCTION hello_world;
DROP FUNCTION calculate_age;
DROP FUNCTION personalized_greeting;



-- date formatting function
-- input : '2024-06-15' => output: '15th June, 2024'

CREATE Function format_date(input_date VARCHAR(10))
RETURNS VARCHAR(50)
DETERMINISTIC
BEGIN
    SET input_date = STR_TO_DATE(input_date, '%Y-%m-%d');  -- convert string to date
    RETURN DATE_FORMAT(input_date, '%D %b %y');    -- Reference : dev.mysql.com/doc/refman/8.0/en/date-and-time-functions.html#function_date-format
END;

SELECT format_date(Date_of_Journey) from flights_data.flights ;

