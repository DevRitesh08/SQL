# SQL Interview Questions

## Difference Between COUNT(*) and COUNT(column_name) in SQL?

- **COUNT(*)** counts all rows in a table, including those with NULL values in any column.
- **COUNT(column_name)** counts only the rows where the specified column is NOT NULL.

**Then what is COUNT(1) ?**

- **COUNT(1)** is a shorthand way of writing COUNT(*) and counts all rows in a table, including those with NULL values.

**CAN ALSO be written as COUNT(0) or COUNT('any constant value').**

## Dealing with NULL values in SQL?

### Null values with non-null values

if we have a null value and we perform any operation (e.g., addition, concatenation, comparison, etc.) with a non-null value, the result will be null always.

### ORDER BY with NULL values

By default, in ascending order (ASC), NULL values appear first, and in descending order (DESC), NULL values appear last , so null values are considered as the lowest possible value. However, this behavior can vary depending on the database system .

### GROUP BY with NULL values

When using GROUP BY, all NULL values are treated as a single group. So, if there are multiple rows with NULL in the grouped column, they will be grouped together.

### Aggregate functions with NULL values

When performing aggregate operations in MySQL, NULL values are treated differently depending on whether or not the GROUP BY clause is used.

### Without GROUP BY

- If the aggregate function is **SUM**, **AVG**, **MAX**, **MIN**, or **COUNT**, NULL values are ignored and not included in the calculation.
- If the aggregate function is **GROUP_CONCAT** or **CONCAT**, NULL values are included in the result, but a NULL value is returned if all the values being concatenated are NULL.

### With GROUP BY

- If the aggregate function is **COUNT**, NULL values are not included in the count for each group. However, if you use **COUNT(*)** instead of **COUNT(column)**, then NULL values are included in the count.
- If the aggregate function is **SUM**, **AVG**, **MAX**, or **MIN**, NULL values are ignored and not included in the calculation for each group. If a group contains only NULL values, then the result for that group will be NULL.
- If the aggregate function is **GROUP_CONCAT** or **CONCAT**, NULL values are included in the result for each group, but a NULL value is returned if all the values being concatenated in a group are NULL.

#### 1. How to find null values

To find null values in a specific column of a table, you can use the following SQL query:

```sql
SELECT * FROM table_name WHERE column_name IS NULL;
```

#### 2. How to replace null values

To replace null values in a specific column of a table, you can use the `COALESCE` function or the `IFNULL` function (in MySQL) to provide a default value when a null is encountered. Here are examples of both methods:
Using `COALESCE`:

```sql
UPDATE table_name
SET column_name = COALESCE(column_name, 'default_value');
```

Using `IFNULL` (MySQL):

```sql
UPDATE table_name
SET column_name = IFNULL(column_name, 'default_value');
```

or can just use it with select statement

```sql
SELECT COALESCE(column_name, 'default_value') FROM table_name;
```

`Not that flexible as fillna in pandas since here we cant replace it with avg or median of that column directly`

## DELETE vs TRUNCATE vs DROP

- **DELETE**: This command is used to remove specific rows from a table based on a condition. It can be rolled back if used within a transaction. It is slower compared to TRUNCATE and DROP because it logs individual row deletions.

  - if we use DELETE without a WHERE clause, it removes all rows from the table.
  - it does not reset any auto-incrementing keys.
  - it can be used with a WHERE clause to delete specific rows.
  - it is a DML (Data Manipulation Language) command.

- **TRUNCATE**: This command is used to remove all rows from a table quickly and efficiently. It cannot be rolled back and does not log individual row deletions. It resets any auto-incrementing keys to their initial values.

  - it cannot be used with a WHERE clause; it removes all rows.
  - it is faster than DELETE for large tables.
  - it is a DDL (Data Definition Language) command.
- **DROP**: This command is used to remove an entire table (or database) from the database. It cannot be rolled back and removes all data, structure, and associated objects (like indexes) from the database.

  - it removes the entire table structure and all its data.
  - it is irreversible; once a table is dropped, it cannot be recovered.
  - it is a DDL (Data Definition Language) command.
  - it is a DDL (Data Definition Language) command.

## NON - EQUI JOINS

`Till now we have only seen equi joins where we use = operator to join two tables`
A non-equi join is a type of join that does not use the equality operator (=) to match rows between two tables. Instead, it uses other comparison operators such as <, >, <=, >=, or <> to establish the relationship between the tables.

use cases of non-equi joins:

1. Range-based joins: When you want to join two tables based on a range of values, such as joining a table of employees with a table of salary ranges to find out which employees fall within each salary range.
2. Inequality joins: When you want to join two tables based on an inequality condition, such as joining a table of products with a table of discounts to find out which products are eligible for a discount based on their price.
3. Date-based joins: When you want to join two tables based on a date range, such as joining a table of orders with a table of promotions to find out which orders were placed during a specific promotion period.
4. Spatial joins: When you want to join two tables based on spatial relationships, such as joining a table of locations with a table of regions to find out which locations fall within each region.
5. Custom business logic: When you have specific business rules that require non-equality conditions to join tables, such as joining a table of customers with a table of loyalty programs based on their spending patterns.
