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

## Frames in Window Functions

**Simplified Definition:**  
A frame in a window function defines which rows are considered for calculations (like running totals or ranking) for each row in your result set. The frame is set using the `ROWS` and `BETWEEN` clauses.

**Enhanced Explanation:**  
A frame is a subset of rows within a partition that determines the scope for window function calculations. You use the `ROWS` clause to specify how many rows before or after the current row should be included. The `BETWEEN` clause sets the boundaries of this frame.

For example, `ROWS 3 PRECEDING` means the frame contains the current row and the three rows before it within that partition.

---

### Examples of Frame Clauses

- **ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW**  
  Includes all rows from the start of the partition up to and including the current row, it is the default frame for many window functions.
- **ROWS BETWEEN 1 PRECEDING AND 1 FOLLOWING**  
  Includes the current row, one row before, and one row after .
- **ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING**  
  Includes all rows in the partition , regardless of the current row's position.
- **ROWS BETWEEN 3 PRECEDING AND 2 FOLLOWING**  
  Includes the current row, three rows before, and two rows after.

---

### Visual Example of Partitions and Frames

Suppose you have a student table with columns: name, branch, and marks. The data is partitioned by branch (EEE and CSE). Each branch forms its own group. When applying a window function, each frame is calculated within its partition.

---

### Code Examples: Using Frames in Window Functions

To find the student with the maximum CGPA:

```sql
SELECT *, FIRST_VALUE(name) OVER(ORDER BY cgpa DESC) AS max_cgpa_student
FROM temp.students;
```

To find the student with the minimum CGPA:

```sql
SELECT *, LAST_VALUE(name) OVER(ORDER BY cgpa ASC) AS min_cgpa_student
FROM temp.students;
-- Note: By default, the frame is RANGE BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW,
-- so you may need to adjust the frame for correct results.
```

---

![alt text](<first&lat value.png>)

**Summary:**  
Frames let you control which rows are used in window function calculations, making SQL analytics flexible for tasks like finding running totals, ranks, or min/max values within specific groups.
