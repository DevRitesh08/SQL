# What are Window Functions?

**Simplified Definition:**  
Window functions in SQL allow you to perform calculations (like sums, averages, rankings) on a group of rows that are related to the current row, without collapsing them into a single result.

**Enhanced Explanation:**  
Window functions are a special type of SQL function used for analytical calculations across a set of rows related to the current row—this set is called a "window." Instead of returning just one result for the whole group (like GROUP BY), window functions return a value for each row, considering other rows in the defined window.

The window is defined using the `OVER()` clause, which lets you:

- **Partition:** Split rows into groups based on a column or expression.
- **Order:** Set the order in which rows are processed within each group.

This makes it possible to, for example, calculate running totals, ranks, or moving averages directly in your query.

---

**Summary:**  
Window functions are powerful tools in SQL for performing calculations based on related rows, using flexible partitioning and ordering with the `OVER()` clause.

## Aggregate Functions with over()

when we use aggregate functions with over() clause it becomes window function

```sql
SELECT AVG(cgpa) OVER (PARTITION BY branch) as avg_cgpa_branch
FROM temp.students;
```

This query calculates the average CGPA for each branch without collapsing the rows, thanks to the window function. so each student row will have the average CGPA of their respective branch.

## Frames

