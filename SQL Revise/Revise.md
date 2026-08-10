## WHERE vs HAVING

- **WHERE**: Filters rows before any grouping is applied. It is used with SELECT, UPDATE, and DELETE statements.
```sql
SELECT *
FROM Employees
WHERE salary > 50000;
```
**"Kaunse employees ki salary > 50k hai?"** : It filters individual rows.

- **HAVING**: Filters groups after the GROUP BY clause has been applied. It is used only with SELECT statements and is typically used in conjunction with aggregate functions like COUNT, SUM, AVG, etc.
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