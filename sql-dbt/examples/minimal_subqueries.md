```sql
with id_set as
(
select id 
     , name
     , address 
     , timestamp 
  from my_table 
 where (id not in some_other_table)
)
select * from id_set 
```