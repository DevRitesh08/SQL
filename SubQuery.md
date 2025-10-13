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

1. Correlated Subquery: A subquery that references columns from the outer query. It is executed once for each row processed by the outer query.

   ```sql
   SELECT name
   FROM employees e
   WHERE salary > (SELECT AVG(salary) FROM employees WHERE department_id = e.department_id);
   ```

2. Non-Correlated Subquery: A subquery that does not reference any columns from the outer query. It can be executed independently of the outer query, also known as an independent subquery.

   ```sql
   SELECT name
   FROM employees
   WHERE department_id IN (SELECT department_id FROM departments WHERE location_id = 1400);
   ```



## Where Subqueries can be used ?

Subqueries can be used in various parts of a SQL statement, including:

1. **INSERT**:
2. **UPDATE**:
3. **DELETE**:
4. **SELECT**: here also subqueries can be used in various clauses like WHERE, FROM, SELECT and HAVING .
