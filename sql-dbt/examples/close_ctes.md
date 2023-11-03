```sql
with my_first_cte as
(
select *
  from some_table
)
, my_summary_cte as
(
select sum(field_a)
     , id
  from my_first_cte
 group by id
)
select * from my_summary_cte
```