```sql
select ams.id as machine_id
     , ams.occurred_on
     , sg.lot_number
     , sg.id as soft_goods_id
  from apheresis_machine_setups ams
  join soft_goods sg on sg.id = ams.soft_good_id
```