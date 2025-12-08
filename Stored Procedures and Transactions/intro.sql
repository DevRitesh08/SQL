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

