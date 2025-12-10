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

- **Non-Parameterized Functions**: These functions do not accept any parameters. They perform operations that do not require any input values. For example:

  ```sql
    CREATE FUNCTION GetCurrentDate()
    RETURNS DATETIME
    AS
    BEGIN
        RETURN GETDATE()
    END;    
    ```

## Deterministic vs Non-Deterministic Functions

- **Deterministic Functions**: These functions always return the same result when given the same input parameters. For example, a function that adds two numbers is deterministic because it will always return the same sum for the same pair of numbers.

- **Non-Deterministic Functions**: These functions may return different results when called with the same input parameters. For example, a function that retrieves the current date and time is non-deterministic because the result changes every time it is called.

## Types of User Defined Functions

There are three main types of user-defined functions in SQL:

1. **Scalar Functions**: These functions return a single value (scalar value) based on the input parameters. They can be used in SQL statements wherever expressions are allowed.

   Example:

   ```sql
   CREATE FUNCTION Square(@num INT)
   RETURNS INT
   AS
   BEGIN
       RETURN @num * @num
   END;
   ```

2. **Table-Valued Functions**: These functions return a table data type. They can be used in the FROM clause of a SQL query.

    Example:

    ```sql
    CREATE FUNCTION GetEmployeesByDepartment(@deptId INT)
    RETURNS TABLE
    AS
    RETURN
    (
         SELECT * FROM Employees WHERE DepartmentId = @deptId
    );
    ```

3. **Aggregate Functions**: These functions perform a calculation on a set of values and return a single value. They are often used in conjunction with the GROUP BY clause in SQL queries.

    Example:

    ```sql
    CREATE FUNCTION AverageSalary(@deptId INT)
    RETURNS FLOAT
    AS
    BEGIN
         DECLARE @avgSalary FLOAT;
         SELECT @avgSalary = AVG(Salary) FROM Employees WHERE DepartmentId = @deptId;
         RETURN @avgSalary;
    END;
    ```

## Advantages of Using User Defined Functions

- **Reusability**: UDFs allow you to encapsulate logic that can be reused across multiple queries and stored procedures, reducing code duplication.
- **Modularity**: UDFs help in breaking down complex logic into smaller, manageable pieces, making the code easier to read and maintain.
- **Improved Performance**: By using UDFs, you can optimize performance by reducing the amount of code that needs to be executed multiple times.
- **Consistency**: UDFs ensure that the same logic is applied consistently across different parts of the application.
- **Encapsulation**: UDFs encapsulate business logic, making it easier to manage and update without affecting other parts of the application.

## Disadvantages of Using User Defined Functions

- **Performance Overhead**: UDFs can introduce performance overhead, especially if they are called frequently within queries. This is particularly true for scalar UDFs, which can lead to slower execution times.
- **Limited Functionality**: UDFs have certain limitations compared to stored procedures, such as restrictions on transaction control and error handling.
- **Complex Debugging**: Debugging UDFs can be more challenging than debugging regular SQL code, as they may not provide detailed error messages.
- **Dependency Management**: Changes to UDFs can affect multiple queries and applications that rely on them, making dependency management more complex.
- **Versioning Issues**: Managing different versions of UDFs can be difficult, especially in environments where multiple applications depend on the same functions.
- **Security Concerns**: UDFs can potentially expose sensitive logic or data if not properly secured, leading to security vulnerabilities.

Overall, while user-defined functions offer significant benefits in terms of reusability and modularity, it is essential to consider their potential drawbacks, particularly regarding performance and complexity. Proper design and implementation can help mitigate these disadvantages.

## UDFs vs Stored Procedures

## UDFs vs Stored Procedures — Concise Comparison

| Feature | User-Defined Functions (UDFs) | Stored Procedures |
|---|---:|---|
| Purpose | Compute and return a value (scalar or table) | Encapsulate procedural tasks, workflows, DML |
| Return | Single value or table (depends on DBMS) | 0..n result sets; can use OUT params |
| Usage in SQL | Usable in expressions (SELECT, WHERE, JOIN) | Called independently (CALL / EXEC); not inline |
| Side effects | Should be side-effect free; many DBs restrict DML | Designed for side effects (INSERT/UPDATE/DELETE) |
| Transactions | Usually cannot control transactions | Can begin/commit/rollback (DBMS-dependent) |
| Performance | Scalar UDFs can hurt performance; inline TVFs are better | Better for complex/multi-step ops; performance depends on design |
| Error handling | Limited | Robust (TRY/CATCH / EXCEPTION blocks) |
| Parameters | Typically IN only (DB-specific) | IN, OUT, INOUT supported in many DBs |

When to choose

- Use a UDF: small, deterministic calculations you want inside queries.
- Use a Stored Procedure: multi-step tasks, DML, transaction control, or complex error handling.

Best practices

- Keep UDFs side-effect free and small; prefer inline TVFs for set-based work.
- Use procedures for maintenance, bulk changes, and workflows.
- Grant least privilege; document determinism and side effects.
- Test with real data and inspect execution plans.

In summary, UDFs are best suited for encapsulating reusable logic that returns a value and can be used within SQL statements, while stored procedures are more versatile for performing complex operations, including data modifications and transaction management. The choice between the two depends on the specific requirements of the application and the desired functionality.