# Overview
This document describes the how SQL and dbt resources should be created in our 
repository. 

## Pull Request Submission
- Use the [pull request quality checklist](examples/pull_request_quality_check.md) for every PR

## SQL Style and Formatting 
- Use correct [SQL alignment](examples/complex_sql_formatting.md) 
- Use one expression per line [aka write tall](examples/writing_tall.md)
- Use [leading commas](examples/leading_commas.md) for field names
- Use lower case keywords in SQL statements
- Prefer listing field names over "select *" 
- Prefer listing group by fields over group by all 
- Use field names in grouping/ordering clauses
- Don't use positional indictors like 1,2,3 in grouping/ordering clauses
- Prefer [aliasing table names](examples/aliasing_tables.md) over the full table name
- Use ["on" syntax in joins](examples/on_syntax_in_sql_joins.md) (SQL-99 joins)
- Prefer judicious use of left joins
- Avoid using right joins and outer joins
- Prefer using count when counting and sum when summing

## dbt Style Guide
- Prefer keeping [subqueries simple](examples/minimal_subqueries.md)
- Use a pass-through CTE [declaration block](examples/declaration_block.md) 
  at the beginning of the model.
- Use [closed CTEs](examples/close_ctes.md) and implement a select * from the final 
  CTE.
- Use staged CTEs for resuable queries
- Prefer "right size" final CTE files (about 3-4 CTEs total)
- Use upstream models in staging for more complex models
- Use DAGs when appropriate to stage models that can be run simultaneously

## Models
- Use a [config block](examples/config_block.md) for all models

## Naming
- Use dim_ prefix for dimension tables
- Use fact_ prefix for fact tables
- Don't prefix other tables
- Use unique table names
- Use schema prefixes for model names, e.g stg__ for staging and main__ for main
- Use plural table names, e.g, **appointment_events** rather than 
  appointment_event
- Prefer renaming Rails id field to the singular table name _id 
  e.g. the id field from the visits table becomes visit_id
- Avoid reserved words and function names as field names. If you must use a 
  reserved word add an underscore to the beginning of the word, e.g. _rank 
  instead of rank
- Use snake_case for table names and field names

## Types
- Use explicitly cast data types for fields that must be a specific data type

## Monetary values
- Monetary values should be cast as **decimal(38,2)** 

## General Cautions
- Prefer deterministic functions over non-deterministic functions like 
  current_time(), current_date(), etc. 