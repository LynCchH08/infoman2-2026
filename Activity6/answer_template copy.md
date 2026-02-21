

## Query Analysis and Optimization


### Scenario 1: The Slow Author Profile Page

**Before Query Plan and Execution times**
![](image\Image1.PNG)
**After Query Plan and Execution times**
![](image\Image2.PNG)

```


**Query:**
```sql
--- Provide the query
```

**Analysis Questions:**
*   What is the primary node causing the slowness in the initial execution plan?
<u>The main reason it was slow is the Sequential Scan, because the database had to read the whole table row by row instead of quickly jumping to the matching data using an index.
</u>
*   How can you optimize both the `WHERE` clause filtering and the `ORDER BY` operation with a single change?
<u>You can optimize both the WHERE filtering and the ORDER BY at the same time by creating one composite index that matches both columns in the correct order.</u>
*   Implement your fix and record the new plan. How much faster is the query now?
<u>Place your answer here</u>


### Scenario 2: The Unsearchable Blog

**Before Query Plan and Execution times**

![](image\Image3.PNG)




**Query:**
![](image\Image4.PNG)


**Analysis Questions:**
*   First, try adding a standard B-Tree index on the `title` column. Run `EXPLAIN ANALYZE` again. Did the planner use your index? Why or why not?
<u>The planner did not use the index because a normal B-Tree index does not support pattern searches with a leading wildcard (%). It falls back to a sequential scan.</u>
*   The business team agrees that searching by a *prefix* is acceptable for the first version. Rewrite the query to use a prefix search (e.g., `database%`).
<u>SELECT *FROM postsWHERE title LIKE 'database%';
This uses a prefix search, allowing PostgreSQL to use the B-Tree index on title.</u>
*   Does the index work for the prefix-style query? Explain the difference in the execution plan.
<u>Yes, the index works with prefix search because PostgreSQL can use the ordered B-Tree index to quickly locate rows starting with that prefix, avoiding a full table scan.</u>

### Scenario 3: The Monthly Performance Report

**Before Query Plan and Execution times**

![](image\Image5.PNG)




**Query:**

![](image\Image6.PNG)


**Analysis Questions:**
*   This query is not S-ARGable. What does that mean in the context of this query? Why can't the query planner use a simple index on the `date` column effectively?
<u>The query is not SARGable because it applies a function to the date column, preventing PostgreSQL from using the index efficiently. The planner can’t use a simple index because it must compute the function for every row instead of searching the indexed date values directly.</u>
*   Rewrite the query to use a direct date range comparison, making it S-ARGable.
<u>SELECT *FROM postsWHERE date >= '2024-01-01' AND date <  '2025-01-01';</u>
*   Create an appropriate index to support your rewritten query.
<u>CREATE INDEX idx_posts_date ON posts(date);</u>
*   Compare the performance of the original query and your optimized version.
<u>By making the query SARGable and adding a B-Tree index on date, execution time drops dramatically — often hundreds of times faster on large tables.</u>

---

## Submission and Rubric (20 Points Total)

Please submit the following:

1.  Your final `schema_postgres.sql` file.
2.  A separate SQL file named `indexes.sql` containing all the `CREATE INDEX` statements you used to optimize the queries.
3.  A Markdown document containing your analysis for each of the four scenarios. This document must include:
    *   The "before" and "after" execution plans from `EXPLAIN ANALYZE`.
    *   The provided queries for each scenario with EXPLAIN ANALYZE
    *   Your answers to the analysis questions for each scenario.


