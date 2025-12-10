# User Defined Functions

User-defined functions (UDFs) in SQL are functions that are created by users to perform specific tasks. These functions can be used just like built-in functions in SQL and can take parameters as input, perform some operations on them, and then return a value.

User Defined Functions (UDFs) are routines that accept parameters, perform an action (such as a complex calculation), and return the result of that action as a value. UDFs can be used to encapsulate logic that can be reused across multiple queries or stored procedures.

syntax :

```sql
CREATE FUNCTION function_name (parameter1 datatype, parameter2 datatype, ...)
RETURNS return_datatype
AS
BEGIN
    -- function logic here
    RETURN return_value
END;
```

## Parameteized vs Non-Parameterized Functions

- **Parameterized Functions**: These functions accept one or more parameters as input. The parameters allow the function to perform operations based on the values passed to it. For example:

  ```sql
  CREATE FUNCTION AddNumbers (@num1 INT, @num2 INT)
  RETURNS INT
  AS
  BEGIN
      RETURN @num1 + @num2
  END;
  ```

  
