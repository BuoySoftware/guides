# Migrations

Any time there is need to change the schema or data stored in the application
database with a given group of work, write a migration.
- Don't change a migration after it has been merged into `main` if the desired
  change can be solved with another migration.
- Schema migrations should always follow a [strong migration] pattern.
- Schema migrations and data migrations should be kept separate.
- We use the [`strong_migrations`], [`fx`], and [`data_migrate`] gems, along
  with a 3 phase approach for any change where we are renaming or moving columns
  around. These phases should happen over 3 different release versions. _Note:
  may end up being one client release, so care must be taken when that happens._
  - Phase 1:
    - _Code_ - Add deprecation warnings for old attribute.
    - _Schema Migration_ - Create new column in the appropriate table.
    - _Function_ Create function to duplicate data from old to new column.
    - _Trigger_ - Create trigger to run function on old column.
    - _Schema Migration_ - Add phase 1 trigger and function.
    - _Data Migration_ - Create a backfill from old to new column.
  - Phase 2:
    - _Code_ - Move reads from old to new column & ignore old column.
    - _Schema Migration_ - Remove phase 1 function and trigger.
    - _Function_ Create function to duplicate data from new to old column.
    - _Trigger_ - Create trigger to run function on new column.
    - _Schema Migration_ - Add phase 2 trigger and function.
  - Phase 3:
    - _Code_ - Remove deprecation warnings for old attribute.
    - _Functions and Triggers_ - Remove all function and trigger.
    - _Schema Migration_ - Remove phase 2 function and trigger.
    - _Schema Migration_ - Remove old column.

## Functions

- The [`fx`] gem is used to create custom function that can later be called via
  SQL.
- Stored in `db/functions`.
- Added to the database via `create_function` schema migrations.
- Removed from the database via `drop_function` schema migrations.
- Written in `plpgsql`, [SQL Procedural Language] for PostgresSQL.

## Triggers

- The [`fx`] gem is used to create event [triggers] that fire when the given
  event happens.
- Stored in `db/triggers`.
- Added to the database via `create_trigger` schema migrations.
- Removed from the database via `drop_trigger` schema migrations.

## Schema Migrations

- These are standard rails migrations, they are stored in `db/migrate`.
- No data should be migrated in these.
- Since there are no data, there should be no references to models.
- If there are default values, set them in migrations.
- [Add foreign key constraints] in migrations.
- Add appropriate indexes.

## Data Migrations

- Document data changes in either the Asana task that spawned the data change
  need or in its own task (e.g. [Backfill overdraw & underdraw events])
  - Notify appropriate teams of the change and link them to the task for
  transparency.
  - When in doubt, attach CSVs or screenshots from data clips generated from
  before the migration and after it was complete to the ticket.
- Prefer having another engineer verify the data change, [[Four Eyes Principle]]
- Use the `DataChange` utility to track changes.
- Use SQL, not `ActiveRecord` models, in data migrations.
- Depending on need data migrations fall into three use cases as follows.


### Data Migrate Gem

- We use the [`data_migrate`] gem for managing data migrations.
- This should be the default data migration method.
- These are run interwoven with the schema migrations.
- They are stored in `db/data`.
- Use the generator `rails g data_migration some_new_data_migration`.
- Make them reversible in case we have to rollback.

### Temporary Rake Task

- We use these if a migration should not be tied to a deploy. Examples:
  - Long running migrations.
  - Feature releases.
  - Needs to be run multiple times.
  - Validate the integrity of other data migrations.
- These need to be run manually.
- They are stored in `lib/tasks/tmp`.

[strong migration]: https://blog.appsignal.com/2024/03/20/good-database-migration-practices-for-your-ruby-on-rails-app-using-strong-migrations.html
[`strong_migrations`]: https://github.com/ankane/strong_migrations
[`fx`]: https://github.com/teoljungberg/fx
[`data_migrate`]: https://github.com/ilyakatz/data-migrate
[SQL Procedural Language]: https://www.postgresql.org/docs/current/sql-createfunction.html
[triggers]: https://www.postgresql.org/docs/current/sql-createtrigger.html
[Add foreign key constraints]: http://robots.thoughtbot.com/referential-integrity-with-foreign-keys
[Backfill overdraw & underdraw events]: https://app.asana.com/0/1204148179532667/1209173110752566/f
[Four Eyes Principle]: https://www.openriskmanual.org/wiki/Four_Eyes_Principle
