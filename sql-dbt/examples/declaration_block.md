```sql
with audit_logs as (select * from {{ ref('buoyrails__audit_logs')}} )
, employees as (select * from {{ ref('buoyrails__employees')}} )
, sample_reviews as (select * from {{ ref('buoyrails__sample_reviews')}} )
```