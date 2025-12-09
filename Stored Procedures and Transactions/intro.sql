-- stored Procedure
-- it is a set of SQL statements that can be stored in the database and executed as a single unit.
-- it helps to encapsulate logic, improve performance, and promote code reusability.
-- Syntax to create a stored procedure :
    -- CREATE PROCEDURE procedure_name (parameters)
    -- BEGIN
    --     SQL statements;
    -- END;

-- to call a stored procedure :
    -- CALL procedure_name (arguments);


----
-- Examples of creating and calling a stored procedure
----


-- basic example of stored procedure
CREATE Procedure hello_world ()
begin
    select 'Hello, World!' as greeting ;
end;

CALL hello_world();    
-- Output: 'Hello, World!'
-- drop procedure
DROP PROCEDURE hello_world;

-- to view all stored procedures in the current database
SHOW PROCEDURE STATUS WHERE Db = DATABASE();

use day6_db;
SELECT * from day6_db.student;

-- example to create a new user (only when email does not exist)

CREATE Procedure ADD_USER (
    IN p_name VARCHAR(100),     -- here p_name is the name of the user ==> IN parameter is used to pass input values to the procedure
    IN p_email VARCHAR(100)
)
BEGIN
-- Check if email already exists
DECLARE user_count INT;
SELECT COUNT(*) INTO user_count FROM day6_db.student WHERE email = p_email;
IF user_count = 0 THEN
    -- Insert new user if email does not exist
    INSERT INTO day6_db.student (name, email) VALUES (p_name, p_email);
    SELECT 'User added successfully.' AS message;
ELSE
    SELECT 'Email already exists. User not added.' AS message;
END IF;
END
;

    
CALL ADD_USER('ritesh', 'abc@gmail.com') ;    -- Output: Email already exists ==> User not added.

CALL ADD_USER('john doe', 'john.doe@example.com') ;    -- Output: User added successfully.
CALL ADD_USER('jane smith', 'jane.smith@example.com') ;    -- Output: User added successfully.

SELECT * FROM day6_db.student;   -- verify the new users are added
-- drop added data
DELETE FROM day6_db.student WHERE email IN ('john.doe@example.com', 'jane.smith@example.com');

-- drop procedure
DROP PROCEDURE ADD_USER;

-- Alternate way to create stored procedure with out parameters
CREATE Procedure ADD_USER (
    IN p_name VARCHAR(100),     -- here p_name is the name of the user ==> IN parameter is used to pass input values to the procedure
    IN p_email VARCHAR(100),
    OUT p_message VARCHAR(255)  -- OUT parameter is used to return output values from the procedure ==> p_message will hold the result message
)
BEGIN
-- Check if email already exists
DECLARE user_count INT;
SELECT COUNT(*) INTO user_count FROM day6_db.student WHERE email = p_email;
IF user_count = 0 THEN
    -- Insert new user if email does not exist
    INSERT INTO day6_db.student (name, email) VALUES (p_name, p_email);
    SET p_message = 'User added successfully.';
ELSE
    SET p_message = 'Email already exists. User not added.';
END IF;
END
;

-- to call the procedure with out parameter
CALL ADD_USER('alice', 'alice@example.com', @message);  -- @message is a user-defined variable , used to capture the output from the OUT parameter
--or
SET @message = '';
CALL ADD_USER('bob', 'bob@example.com', @message);  --here first we initialize @message to an empty string and then call the procedure  

-- to get the output message
SELECT @message;   -- Output: User added successfully.

--- drop procedure
DROP PROCEDURE ADD_USER;
-- drop added data
DELETE FROM day6_db.student WHERE email IN ('alice@example.com', 'bob@example.com');


-- stored procedure to fetch all orders of a customer when his/her email is provided

CREATE PROCEDURE GetCustomerOrders(IN p_email VARCHAR(100))
BEGIN
    DECLARE id integer ;
    SELECT user_id INTO id FROM users WHERE email = p_email; 

    SELECT * FROM orders 
    WHERE user_id = id;  -- here we are using the user_id to fetch all orders of the customer
END;


call `GetCustomerOrders`('vartika@gmail.com');  -- replace with an actual email from the customers table
-- this will return all orders associated with the customer whose email is provided
-- it is a major difference betweeen function and stored procedure ==> stored procedure can return multiple rows of data, while function returns a single value.


-- drop procedure
DROP PROCEDURE GetCustomerOrders;


-- create a stored procedure to place a new order for a customer
-- we need user_id, r_id,  f_item . 
-- we have two tables orders and order_details both we will use to insert the new order and its details.
-- and in output we will return the total amount of the order.

CREATE PROCEDURE Place_Order(
    IN p_user_id INT,
    IN p_r_id INT,
    IN p_f_ids VARCHAR(100),   -- food item name in VARCHAR because we will pass comma separated food item ids
    OUT p_total_amount DECIMAL(10, 2)
)
BEGIN
    -- Declare ALL variables first (before any SET, SELECT, etc.) ==> important in MySQL
    DECLARE new_order_id INT;
    DECLARE f_id1 INT;
    DECLARE f_id2 INT;

    -- insert into orders table
    
    -- generate new order id
    -- DECLARE new_order_id INT;
    SELECT MAX(order_id) + 1 INTO new_order_id FROM orders;  -- generate new order id

    -- extracting the food ids
    -- DECLARE f_id1 INT;      -- assuming we are placing order for two food items only for simplicity
    -- DECLARE f_id2 INT;
    -- Extract and CAST food IDs to INT
    SET f_id1 = CAST(SUBSTRING_INDEX(p_f_ids, ',', 1) AS UNSIGNED);
    SET f_id2 = CAST(SUBSTRING_INDEX(p_f_ids, ',', -1) AS UNSIGNED);

    -- finding the price of items using food ids and r_id
    SELECT SUM(price) INTO p_total_amount FROM menu WHERE r_id = p_r_id AND f_id IN (f_id1, f_id2);

    -- insert into orders table
    INSERT INTO orders (order_id, user_id, r_id, amount , date)
    VALUES (new_order_id, p_user_id, p_r_id, p_total_amount, DATE(NOW()));


    -- insert into order_details table
    INSERT INTO order_details (order_id, f_id)
    VALUES (new_order_id, f_id1), (new_order_id, f_id2);

END;


-- to call the procedure
SET @total_amount = 0.00;

CALL Place_Order(3, 3, '6,7', @total_amount);  -- assuming user_id=3, r_id=3, food items with f_id 6 and 7

SELECT @total_amount AS Total_Amount;  -- Output: Total amount of the order

-- drop procedure
DROP PROCEDURE Place_Order;
-- clean up the inserted order and order_details
DELETE FROM order_details WHERE order_id = (SELECT MAX(order_id) FROM orders);
DELETE FROM orders WHERE order_id = (SELECT MAX(order_id) FROM orders);

-- DECLARE vs SET
-- DECLARE is used to declare local variables within a stored procedure or function. It is used to define the data type and name of the variable. it can only be used inside stored procedures or functions.
-- SET is used to create , assign values to variables, or modify session variables. It can be used both inside and outside of stored procedures.

