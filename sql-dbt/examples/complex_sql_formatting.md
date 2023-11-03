```sql
select a.foo
     , b.baz
     , c.bar
     , case when condition
            then 1
            when thing != another_thing
             and other_condition
            else this
        end as some_column_name
     , count(1) as rowcount
  from some_table a
  join other_table b on b.some_id = a.id
  left join yet_another_table c on c.some_id = a.id
 where b.baz = true
       and c.counter >= 1
 group by
       a.foo
     , b.baz
 order by
       rowcount desc
```