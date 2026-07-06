# Ruby

- Avoid optional parameters. Does the method do too much?
- Avoid monkey-patching.
- Generate necessary [Bundler binstubs] for the project, such as `rake` and
  `rspec`, and add them to version control.
- Prefer classes to modules when designing functionality that is shared by
  multiple models.
- Prefer `private` when indicating scope. Use `protected` only with comparison
  methods like `def ==(other)`, `def <(other)`, and `def >(other)`.

[bundler binstubs]: https://github.com/sstephenson/rbenv/wiki/Understanding-binstubs

## Style enforced by RuboCop

These conventions are checked automatically by [rubocop-buoy]; you don't need
to police them by hand. They're documented here so the intent is explicit for
both humans and AI agents — the "why" isn't obvious from a lint failure alone.

- Prefer nested class and module definitions over the compact `Foo::Bar`
  shorthand. Nesting keeps `Module.nesting` and constant lookup predictable, so
  references resolve against the enclosing namespace as written.
  ([`Style/ClassAndModuleChildren`], `EnforcedStyle: nested`)
- Prefer the shorter, more idiomatic `Enumerable` names over their aliases —
  `detect` over `find`, `select` over `find_all`, `map` over `collect`, and
  `reduce` over `inject`. Picking one name per operation keeps the codebase
  consistent and greppable. ([`Style/CollectionMethods`])
- Name predicate methods with a `?` suffix and no `is_` prefix (`even?`, not
  `is_even`). The `?` already signals a boolean answer, so the prefix is
  redundant. ([`Naming/PredicatePrefix`])

[rubocop-buoy]: https://github.com/BuoySoftware/rubocop-buoy
[`Style/ClassAndModuleChildren`]: https://docs.rubocop.org/rubocop/cops_style.html#styleclassandmodulechildren
[`Style/CollectionMethods`]: https://docs.rubocop.org/rubocop/cops_style.html#stylecollectionmethods
[`Naming/PredicatePrefix`]: https://docs.rubocop.org/rubocop/cops_naming.html#namingpredicateprefix

## Bundler

- Specify the [Ruby version] to be used on the project in the `Gemfile`.
- Use a [pessimistic version] in the `Gemfile` for gems that follow semantic
  versioning, such as `rspec`, `factory_bot`, and `capybara`.
- Use a [versionless] `Gemfile` declarations for gems that are safe to update
  often, such as pg, thin, and debugger.
- Use an [exact version] in the `Gemfile` for fragile gems, such as Rails.

[ruby version]: http://bundler.io/v1.3/gemfile_ruby.html
[exact version]: http://robots.thoughtbot.com/post/35717411108/a-healthy-bundle
[pessimistic version]: http://robots.thoughtbot.com/post/35717411108/a-healthy-bundle
[versionless]: http://robots.thoughtbot.com/post/35717411108/a-healthy-bundle

## Ruby Gems

- Declare dependencies in the `<PROJECT_NAME>.gemspec` file.
- Reference the `gemspec` in the `Gemfile`.
- Use [Appraisal] to test the gem against multiple versions of gem dependencies
  (such as Rails in a Rails engine).
- Use [Bundler] to manage the gem's dependencies.
- Use continuous integration (CI) to show build status within the code review
  process and to test against multiple Ruby versions.

[appraisal]: https://github.com/thoughtbot/appraisal
[bundler]: http://bundler.io

## Ruby JSON and GraphQL APIs

- Review the recommended practices outlined in Heroku's [HTTP API Design Guide]
  before designing a new API.
- Write [request specs] for your API.
- When the primary consumer of the API is a JavaScript client maintained within
  the same code base as the provider of the API, write [feature specs].

[http api design guide]: https://github.com/interagent/http-api-design
[feature specs]: https://www.relishapp.com/rspec/rspec-rails/docs/feature-specs/feature-spec
[request specs]: https://www.relishapp.com/rspec/rspec-rails/docs/request-specs/request-spec
