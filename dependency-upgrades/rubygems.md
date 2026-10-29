# Dependency Upgrades: RubyGems

Commands for the checks in [Dependency Upgrades](README.md) when the PR changes `Gemfile.lock`.

## Source

The registry's metadata describes the latest version, not the PR's. Take the repository root from it and nothing else.

```sh
curl -s https://rubygems.org/api/v1/gems/<gem>.json | jq -r '.source_code_uri, .homepage_uri, .changelog_uri'
```

A URL of the form `.../tree/<tag>/<subdir>` means a monorepo; the gem lives in `<subdir>`.

## Consumption

```sh
git grep -n '<gem>' origin/main -- Gemfile config app lib packs
```

A gem named only in `Gemfile` is loaded by Bundler and used through Rails or another gem. A gem named in `config/initializers` is configured by the app; read that file.

## Lockfile

Dependencies of a gem are its indented block. Dependents of a gem are every block that lists it. Run it on the PR's copy of the lockfile, from `git show <head-sha>:Gemfile.lock`:

```sh
awk '/^    [a-z]/{cur=$1} /^      <gem>( |$)/{print cur}' Gemfile.lock | sort -u
```

A gem listed under no block in the diff moved because Dependabot re-resolved it.

A hand-made `bundle update --conservative <gem>` stops at the newest version whose dependencies do not move other gems, which can be below the latest. That is fine when the stopping version is at or above the advisory's fixed version.

A consumer can also constrain a gem at runtime with a `gem "<gem>", "< N"` call in code, which never appears in the lockfile. CI reveals it as `Gem::LoadError: can't activate`, and the message names the file. Read that file at the consumer's current tag and at its newest tag:

```sh
gh api "repos/<owner>/<repo>/contents/<path>?ref=<tag>" -H 'Accept: application/vnd.github.raw' | grep -n 'gem "<gem>"'
```

Source hosts are the `remote:` lines in `Gemfile.lock` and the `source` lines in `Gemfile`. A new `remote:` is a stop.

## Publisher

`gem owner` prompts for credentials. Use the unauthenticated endpoints.

```sh
curl -s https://rubygems.org/api/v1/gems/<gem>/owners.json | jq -r '.[].handle'   # null is an owner without a public profile: treat as unknown
curl -s https://rubygems.org/api/v1/versions/<gem>.json | jq -r '.[] | "\(.number) \(.created_at)"' | head -20
```

Each version page shows "Version published with MFA: true/false" for a manual push. A release through trusted publishing shows a Provenance block instead, naming the source commit, the build workflow, and a Sigstore log entry. The attested commit must be the tag's `^{}` commit:

```sh
curl -s https://rubygems.org/gems/<gem>/versions/<ver> | grep -i -A4 'mfa' | sed 's/<[^>]*>//g' | grep -v '^\s*$'
curl -s https://rubygems.org/gems/<gem>/versions/<ver> \
  | grep -oE 'https://github.com/[^"]+/(commit|actions/runs)/[^"/]+' | sort -u
git ls-remote --tags https://github.com/<owner>/<repo>.git | grep -E 'v?<ver>\^\{\}$'
```

## Artifact

```sh
gem fetch <gem> -v <new> --platform ruby && gem unpack <gem>-<new>.gem
gem fetch <gem> -v <old> --platform ruby && gem unpack <gem>-<old>.gem
git clone -q --depth 1 --branch <tag> https://github.com/<owner>/<repo>.git <repo>-src

diff -rq <repo>-src/<subdir> <gem>-<new> | grep -v 'Only in <repo>-src'   # 1. artifact against tag; no output means identical
diff -rN -x '*.md' <gem>-<old> <gem>-<new> > lib.diff                    # 2. new against old, with new files' contents
```

`Only in <repo>-src` lines are files the gemspec excludes (specs, CI config) and are expected. Without `-N` a file that exists only in the new version is a one-line `Only in` entry and its contents never reach the gating grep. `gem fetch` silently picks the local platform, and on arm64 macOS the `gem unpack` that follows fails; `--platform ruby` avoids that. Fetch a platform build only when its binaries are under review. A native gem's `.so` files are prebuilt binaries: report them, verify the Ruby files, and move on. Some `ruby`-platform gems ship them too: `libdatadog` carries prebuilt Linux libraries under `vendor/`, which diff 1 reports as `Only in <gem>-<new>: vendor`. That is the prebuilt-binaries finding, not a stop.

Quote-style and trailing-comma churn can be more than half of a large diff. Normalise both trees before diffing when the first diff is thousands of lines:

```sh
for d in <gem>-<old> <gem>-<new>; do find $d -name '*.rb' -exec perl -pi -e "s/\"([^\"\\\$#]*)\"/'\1'/g; s/,[ \t]*\$//" {} +; done
```

Both trees get the same rewrite. The result is for reading, not running.

## Changelog

The clone from the artifact step has it at the tag. `changelog_uri` from the registry points at the latest version and at `master`, not at the tag.

## CI log shapes

RSpec prints each failure as `Failure/Error:` followed by the error class and message, then a filtered backtrace that omits gem frames unless the error was raised inside one. The run summary is `N examples, M failures`. A `Gem::LoadError` has no gem frames; read its message.

Cucumber and feature specs print the same shapes with fewer examples per shard.

## Families

Sets that constrain each other to one version: `sentry-ruby`, `sentry-rails`, `sentry-sidekiq`; `rubocop` and `rubocop-buoy`. Confirm by the `~>` constraint between them in `Gemfile.lock`.
