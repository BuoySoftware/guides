```sql
select a.id
     , b.value
  from some_table a 
  join other_table b on b.some_table_id = a.id
```