# Rails

A guide for building great Rails apps.

- Use def `self.method`, not the `scope :method`
- Use methods instead of instance variables in ViewComponent templates
- Use i18n for all text within the application.
- Name date columns with `_on` suffixes.
- Name datetime columns with `_at` suffixes.
- Name time columns (referring to a time of day with no date) with `_time` suffixes.
- Name initializers for their gem name.
- Order ActiveRecord associations alphabetically by association type, then
  attribute name.
- Order ActiveRecord validations alphabetically by attribute name.
- Order ActiveRecord associations above ActiveRecord validations.
- Order controller contents: filters, public methods, private methods.
- Order i18n translations alphabetically by key name.
- Order model contents: constants, macros, public methods, private methods.
- Use link_to for GET requests, and button_to for other HTTP verbs.
- Use new-style `validates :name, presence: true` validations, and put all validations for a given column together.
- Avoid bypassing validations with methods like `save(validate: false)`, `update_attribute`, and `toggle`.
- Avoid naming methods after database columns in the same class.
- Don't return false from `ActiveModel` callbacks, but instead raise an exception.
- Keep `db/schema.rb` or `db/development_structure.sql` under version control.
- Use `_url` suffixes for named routes in mailer views and redirects. Use `\_path` suffixes for named routes everywhere else.
- Validate the associated belongs_to object (user), not the database column (user_id).
- Use db/seeds.rb for data that is required in all environments.
- Use dev:prime rake task for development environment seed data.
- Prefer `cookies.signed` over `cookies` to prevent tampering.
- Prefer `Time.current` over `Time.now`
- Prefer `Date.current` over `Date.today`
- Prefer `Time.zone.parse("2014-07-04 16:05:37")` over `Time.parse("2014-07-04 16:05:37")`
- Use `ENV.fetch` for environment variables instead of `ENV[]`so that unset environment variables are detected on deploy.

## Migrations

Any time there is need to change the schema or data stored in the application
database with a given group of work, write a [strong migration].
- Don't change a migration after it has been merged into `main` if the desired
  change can be solved with another migration.
- Schema migrations and data migrations should be kept separate.
- We use the `strong_migration` gem, along with a 3 phase approach for any
  change where we are renaming or moving columns around. These phases should
  happen over 3 different releases.
  - Phase 1:
    - _Schema Migration_ - Create new column in the appropriate table.
    - _Code and/or Schema Migration_ - Write the same data to both old and new
      places.
    - _Data Migration_ - Create a backfill so both columns have all the data.
  - Phase 2:
    - _Code_ - Move reads from old place to the new place.
  - Phase 3:
    - _Code and/or Schema Migration_ - Stop writing to old place.
    - _Schema Migration_ - Remove old column.

### Schema Migrations

- These are standard rails migrations, they are stored in `db/migrate`.
- No data should be migrated in these.
- Since there are no data, there should be no references to models.
- If there are default values, set them in migrations.
- [Add foreign key constraints] in migrations.
- Add appropriate indexes.

### Data Migrations

- Use SQL, not `ActiveRecord` models, in data migrations.
- Depending on need data migrations are managed in two ways, `data_migrate` gem
  or one-off rake task.

#### Data Migrate Gem

- These are run interwoven with the schema migrations.
- They are stored in `db/migrate`.
- Use this method by default. Especially use with the 3 phase approach defined
  above.

#### One-off Rake Task

- These will be manually run.
- Use when the change will take a long time & can be run outside of other
  migrations.

[add foreign key constraints]: http://robots.thoughtbot.com/referential-integrity-with-foreign-keys
[strong migration]: https://blog.appsignal.com/2024/03/20/good-database-migration-practices-for-your-ruby-on-rails-app-using-strong-migrations.html
