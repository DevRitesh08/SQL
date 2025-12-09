# Views

## What are Views?

In SQL, a view is a virtual table that does not store any data on its own but presents a customized view of one or more tables in a database. A view can be thought of as a pre-defined `SELECT` statement that retrieves data from one or more tables and returns a specific subset of data to the user.

So basically it is a logical table instead of a physical table.

Once a view is created, it can be used in the same way as a table in SQL queries, and any changes made to the underlying tables will be reflected in the view. (Show)

## Types of Views

There are mainly two types of views:

- **Simple Views** — Created from 1 single table
- **Complex Views** — Created from multiple tables with the help of joins, subquery etc.

## Views vs Ctes
Views and Common Table Expressions (CTEs) are both used to simplify complex queries, but they have some key differences:

- **Persistence**: Views are stored in the database and can be reused across multiple queries, while CTEs are temporary and exist only for the duration of a single query.
- **Performance**: Views can sometimes be optimized by the database engine for better performance, while CTEs are typically executed as part of the main query and may not benefit from the same optimizations.
- **Readability**: CTEs can improve the readability of complex queries by breaking them into smaller, more manageable parts, while views can also enhance readability by encapsulating complex logic into a single object.
- **Use Cases**: Views are often used for data abstraction, security, and simplifying access to complex data structures, while CTEs are primarily used for improving query organization and readability within a single query.

## Read only vs Updatable Views

a. Read-only views:  
As the name suggests, read-only views are views that cannot be updated. They are used to simplify the process of querying data, but they cannot be used to modify or delete data in the underlying tables.

b. Updatable views:  
[MySQL View Updatability — Reference Manual](https://dev.mysql.com/doc/refman/8.0/en/view-updatability.html)
Updatable views are views that allow you to modify, insert or delete data in the underlying tables through the view. They behave like normal tables, but with restrictions.

To make a view updatable, certain conditions must be met. For example, the view must not contain any derived columns, subqueries, or aggregate functions.Additionally, the view must be based on a single table, and all columns in the view must be directly mapped to columns in the underlying table.

#### Example of Read-only view:

```sql
CREATE VIEW ReadOnlyView AS
SELECT department, COUNT(*) AS employee_count
FROM Employees
GROUP BY department;
```

#### Example of Updatable view:

```sql  
CREATE VIEW UpdatableView AS
SELECT employee_id, first_name, last_name, department
FROM Employees;
```

## Materialized Views ==> important but not present in MySQL

A materialized view is a database object in SQL that contains the results of a query. Unlike regular views, which are just virtual tables that store SQL queries, materialized views are physical tables that store the results of a query. Materialized views are precomputed and stored on disk, which makes them much faster to access than regular views.

- **Benefit** — Faster queries , whereas regular views can be slower because they need to execute the underlying query each time they are accessed.
- **Disadvantage** — Need to manually update the view , whereas regular views are always up-to-date because they are based on the underlying tables.
                   - Maintenance overhead , as materialized views require additional storage space and may need to be refreshed periodically to ensure that they contain the most up-to-date data.

- **Use Case** — Useful for large datasets or complex queries that are frequently accessed , such as in data warehousing or business intelligence applications.

## Creating Views

To create a view in SQL, you can use the `CREATE VIEW` statement followed by the view name and the `AS` keyword, along with a `SELECT` statement that defines the data to be included in the view.

```sql
CREATE VIEW view_name AS
SELECT column1, column2, ...
FROM table_name
WHERE condition;
```

For example, to create a view that shows all employees from the "Employees" table who work in the "Sales" department, you can use the following SQL statement:

```sql
CREATE VIEW SalesEmployees AS
SELECT * FROM Employees
WHERE department = 'Sales';
```

## Using Views
Once a view is created, you can use it in your SQL queries just like a regular table. For example, to retrieve all employees from the "SalesEmployees" view, you can use the following SQL statement:

```sql
SELECT * FROM SalesEmployees;
```

This will return all employees who work in the "Sales" department.

## Modifying Views

To modify an existing view, you can use the `CREATE OR REPLACE VIEW` statement followed
by the view name and the new `SELECT` statement that defines the updated data for the view.

```sql
CREATE OR REPLACE VIEW view_name AS
SELECT column1, column2, ...
FROM table_name
WHERE condition;
```

For example, to modify the "SalesEmployees" view to include only employees with a salary greater than 50000, you can use the following SQL statement:

```sql
CREATE OR REPLACE VIEW SalesEmployees AS
SELECT * FROM Employees
WHERE department = 'Sales' AND salary > 50000;
```

## Dropping Views
To delete a view from the database, you can use the `DROP VIEW` statement followed by
the view name.

```sql
DROP VIEW view_name;
```

For example, to delete the "SalesEmployees" view, you can use the following SQL statement:

```sql
DROP VIEW SalesEmployees;
```

This will remove the view from the database.

## Advantages of Using Views

- **Simplified Queries**: Views can simplify complex queries by encapsulating them into a single object, making it easier to retrieve data.
- **Data Security**: Views can restrict access to sensitive data by exposing only specific columns or rows to users.
- **Data Abstraction**: Views can provide a level of abstraction by hiding the underlying table structure from users.
- **Reusability**: Views can be reused across multiple queries, reducing the need to write the same complex SQL code repeatedly.

## Disadvantages of Using Views

- **Performance Overhead**: Views can introduce performance overhead, especially if they are based on complex queries or involve multiple joins.
- **Limited Functionality**: Some database systems may have limitations on the types of operations that can be performed on views, such as restrictions on updating data through views.
- **Dependency Management**: Changes to the underlying tables can affect the views, requiring careful management of dependencies.
- **Storage**: While views do not store data themselves, they can consume storage space in terms of metadata and query execution plans.
- **Complexity**: Overuse of views can lead to increased complexity in database design and maintenance, making it harder to understand the overall data structure.
