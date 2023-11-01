# Overview
This document is intended as a living document to describe how our code should 
look when submitted to our GitHub repo.  Rather than being “set in stone” it is 
a record of what the team has decided up on in the past, so that it can be 
revised in the future if necessary. 

## General Guidelines for Pull Request Submission

These guidelines are reflected in our [Pull Request Quality Checklist](https://www.notion.so/Pull-Request-Quality-Check-959bf57a20904a62aea222994de8befe?pvs=21) 
document. 

- Clean code
    - Remove unused code before PRs are submitted to keep the repo clean
    - Follow standards laid out in our SQL and dbt Style Guide below
- Proper testing
    - Using the Pull Request Quality Checklist to make sure your code runs 
      locally and in Docker Compose to preserve the quality of the main branch
        - This is especially important given that when we merge to main, that is 
          the branch that our production code runs from.  We do not currently 
          have staging to “pre-test” code breakages for us.  Our diligence in 
          testing ensures that our pipelines stay up and running.

## SQL Style and Formatting Guide

### Formatting

Formatting is how your code is physically arranged.

### Leading Commas

### Alignment
Use some form of standard alignment and indentation strategy for your queries.  
I prefer to use the “select” keyword to anchor around in order to organize code.   
By using a consistent method, we know what to expect when code is submitted and 
most importantly, we reduce the cognitive load of the person who is reviewing 
the code.   Note the alignment in the below example.  I use the t in the “select” 
keyword to organize the rest of my code.  Leading commas are aligned with the “t” 
in select, and other keywords are left indented to line up with the “t” in select.

```sql
SELECT a
     , b
     , c
  FROM my_table
 WHERE a = b
```

### Use Leading Commas and Write Tall (One Expression Per Line)
It’s pretty simple.  SQL has a “trailing comma” problem that I dealt with for 
years before learning about leading commas.  

When writing “tall” sql (one column name per row) if you need to comment out the 
last column in the list, the previous row ends up with a trailing comma.

```sql
SELECT a,
       b, <<-- the previous line ends up with a trailing comma.
    -- c 
  FROM my_table
```
Whereas with leading commas, you can mark out any row at will except for the 
first value, which generally is an id field or something similar that rarely 
changes.

```sql
SELECT a
     , b 
   --, c <<-- no trailing comma and no need to remove one>>
  FROM my_table
```
Since it is far more common to add columns to the end of the list as your query 
grows, the leading commas make it easy to test and add columns. 

### Upper Case Keywords

All SQL keywords should be UPPER CASE

### Complex Formatting Example

```sql
SELECT a.foo
     , b.baz
     , c.bar
     , CASE WHEN condition
            THEN 1
            WHEN thing != another_thing
             AND other_condition
            ELSE this
        END AS some_column_name
     , count(1) AS rowcount
  FROM some_table a
  JOIN other_table b ON b.some_id = a.id
  LEFT JOIN yet_another_table c ON c.some_id = a.id
 WHERE b.baz = true
       AND c.counter >= 1
 GROUP BY
       a.foo
     , b.baz
 ORDER BY
       rowcount DESC
```

### SQL Style

### Judicious use of select * and group by all

In general we want to be very upfront about what we are selecting in a given 
query.  It’s fine to use select * when it makes sense, but at least once in the 
code you should explicitly define which columns are being selected for ease of 
reading and comprehension. 

“group by all” is new in Snowflake, but has a similar issue, in general we want 
to write out explicitly which fields we are grouping by.

### Avoid grouping/ordering by positional indicators

This follows along with the previous guideline to use select * judiciously.   
We should also be writing out our group by fields by name rather than using 
positional numbers like 1,2,3.   Positional numbers are fine when there are 
only a few columns, but when you get out to more than 5 or so it’s easy to lose 
track of which actual columns are being grouped by. 

### Aliasing tables

In the data warehouse we will be working on cross-database queries where many of 
the names of table and ids will be the same.  Therefore we need to prefer 
aliasing table names to indicate which table the column has come from.  There is 
no need to use a full table name, just using the initial letters of the table 
name is fine.  So for example the table name apheresis_machine_setups would be 
aliased as ams.

```sql
SELECT ams.id AS machine_id
     , ams.occurred_on
     , sg.lot_number
     , sg.id AS soft_goods_id
  FROM aphereas_machine_setups ams
  JOIN soft_goods sg ON sg.id = ams.soft_good_id
```

In the above example, every column clearly indicates which table the field 
originates from and is concise to read. 

### Use “on” syntax in joins (SQL-99 joins)

```sql
SELECT a.id
     , b.value
  FROM some_table a 
  JOIN other_table b ON b.some_table_id = a.id
```

### Judicious use of left joins

Left joins are good in certain circumstances but not others.  Think about the 
use of left joins in a given table and have good reasons for using them.  What 
do the nulls created by left joins indicate?  How will the user/analytics tool 
use these records? etc. 

### Avoid right joins and outer joins in general

Right and outer joins are tricky so we should avoid them when possible (and it’s 
almost always possible!).  Outer joins in particular can get into performance 
issues quickly. 

### Use “count” when counting things

In many cases count and sum give the same result.  So which keyword should you 
use?  Use count when counting things, and sum when summing things, just to keep 
it simple.

## dbt Style Guide

### CTEs

### Minimize Subqueries

All models should be written in CTE style with very minimal use of subqueries 
(aka inline views) allowed.   Subqueries are fine when they are referencing 
an upstream CTE effectively used as an exclusion set, e.g:

```sql
WITH id_set AS
(
SELECT id 
     , name
     , address 
     , timestamp 
  FROM my_table 
 WHERE (id NOT IN some_other_table)
)
SELECT * FROM id_set 
```

In the above example, the subquery is on one line and very easy to read. 
More complex subqueries should be made into a CTE. 

### Use a Declaration Block

All models should use a pass-through CTE declaration block at the beginning 
of the model.

```sql
WITH audit_logs AS (SELECT * FROM {{ ref('buoyrails__audit_logs')}} )
, employees AS (SELECT * FROM {{ ref('buoyrails__employees')}} )
, sample_reviews AS (SELECT * FROM {{ ref('buoyrails__sample_reviews')}} )
```

This distills the ref syntax down to a more manageable, readable style, 
though it is annoying to have to do so. 

### Close all CTEs

Close all CTEs and implement a select * from the final cte:
```sql
WITH my_first_cte AS
(
SELECT *
  FROM some_table
)
, my_summary_cte AS
(
SELECT sum(field_a)
     , id
  FROM my_first_cte
 GROUP BY id
)
SELECT * FROM my_summary_cte
```

### Stage Reusable CTEs

CTEs that can be re-used across multiple models should be abstracted into 
staging so they can be used in other models. 

### “Right Size” your CTEs

In general, the file that shows up in our “main” schema should be about 3-4 CTEs 
long. Use your judgment on this, and there is absolutely room for making them 
longer or shorter but in general the final file should be reasonably short.   
Large models that have dozens of CTEs should definitely be in multiple files in 
staging. 

### Use DAGs for parallel processing

DBT can process tables in parallel to build the model faster.  If you know that 
you have several tables that will eventually feed a final model, break those 
files up into individual files to process in parallel.   This is, again, a 
“right size” thing that’s up to the judgment of who is writing the model, but 
definitely something to have in mind when creating large models.

## Models

### config block

All models in the analytics database that are in the main schema should have a 
config block at the top that looks like this: 

```sql
{{ config(
    alias="dim_visits",
    tags=["hourly"],
    post_hook=[
      "grant select on {{ this }} to share {{ env_var('SNOWFLAKE_SHARE') }};"
    ]
) }}
```

- the alias field is what the table name will appear as in Snowflake
- the tag field indicates how frequently the model should be run
- the post_hook field is necessary to share the table with Join Parachute
- …and more to come, it’s likely we’ll leverage the config block more going 
  forward

## Naming

### dim and fact tables

dim and fact tables should be prefixed with either dim_ or fact_ (not fct_ which 
is officially dbt standard, but I think is ambiguous - when I see fct I think 
“function” not “fact”)

Tables that are NOT dim or fact tables, or are downstream of either, should not
be prefixed with anything.  Tables without a prefix indicate that they are 
fully realized assets that can be used as-is in analysis.

### Unique table names

Where possible, all table names should be unique and indicate what is in the 
table.  We generally do not want to repeat a name that is an underlying table 
name, as it becomes unclear which table is being referred to.   This standard 
is already a little bit broken because of the legacy tables, but as we update 
those we should be creating unique table names that indicate what the table 
contains. 

### Plural table names

In keeping with the source Rails standard of plural table names, continue to use 
plural table names.  So a table that has appointment events should be named 
**appointment_events**, not appointment_event. 

### Rename id fields

Rails standard is just “id” as the unique identifier in a given table.  We want 
to more clearly reflect the source of that id, so rename the id to the table 
name underscore id as a singular (as opposed to plural) word.  So the id from 
the visits table would be visit_id, and the id from the donations table would be 
donation_id.   I’m sure there will be exceptions, and if so, please be ready to 
explain the exception (or include why you did that in your pull request). 

### Avoid reserved words

In general, avoid reserved words when naming either tables or fields.   It’s 
common to prefix a reserved word with an _ in SQL, e.g. _rank instead of rank if 
you are using a field that is the same name as a function or a reserved word. 

## Types

### Explicit casting

Due to the way dbt builds tables there is no way to tell it declaratively what a 
field type should be as with a “create table” statement.   If you are concerned 
about how dbt is automatically changing a field, you can cast it in SQL. 

### Monetary values

Monetary values should be cast as **decimal(38,2)** unless there is a really 
good reason not to.  If you have a reason, share with the group!

## Things to Avoid

### Avoid non-deterministic functions

Avoid non-deterministic functions like current_timestamp and random().  
The “current” time-based functions (like current_date, current_time, 
current_timestamp) are based on the time of the execution of the model as well 
as the time of the system.  I have included a current_timestamp function on a 
couple of tables simply to indicate when dbt last ran. This is an appropriate 
use of these functions in a limited scope.