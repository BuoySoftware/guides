# Rails

A guide for building great Rails apps.

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
- Use `ENV.fetch` for environment variables instead of `ENV[]`so that unset environment variables are detected on deploy.
