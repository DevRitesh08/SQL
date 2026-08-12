## WHERE vs HAVING

- **WHERE**: Filters rows before any grouping is applied. It is used with SELECT, UPDATE, and DELETE statements. (**Row-level filtering**)
```sql
SELECT *
FROM Employees
WHERE salary > 50000;
```
**"Kaunse employees ki salary > 50k hai?"** : It filters individual rows.

- **HAVING**: Filters groups after the GROUP BY clause has been applied. It is used only with SELECT statements and is typically used in conjunction with aggregate functions like COUNT, SUM, AVG, etc.    (**Group-level filtering**)
```sql
SELECT department_id, AVG(salary) AS avg_salary
FROM Employees
GROUP BY department_id
HAVING AVG(salary) > 60000;
```
**"Kaunse departments ka average salary > 60k hai?"** : It filters groups of rows after aggregation.

Here SQL first forms groups:

```text
IT → 60k, 70k, 40k
HR → 80k, 50k
```

Then calculates:

```text
IT → 56.67k
HR → 65k
```

Then `HAVING` removes IT.

So final:

```text
HR → 65k
```

`GROUP BY` essentially produces one result row per group, and `HAVING` filters those resulting groups.


### ⚠️ Classic interview trap

People often write:

```sql
SELECT department_id, COUNT(*)
FROM Employees
WHERE COUNT(*) > 5
GROUP BY department_id;
```

❌ Wrong.

Why?

Because `WHERE` operates on **individual rows**, while `COUNT(*)` only exists meaningfully **after grouping**.

Correct:

```sql
SELECT department_id, COUNT(*) AS employee_count
FROM Employees
GROUP BY department_id
HAVING COUNT(*) > 5;
```

This distinction is explicitly highlighted as a recurring interview pattern.

## 🔥 But `WHERE` + `HAVING` together is VERY important

This is where interviews become interesting.

Question:

> Find departments having **more than 5 employees whose salary is above ₹50,000**.

```sql
SELECT department_id, COUNT(*) AS employee_count
FROM Employees
WHERE salary > 50000
GROUP BY department_id
HAVING COUNT(*) > 5;
```

⚠️ Another trap: **"Can `HAVING` be used without `GROUP BY`?"**

Yes.

For example:

```sql
SELECT COUNT(*)
FROM Employees
HAVING COUNT(*) > 100;
```

Find departments whose average salary is > ₹80,000, considering only employees whose salary is > ₹50,000.

```sql
SELECT department_id,
       AVG(salary) AS avg_grp_sal
FROM Employees
WHERE salary > 50000
GROUP BY department_id
HAVING AVG(salary) > 80000;
```
--don't rely on avg_grp_sal inside HAVING for portable SQL. Some databases allow aliases there, some don't. The safe interview answer is HAVING AVG(salary) > 80000.


🧠 **Lock this in**

Don't memorize:

> "WHERE doesn't work with aggregates."

Memorize:

> **WHERE → filters rows**  
> **GROUP BY → creates groups**  
> **HAVING → filters groups**

That's much more powerful because it'll help you solve unfamiliar questions.

# SQL Logical Processing Order

The **logical processing order** of a SQL query is:

```text
FROM
  ↓
WHERE
  ↓
GROUP BY
  ↓
HAVING
  ↓
SELECT
  ↓
ORDER BY
```

That's why this works:

```sql
WHERE salary > 50000
```

before:

```sql
AVG(salary)
```

And this doesn't:

```sql
WHERE AVG(salary) > 70000
```

because the average hasn't been calculated at the `WHERE` stage.

---

## GROUP BY + HAVING Example

```sql
SELECT department_id,
       COUNT(department_id) AS emp_count,
       AVG(salary) AS avg_salary
FROM Employees
GROUP BY department_id
HAVING AVG(salary) > 70000
   AND COUNT(department_id) > 5;
```

---

## ⚠️ Small but Important `COUNT()` Point

For counting employees, I'd normally write:

```sql
COUNT(*)
```

rather than:

```sql
COUNT(department_id)
```

Why?

- `COUNT(*)` → counts rows.
- `COUNT(department_id)` → counts only rows where `department_id` is **NOT NULL**.

So for **"number of employees"**:

```sql
COUNT(*)
```

is the safer mental default.

---

## `COUNT(*)` vs `COUNT(column)`

Suppose this department has:

| employee | department_id | salary |
|---|---|---:|
| A | IT | 60k |
| B | IT | NULL |
| C | IT | 80k |

What will these return?

```sql
COUNT(*)
```

vs.

```sql
COUNT(salary)
```

### 🧠 Lock this in

```text
COUNT(*)       → counts rows
COUNT(column)  → counts non-NULL values
AVG(column)    → ignores NULLs
```

This **NULL + aggregate** combination is a very high-value interview trap.

---

## 🎯 Quick Trap

What does this return if the table has **10 rows**, but `salary` is `NULL` in all 10?

```sql
COUNT(*)
COUNT(salary)
AVG(salary)
```

Answer:

```text
COUNT(*)       → 10
COUNT(salary)  → 0
AVG(salary)    → NULL
```

### 🧠 Why is `AVG(salary)` `NULL`, not `0`?

Because there are no non-NULL salary values to average.

Think:

> `AVG()` asks: **"Average of what?"**

If the answer is **nothing**, SQL gives you `NULL`, not `0`.

So:

```text
10 rows exist
    ↓
COUNT(*) = 10

0 salaries have values
    ↓
COUNT(salary) = 0

Nothing to average
    ↓
AVG(salary) = NULL
```

### ⚠️ Interview trap

This is different from a real average of zero.

- `AVG(salary) = 0` → there are values and their average is zero.
- `AVG(salary) = NULL` → **there were no usable values to calculate an average.**

Also remember:

> **`NULL` ≠ 0**  
> **`NULL` ≠ empty string**  
> **`NULL` means missing/unknown value**

---

## ⚠️ Interview Trap: `NULL` vs `0`

This is different from a real average of zero.

```text
AVG(salary) = 0
→ There are values and their average is zero.

AVG(salary) = NULL
→ There were no usable values to calculate an average.
```

Also remember:

```text
NULL ≠ 0
NULL ≠ empty string
NULL = missing/unknown value
```

# 🔥 Next: `NULL` Comparisons

This is where SQL gets unintuitive.

Suppose:

| Employee | Salary |
|---|---:|
| A | 50000 |
| B | NULL |
| C | 70000 |

You might instinctively write:

```sql
SELECT *
FROM Employees
WHERE salary = NULL;
```

❌ **This does NOT find B.**

You need:

```sql
SELECT *
FROM Employees
WHERE salary IS NULL;
```

And:

```sql
WHERE salary IS NOT NULL
```

for non-NULL salaries.

### 🧠 Desi intuition

`NULL` isn't a value like `0`.

It's more like:

> **"Bhai, salary ka pata hi nahi hai."**

So asking:

> `salary = NULL`

is basically asking:

> "Is this unknown thing equal to this other unknown thing?"

SQL doesn't treat that as `TRUE`.

That's connected to SQL's **three-valued logic**:

```text
TRUE
FALSE
UNKNOWN
```

For now, don't go deep into the formal logic. Just lock in:

> **`NULL` → use `IS NULL` / `IS NOT NULL`**