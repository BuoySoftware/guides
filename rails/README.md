# Rails

A guide for building great Rails apps.

## Migrations

- Don't change a migration after it has been merged into `main` if the desired
  change can be solved with another migration.
- If there are default values, set them in migrations.
- Use SQL, not `ActiveRecord` models, in migrations.
- [Add foreign key constraints] in migrations.

[add foreign key constraints]: http://robots.thoughtbot.com/referential-integrity-with-foreign-keys
