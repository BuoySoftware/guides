# Migrations

Any time there is need to change the schema or data stored in the application
database with a given group of work, write a migration.
- Don't change a migration after it has been merged into `main` if the desired
  change can be solved with another migration.
- Schema migrations and data migrations should be kept separate.
- Schema migrations should always follow a [strong migration] pattern.

## Three Phased Approach

We use the [`strong_migrations`], [`fx`], and [`data_migrate`] gems, along
with a 3 phase approach for any change where we are renaming or moving columns
around. These phases should happen over 3 different release versions.

### Why This is Important

There are a couple of reason why we take this approach.
- Creates the most amount of safety possible without relying on data backups and
  recoveries.
- Gives the most opportunity for external systems to handle the change (e.g.
  Buoy data team, client's internal teams, etc.)

### The Phases
- Phase 1:
  - _Code_ - Add deprecation warnings for old attribute.
  - _Schema Migration_ - Create new column in the appropriate table.
  - _Database Function_ Create function to duplicate data from old to new
    column.
  - _Database Trigger_ - Create trigger to run function on old column.
  - _Schema Migration_ - Add phase 1 trigger and function.
  - _Data Migration_ - Create a backfill from old to new column.
- Phase 2:
  - _Code_ - Move reads from old to new column & ignore old column.
  - _Schema Migration_ - Remove phase 1 function and trigger.
  - _Database Function_ Create function to duplicate data from new to old
    column.
  - _Database Trigger_ - Create trigger to run function on new column.
  - _Schema Migration_ - Add phase 2 trigger and function.
- Phase 3:
  - _Code_ - Remove deprecation warnings for old attribute.
  - _Database Functions and Triggers_ - Remove all functions and triggers.
  - _Schema Migration_ - Remove phase 2 function and trigger.
  - _Schema Migration_ - Remove old column.

### Handling Multiple Releases at Once

A client may be taking multiple releases at one time. This may happen because
they have a slower release schedule than Buoy, or because of the time it takes
to verify a release. This will cause issues with our Three Phased Approach for
migrations.

For example a client might have `v1.0` and are taking `v5.0`. In that difference
there may be any number of phased migrations.

#### Interwoven Data Changes

In the above phases, in Phase 1 there is first a schema migration followed by a
data migration. In Phase 2 there are more schema migrations. Since the
possibility exists that a customer will take all three phases in one release
we need to make sure that Phase 1 schema migrations, then Phase 1 data
migrations, then Phase 2 schema migrations happen in that order. The
[`data_migrate`] gem provides this functionality for us.

The concept of interwoven data changes does not need to be limited to the 3
phased approach, but is the main cause of our usage of it. Another benefit of
interwoven data changes with schema changes is that if a data change fails, it
will fail after the schema change and not allow the rest of the migrations to
run. This allows for easier troubleshooting and follow up of migrations that did
not run.

#### Slow Roll Releases

Another way to solve this issue is to slowly roll out a release. This means
going one release at a time instead of all the way to the final release.

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
- Use SQL, not `ActiveRecord` models, in data migrations.

### Tracking Changes

In order to know what was changed and when we should track any migrations run
in our applications:

- Use the `DataChange` functionality.
- Scale data migrations based on the number of records being migrated.
  - Keep in mind all environments and clients this migration could/will execute.
  - With smaller data set changes
    - Three steps in one `DataChange` call: `pre`, `post`, `change`.
    - `pre` and `post` queries should include only records that are changing.
    - `change` query include `returning` data.
    -  All queries should return an identifier and the data that is migrating.
  - With large data set changes
    - The `pre` & `post` steps.
      - Should be in two different `DataChange` calls.
      - Could be full records or a summarized count depending on the amount of
        data being written to the `csv` files.
    - For the actual data migration step:
      - Do not use the `change` `DataChange` step.
      - Use the `find_in_batches` functionality to make the actual changes to
        manage memory usage of the migration.
      - Add a `puts` statement in the batch loop to keep session active and give
        console/log feedback of the status.

### Types of Data Migrations

Depending on need, data migrations fall into two use cases as follows.

#### Data Migrate Gem

- We use the [`data_migrate`] gem for managing data migrations.
- This should be the default data migration method.
- These are run [interwoven] with the schema migrations.
  - This is helpful when there are multiple schema migrations around.
  - See 3 Phased approach above.
- They are stored in `db/data`.
- Use the generator `rails g data_migration some_new_data_migration`.
- Make them reversible in case we have to rollback.

#### Temporary Rake Task

- We use these if a migration should not be tied to a deploy. Examples:
  - Long running migrations that don't need to be [interwoven].
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
[interwoven]: #interwoven-data-changes
