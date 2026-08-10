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