# Guides

Guides for working together, getting things done, programming well, and
programming in style.

Our guides are heavily influenced by [thoughtbot guides]. If our guides
do not cover your particular topic, review their guides for guidance.

[thoughtbot guides]: https://github.com/thoughtbot/guides

## High level guidelines

- Be consistent.
- Don't rewrite existing code to follow this guide.\*
- Don't violate a guideline without a good reason.
- A reason is good when you can convince a teammate.

## A note on the language

- "Avoid" means don't do it unless you have good reason.
- "Don't" means there's never a good reason.
- "Prefer" indicates a better option and its alternative to watch out for.
- "Use" is a positive instruction.

## Guides by category

- [General](general/README.md)

## Collaboration

- [Code Review](code-review/README.md)
- [Terminology](terminology/README.md)
- [Working Together](working-together/README.md)

## Languages

- [HTML](html/README.md)
- [Ruby](ruby/README.md)
- [SQL-dbt](sql-dbt/README.md)
- [Typescript](typescript/README.md)
- [Terraform](terraform/README.md)

## Frameworks and platforms

- [Rails](rails/README.md)
- [React](react/README.md)
- [Testing with RSpec](testing-rspec/README.md)
- [Testing with Jest](testing-jest/README.md)

## Protocols

- [Authorization](authorization/README.md)
- [Change Requests](change-requests/README.md)
- [Code Design](code-design/README.md)
- [Feature Flags](feature-flags/README.md)
- [Migrations](migrations/README.md)
- [Web Monitoring](web-monitoring/README.md)

## Testing

- [Automation](automation/README.md)

## Recommended Editor / IDE Setup

- [VSCode](editor-setup/vscode.md)

## Tools

- [Git](git/README.md)
- [GraphQL](graphql/README.md)
- [PostgreSQL](postgresql/README.md)

## Other

- [AWS](aws/README.md)
- [Kubernetes](kubernetes/README.md)
- [Recommended Reading](reading.md)
- [Responsibilities & Rituals](rituals/README.md)
- [Tools](tools/README.md)
- [Publishing Gems with GitHub Packages](ruby/gems.md)

## *Rewriting with tools

An exception to the guideline "Don't rewrite existing code to follow this
guide" is that when making a change that a tool such as Rubocop or TSC can
automatically fix, allow it to. This avoids unnecessary warnings in editors with
integration with these tools.

When updating with a tool that can autofix, follow up with a commit to add the
SHA of the autofix commit to each project's `.git-blame-ignore-revs` file.
**Note that these must occur in separate commits** and that the SHA in the
second commit needs to be updated if the first commit is rebased. This can be
done in one Pull Request if you do rebasing manually or can be done as a
follow-up Pull Request as well. See [this blog
post](https://calebhearth.com/rubocop-git-blame) for details on why this is
necessary.
