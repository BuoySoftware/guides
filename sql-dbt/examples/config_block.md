```sql
{{ config(
    alias="dim_visits",
    tags=["hourly"],
    post_hook=[
      "grant select on {{ this }} to share {{ env_var('SNOWFLAKE_SHARE') }};"
    ]
) }}
```