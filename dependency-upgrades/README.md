# Dependency Upgrades

A guide for reviewing Dependabot pull requests. The goal is to decide, in a few minutes, whether an upgrade is safe to merge or needs someone to dig in. A green CI run is not enough: several of the risks below are invisible to the test suite.

Examples use BuoyRails, but the checks apply to any repo Dependabot watches.

## Triage

Start from the PR title: it gives the ecosystem, the packages, and the version delta.

| PR shape                                                                                    | Risk                          | Checks                                                                                                     |
| ------------------------------------------------------------------------------------------- | ----------------------------- | ---------------------------------------------------------------------------------------------------------- |
| Grouped minor/patch bundle (`Bump the bundler-version-updates group ...`)                   | Low per package, wide surface | Scan every changelog in the PR body for "breaking", "deprecated", "drops support". Read the lockfile diff. |
| Single minor/patch bump                                                                     | Low                           | Same as grouped.                                                                                           |
| Single major bump                                                                           | High                          | Everything in [Review](#review). Read the upgrade guide, not just the changelog.                           |
| Security update                                                                             | Time-sensitive                | Confirm the advisory touches a code path we use. Merge promptly once green.                                |
| Gem or package family (`sentry-ruby`, `sentry-rails`, `sentry-sidekiq` opened as three PRs) | Medium                        | Merge siblings in lockstep, never separately. See [Merging](#merging).                                     |
| GitHub Actions bump                                                                         | Medium                        | See [GitHub Actions](#github-actions).                                                                     |
| Framework minor/patch (`rails`, `@rails/*`, `styled-components`)                            | Medium                        | Read the release notes and the deprecation output in CI.                                                   |

Some dependencies never arrive through Dependabot on purpose. In BuoyRails that is `anchor_view_components`, `infirmary`, `infirmary_engine`, `vite`, and all framework majors. The team upgrades those manually with a Jira ticket.

## Review

Do all five sections for Medium, High, and Time-sensitive rows. Low rows can skip Runtime-only behavior and the artifact diff. Wherever a check says stop, do not merge: bring in the owning team, and do not wait for an advisory to confirm the problem.

### Release notes

- Read the release notes for every version between the current and the new one, not only the latest. Dependabot links them in the PR body.
- Look for: breaking changes, renamed or removed APIs, changed defaults, deprecations, and dropped runtime support.
- Check dropped runtime support against what we run. BuoyRails pins Node `20.x` and Ruby in `.ruby-version` and `.tool-versions`, and packages have started dropping Node 20.
- Grep the codebase for anything the notes say changed. A renamed option in a gem we configure in `config/initializers` fails at boot, not in specs.
- If Dependabot could not link release notes, or the version has no matching tag or release in the repository, stop and find out why. The version may exist only on the registry.

### Lockfile diff

- Confirm only the expected packages moved. A transitive dependency that jumped a major, a new package, or a package that changed source is a reason to stop and read. BuoyRails pulls from private registries (GitHub Packages, graphql.pro, contribsys), so a package in `Gemfile.lock` resolving from a different host is a hijack signal.
- For npm, look at the `resolved` URL and the integrity hash. A new `hasInstallScript: true` in `package-lock.json`, or a `resolved` host other than `registry.npmjs.org`, deserves a look at the package's repository before merging.

### Provenance

The lockfile and release notes tell you what the package claims to be. These checks tell you what was actually published. Do the first two for every PR; do the diff for Medium and above, and for any Low PR where the first two raise a question.

The 2019 `strong_password` hijack is the reference case. Version 0.0.7 was a patch bump on a gem with no commits for six months, pushed from an almost empty account with access to that one gem, with no tag and no changelog entry. The payload ran only in production, so specs, CI, and a review app all passed. A human caught it about eight days later by reading the diff during a routine upgrade.

- Check who pushed the version. The RubyGems.org version page shows the pushing account and whether owners have MFA enabled; the npm package page shows the publisher. A version pushed by an account not previously associated with the package, especially on a package that had been quiet, is a stop.
- Dependabot's "Commits" link compares git history, which a hijack leaves clean. Diff the shipped artifact against the previous version or the git tag instead. Code that exists in the package but not in the repository is a stop, whatever it does.

  ```sh
  gem fetch strong_password -v 0.0.6 && gem fetch strong_password -v 0.0.7
  gem unpack strong_password-0.0.6.gem && gem unpack strong_password-0.0.7.gem
  diff -r strong_password-0.0.6 strong_password-0.0.7

  npm diff --diff=left-pad@1.3.0 --diff=left-pad@1.3.1
  ```

- Expect malicious code to be gated on the production environment. Nothing in CI exercises it.
- `bundler-audit` and `npm audit` only know about published advisories. They are a fine CI gate but they do not catch a hijack.

### CI output

- Open the RSpec and Jest logs and search for `DEPRECATION` and `warning`. A new deprecation warning is usually something the next major removes.
- Check TypeScript type checks and lint ran, not only unit tests. A package that changed its exported types breaks the build without failing Jest.
- Check the asset build completed. Frontend tooling bumps can fail at bundle time while unit tests pass.

### Runtime-only behavior

Specs do not boot the app on a production configuration, and do not exercise every integration. Be slower with packages that touch:

- Boot and configuration: anything with a file in `config/initializers`.
- Background jobs: Sidekiq and its plugins, Redis clients.
- Database access: ActiveRecord adapters, `pg`, Sequel, connection pooling.
- Web server and TLS: Puma, Rack, OpenSSL, HTTP clients.
- Observability: Sentry, Datadog, Prometheus exporters. A broken tracer usually fails quietly.
- Time and locale data: `tzinfo-data`, ICU, `money`.
- Regulated output: PDF generation, label rendering, barcode and ISBT 128 libraries, device integration parsers. A format change here is a QA event, not a spec failure.

For anything on this list, prefer a QA pass on a review app or staging and agree with QA on a merge window.

## GitHub Actions

Actions run with repository secrets, so treat them like production code.

- Pin every action to a full commit SHA with the version in a trailing comment (`actions/checkout@11bd71901bbe5b1630ceea73d27597364c9af683 # v4.2.2`); Dependabot updates both. A tag like `@v4` is mutable: whoever controls the action's repository can repoint it, and your workflow runs the new code before any PR exists. That is how the `tj-actions/changed-files` compromise in March 2025 reached every workflow pinned to a tag. Move any remaining tag pin to a SHA in the next Dependabot PR that touches it.
- Confirm the new SHA is on the action's default branch and matches a tagged release, for internal (`BuoySoftware/github-actions/*`) and third-party actions alike. The commit page on GitHub lists the branches and tags that contain it. Read the release notes for changed inputs or a new Node runtime requirement.
- Read the action's diff between versions when the bump is a major. Look for new `permissions`, new inputs that default on, and new network calls.

## Merging

- Don't push commits to a Dependabot branch by hand, unlike a normal review branch ([Code Review](/code-review/)). Dependabot stops updating a branch it no longer owns. Use `@dependabot rebase` or `@dependabot recreate` in a PR comment instead.
- Don't merge a PR whose CI ran against a stale `main`. Rebase first ([Git](/git/#merge)).
- Prefer merging low-risk bumps within the week they open. Aged Dependabot PRs accumulate conflicts and hide security updates in the noise.
- Let releases age before Dependabot proposes them. Configure `cooldown` in `dependabot.yml` (a week is a reasonable default) so a hijacked release is likely to be noticed upstream before it reaches us; `strong_password` 0.0.7 was live for about eight days. Security updates ignore the cooldown.
- Merge package families in lockstep (`sentry-*`, `datadog` + `datadog-ci`, `rubocop` + `rubocop-buoy`, `@rails/*`). Merge one PR whose lockfile pulls the siblings and let Dependabot rebase or close the rest, or close them all and bump the family in one hand-made PR.
- Use `@dependabot ignore this major version` when a major is known to be blocked, and open a Jira ticket that says why.
- If the upgrade requires code changes beyond the lockfile, close the Dependabot PR, open a normal PR that includes the upgrade and the code, and link back.

## Publishing our own packages

The `strong_password` account was hijacked with a reused password and no MFA. Anyone who publishes a BuoySoftware package is a target for the same thing.

- Require MFA on every RubyGems.org, npm, and GitHub account that can publish or release a BuoySoftware package.
- Prefer trusted publishing from CI (OIDC) over long-lived API keys stored in a developer's shell or in repository secrets.
- Publish from a tag, so the artifact on the registry always has a matching commit that a reviewer downstream can diff against.
