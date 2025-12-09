----
-- Transactions
----

-- it is used to manage a set of sql statements as a single unit of work where either all statements are executed successfully or none of them are applied to the database.
-- it helps to maintain data integrity and consistency in case of errors or failures during the execution of multiple related operations.
-- it follows the ACID properties (Atomicity, Consistency, Isolation, Durability)
-- Syntax to use transactions :
    -- START TRANSACTION;  -- to begin a transaction
    -- SQL statements;     -- multiple sql statements
    -- COMMIT;            -- to save the changes made by the transaction
    -- ROLLBACK;          -- to undo the changes made by the transaction in case of errors
    -- SAVEPOINT savepoint_name;  -- to create a savepoint within a transaction
    -- ROLLBACK TO SAVEPOINT savepoint_name;  -- to rollback to a specific savepoint

-- by default in sql each sql statement is treated as a single transaction and is automatically committed after execution. this is known as autocommit mode.
-- to check the current autocommit mode
SELECT @@autocommit;  -- Output: 1 (enabled) or 0 (disabled)
-- to disable autocommit mode
-- SET autocommit = 0;

-- But in case Transactions we can manage the transactions manually using the above synta , an it helps to ensure data integrity and consistency in complex operations involving multiple sql statements.

SELECT * FROM dump.bank_table;

-- checking update queries are automatically committed or not
UPDATE dump.bank_table SET balance = balance + 50000 WHERE user_id = 1;-- to check it we have to log in again in another session and check the balance
-- Output: balance updated successfully so it means autocommit works with single sql statement of update , insert , delete.

-- Now explicitly disabling autocommit mode
SET autocommit = 0;
UPDATE dump.bank_table SET balance = balance - 20000 WHERE user_id = 1;
INSERT into dump.bank_table (user_id, name, email, balance) VALUES (11, 'sam', 'acc789@example.com', 15000);
UPDATE dump.bank_table SET balance = balance + 20000 WHERE user_id = 2; 

SELECT * FROM dump.bank_table;
-- now log in again in another session to check the balance , you will see the balance is not updated yet as we have disabled autocommit mode.
-- now committing the transaction to save the changes
COMMIT;
-- now log in again in another session to check the balance , you will see the balance is updated now as we have committed the transaction.


-- Now Creating a transaction 

SELECT * FROM dump.bank_table;
-- lets say we want to transfer 30000 from user_id 1 to user_id 2
START TRANSACTION;
UPDATE dump.bank_table SET balance = balance - 30000 WHERE user_id = 1;
UPDATE dump.bank_table SET balance = balance + 30000 WHERE user_id = 2;
-- now checking the balance in another session you will see the balance is not updated yet as we are still in transaction
-- now committing the transaction to save the changes
COMMIT;
-- now log in again in another session to check the balance , you will see the balance is updated now as we have committed the transaction.

-- All or Nothing Principle ==> most important principle of transactions
-- lets say we want to transfer 15000 from user_id 2 to user_id 5
-- but we will introduce an error in the second update statement to simulate a failure
SELECT * FROM dump.bank_table;

START TRANSACTION;
UPDATE dump.bank_table SET balance = balance - 5000 WHERE user_id = 2; 
UPDATE dump.bank_table SET balance = balance + 40000 WHERE user_id = 55; -- user_id 999 does not exist
COMMIT;
-- now log in again in another session to check the balance , you will see the balance of user_id 2 is not deducted as the second update statement failed and the entire transaction is rolled back. 


-- using ROLLBACK to undo changes in case of errors ==> in earlier example the transaction was automatically rolled back due to error but we can also explicitly use ROLLBACK statement to undo changes.
SELECT * FROM dump.bank_table;
-- lets say we want to transfer 16500 from user_id 2 to user_id 5
START TRANSACTION;
UPDATE dump.bank_table SET balance = balance - 16500 WHERE user_id = 2;
UPDATE dump.bank_table SET balance = balance + 16500 WHERE user_id2 = 5;    -- introducing error in the second update statement (wrong column name)
-- now checking the balance in another session you will see the balance is not updated yet as we are still in transaction
-- now rolling back the transaction to undo the changes
ROLLBACK;

SELECT * FROM dump.bank_table;

-- using savepoints within a transaction
START TRANSACTION ; 
SAVEPOINT sp1 ;
UPDATE dump.bank_table SET balance = 100000 WHERE user_id = 7 ; 
SAVEPOINT sp2 ;
UPDATE dump.bank_table SET balance = 100000 WHERE user_id = 11 ; 

ROLLBACK TO SAVEPOINT sp2 ;     -- undoing the changes made after sp2

SELECT * FROM dump.bank_table ;

-- if we use rollback without a savepoint in a transaction then it will undo all the changes made in the transaction only when their is no commit statement executed before the rollback.
-- if commit is executed before rollback then the changes made before the commit will be saved and only the changes made after the commit will be undone by the rollback.

START TRANSACTION;
UPDATE dump.bank_table SET balance = 1000 WHERE user_id = 8 ;
COMMIT;
UPDATE dump.bank_table SET balance = 1000 WHERE user_id = 9 ;
ROLLBACK;  
SELECT * FROM dump.bank_table ;

-- ISSUE with COMMIT and ROLLBACK usage
-- in the below example after the COMMIT statement the transaction is ended and the next UPDATE statement
START TRANSACTION;
UPDATE dump.bank_table SET balance = 1000 WHERE user_id = 8;
COMMIT;  -- ❌ This ENDS the transaction completely
UPDATE dump.bank_table SET balance = 1000 WHERE user_id = 9;  -- This runs in autocommit mode
ROLLBACK;  -- ❌ This has nothing to rollback - the UPDATE for user_id 9 is already committed



START TRANSACTION;
UPDATE dump.bank_table SET balance = 1000 WHERE user_id = 8;
SAVEPOINT sp1;  -- ✅ Create savepoint instead of COMMIT
UPDATE dump.bank_table SET balance = 1000 WHERE user_id = 9;
ROLLBACK TO SAVEPOINT sp1;  -- ✅ Rollback to savepoint
COMMIT;  -- Now commit (only user_id 8 change is saved)
SELECT * FROM dump.bank_table;