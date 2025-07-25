# Publishing Gems with GitHub Packages

> :warning: **IMPORTANT**: Ensure that the `gem-release` gem is included in your application's Gemfile. It is required for all subsequent steps outlined in this guide.

## Versions

To release a new version run `gem bump`, which will update the version and create a version commit.

| Change | Flag     |
| ------ | -------- |
| Major  | -v major |
| Minor  | -v minor |
| Patch  | -v patch |

Run `gem bump --help` for more information and options.

## Building

Run `gem build` which will create your gem file to be published, ex: `rubocop-buoy-0.1.0.gem`.

## Publishing

Create a Personal access token (classic) with `write:packages` scope and store it in your `~/.gem/credentials` file:

See [Managing your personal access tokens](https://docs.github.com/en/authentication/keeping-your-account-and-data-secure/managing-your-personal-access-tokens) for more information.

```yaml
---
:github: Bearer [TOKEN]
```

Ensure your `~/.gem/credentials` file has 0600 permissions, if not run `chmod 0600 ~/.gem/credentials`.

Then run the following example command to publish the new gem replacing the `.gem` file with the one you built using `gem build`:

```sh
gem push --key github --host https://rubygems.pkg.github.com/BuoySoftware rubocop-buoy-0.4.0.gem
```

## Tagging

Once your Pull Request is fully merged into origin/main, best practice is to tag the version in GitHub. For example, if
the new version is 0.4.0 the following steps would apply:

1. Ensuring you are on up-to-date `main`
2. `git tag -a v0.4.0 -m "Version 0.4.0"`
3. `git push origin v0.4.0`

[Rubocop-buoy Example](https://github.com/BuoySoftware/rubocop-buoy/tags)
