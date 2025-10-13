# Subqueries

In SQL, a subquery is a query within another query. It is a SELECT statement that is nested inside another SELECT, INSERT, UPDATE, or DELETE statement. The subquery is executed first, and its result is then used as a parameter or condition for the outer query. Subqueries can be used in various clauses such as WHERE, FROM, and SELECT.

**Scope of Subqueries:** its scope is limited to the query in which it is embedded. It cannot be referenced outside of that query and is terminated when the outer query completes.

## Types of Subqueries

Based on :
    1.  the result it returns
    2.  Based on working 

### Based on Result it returns

1. Scalar Subquery: Returns a single value (one row and one column). It can be used wherever a single value is expected, such as in a WHERE clause or a SELECT list.

   ```sql
   SELECT name
   FROM employees
   WHERE department_id = (SELECT department_id FROM departments WHERE department_name = 'Sales');
   ```

2. Row Subquery: Returns a single row with multiple columns. It can be used in places where a single row is expected.

   ```sql
    SELECT name, salary
    FROM employees
    WHERE (department_id, salary) = (SELECT department_id, MAX(salary) FROM employees GROUP BY department_id);
    ```

3. Table Subquery: Returns multiple rows and columns. It can be used in the FROM clause to create a derived table.

   ```sql
   SELECT name
   FROM employees
   WHERE department_id IN (SELECT department_id FROM departments WHERE location_id = 1400);
   ```

### Based on Working
