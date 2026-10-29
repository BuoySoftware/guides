# Dependency Upgrades

A procedure for reviewing a Dependabot pull request. The output is a verdict: **merge**, **stop**, or **needs QA**, with the evidence for each check. A green CI run is never the verdict on its own: a hijacked release and a runtime-only regression both pass CI.

The reviewer never merges and never pushes to the Dependabot branch. The reviewer posts the review; a human merges.

The checks are the same for every ecosystem. The commands differ, and live in one file per ecosystem. Each check names the section to use. The GitHub Actions file is organised one section per check instead, and its Classify row names them.

- [RubyGems](rubygems.md) for a `Gemfile.lock` PR.
- [npm](npm.md) for a `package.json` and `yarn.lock` PR.
- [GitHub Actions](github-actions.md) for a workflow PR.

Every `gh` command takes `-R <owner>/<repo>`; the examples omit it. Nothing here requires the PR branch to be checked out: the consumption and lockfile commands run in a clone with `origin/main` fetched, and read the PR's files from the head SHA:

```sh
git fetch origin <head-sha>
git show <head-sha>:Gemfile.lock > Gemfile.lock.new    # likewise yarn.lock, package.json
```

## Classify

Read the PR title and the list of changed files, then pick one row. A title that matches two rows takes the stricter one: the row with more checks, and the lower row in the table when the checks are the same. A `*-security-updates` group always takes the Security row.

| Shape                                                 | Checks                                                                                                                                      |
| ----------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------- |
| Grouped minor/patch bundle (`Bump the ... group`)     | Lockfile, Release notes, CI, Runtime. Any member that crossed a major, or has an advisory, gets the Single major row too.                   |
| Single minor/patch bump                               | Lockfile, Release notes, CI, Runtime                                                                                                        |
| Single major bump                                     | Lockfile, Provenance, Release notes, CI, Runtime                                                                                            |
| Security update                                       | Lockfile, Provenance, Release notes, CI, Runtime, then verdict promptly                                                                     |
| Member of a family (see [Families](#families))        | The row its version delta says, plus Families                                                                                               |
| GitHub Actions bump                                   | Lockfile, Publisher, Tag, Artifact, Release notes, CI, Runtime, Tag references, each per its section in [GitHub Actions](github-actions.md) |
| Framework minor/patch (`rails`, `sidekiq`, `graphql`) | Lockfile, Provenance, Release notes, CI, Runtime. The list of frameworks is exhaustive; extend it in this guide, not in a review.           |

A minor/patch bump also gets Provenance when the package is new to the lockfile or ships native code. Otherwise leave Provenance off: an unchanged publisher and a lockfile diff that only changes the checksum do not need the artifact unpacked.

Some packages are excluded from Dependabot on purpose and upgraded by hand with a Jira ticket. The list is the `ignore` block in `.github/dependabot.yml`. A Dependabot PR for one of those is a **stop**: the config drifted. An ignored package also never moves as a transitive, which matters in [Lockfile diff](#lockfile-diff).

If any check on the PR is red, run [CI output](#ci-output) first and attribute the failure before anything else. A red run answers most of the review.

Then record these facts. Every later check uses them.

- **Head SHA and run date.** Dependabot recreates branches, so CI may be days newer than the PR. Report the SHA and date CI ran on, not the day the PR opened.

  ```sh
  gh pr view <pr> --json headRefOid,headRefName
  gh run list --branch <head-branch> --limit 5 --json databaseId,workflowName,createdAt,headSha,conclusion
  ```

- **Branch age.** A branch behind `main` is rebased onto current `main` before it merges, per [Merging rules](#merging-rules-for-the-human).

  ```sh
  gh api repos/<owner>/<repo>/compare/main...<head-sha> --jq '.behind_by'
  ```

- **Source repository** for each titled package, from the registry, per the ecosystem's "Source" section. The PR body sometimes carries the links and sometimes carries nothing.

- **How the app consumes each package**: a direct require or import, a config file only, or transitively through a tool such as vite or jest. This decides which changed defaults can reach the app and which CI job exercises it. The ecosystem's "Consumption" section has the grep.

- **Sibling PRs**, for family rows only. Families are per ecosystem: a Ruby `sentry-*` PR has no npm sibling.

  ```sh
  gh pr list --search '<package-prefix> in:title author:app/dependabot' --state open
  ```

## Lockfile diff

Completion criterion: every package that moved, appeared, or disappeared is traced to a titled package that requires it, or is flagged.

Diff from the merge base. A two-dot diff against a stale branch shows `main`'s own changes as if the PR made them, and every one of them would look like an unexplained move.

```sh
gh pr diff <pr> > pr.diff
# or, with the branch fetched into a checkout
git diff origin/main...<head-sha> -- Gemfile.lock package.json yarn.lock
```

Build the trace with the ecosystem's "Lockfile" section: for each moved or new package, which packages in the new lockfile require it. A grouped npm bundle moves a hundred packages; the trace is a script, not a reading.

Flag as **stop**:

- A package that moved and is not required, directly or transitively, by a titled package. Dependabot's resolver pulled it, and the review is now about that package as much as the titled one.
- A transitive that crossed a major and is not required at that major by a titled package. A titled package that declares `^8` for it is a requirement, not a choice.
- A new package that no titled package requires.
- A package whose source host changed. Compare against the sources the ecosystem declares; private registries are normal there, a host that appears nowhere is not.
- A new install script, per the ecosystem section.

Flag as a **finding**, not a stop:

- **Duplicate resolutions.** The same package at two versions after the PR, usually the old version still nested under a dependent whose range Dependabot did not re-resolve. Look up advisories for every version that remains in the tree, not only the ones that moved. A security PR that leaves the vulnerable copy nested under another dependent does not close the alert. The fix is a dedupe or a pin in a hand-made PR.

## Provenance

Completion criterion: for each titled package, and for each transitive that crossed a major, the publisher, the tag, and the artifact are accounted for. A transitive patch that a titled package requires gets Publisher and Tag only.

Git history is not evidence here. A hijack pushes to the registry, not the repository, so Dependabot's "Commits" link stays clean. The reference case is [`strong_password` 0.0.7](https://withatwist.dev/strong-password-rubygem-hijacked.html): a patch bump on a quiet gem, pushed by a new account, with no tag, whose payload ran only in production and went unnoticed for about eight days.

### Publisher

Commands are in the ecosystem's "Publisher" section. Compare the new version's publisher and owners with the previous version's, and note the gap between the two release dates.

A publisher not present on the previous version is a **stop** unless one of these clears it, and the evidence says which:

- The release carries provenance that binds the artifact to the source repository. npm attestations and the RubyGems Provenance block both name the source commit, which must be the commit the tag points to.
- The new publisher is a current owner who authored recent commits in the source repository:

  ```sh
  gh api 'repos/<owner>/<repo>/commits?author=<login>&per_page=5' --jq '.[].commit.author.date'
  ```

A maintainer added beside the existing ones is not a publisher change. A gap of more than six months before the new release raises the bar for the clearing evidence. RubyGems shows on each version page whether that version was published with MFA; npm does not.

### Tag

List the repository's tags and match the version under its likely names: `v<ver>`, `<ver>`, `<pkg>@<ver>`, `<pkg>-v<ver>`.

```sh
git ls-remote --tags https://github.com/<owner>/<repo>.git | grep -E '<ver>(\^\{\})?$'
```

The tag need not be on the default branch; a release branch is normal. An annotated tag lists twice, and the `^{}` line is the commit.

Some projects never tag: DefinitelyTyped, graphql-ruby's JS client, libdatadog-rb. Find the release commit instead (npm's `gitHead`, or a "release x.y.z" commit), diff against it, and say in the evidence that the project does not tag. **Stop** only when there is neither a tag nor a release commit.

### Artifact diff

Two diffs. The first answers "is the artifact what the repository says it is"; the second answers "what changed". Fetch and clone take about a minute, so start them first. Commands are in the ecosystem's "Artifact" section.

1. Artifact against source at the tag. Code in the artifact and not in the repository is a **stop**, whatever it does. Publish-time transforms are expected and are not that: stripped dev fields in `package.json`, stripped comments, generated CJS or ESM twins, a trimmed README.
2. New artifact against old.

Prebuilt binaries cannot be verified against source. Report them as a finding that names the files, confirm the scripting side matches, and let the human decide.

Read the second diff this way. Normalise formatting churn first (quote style, trailing commas, whitespace). Read in full: boot and configuration code, and the modules the app enables through its initializer or imports. Grep the rest for gating and exfiltration. Run it on added lines only, with comment-only lines dropped; the ecosystem's "Artifact" section leaves `*.md` out of the diff. Otherwise the hits are mostly changelog links, doc URLs, and backticks in comments.

```sh
grep -E '^[>+]' <diff> | grep -vE '^[>+]\s*(#|//|\*)' \
  | grep -nE 'Rails\.env|NODE_ENV|hostname|ENV\[|process\.env|Net::HTTP|https?://|XMLHttpRequest|child_process|spawn|exec\(|eval\(|Base64|unpack\("m|atob'
```

A new network call is a finding until it is traced to the feature that owns it, and that feature is shown to be off by default or not configured by us.

Say in the evidence what was read line by line and what was grepped. Expect anything malicious to be gated on production, since nothing in CI runs there.

A file added under `lib/` named `railtie.rb`, `engine.rb`, or anything under `generators/` means the package now hooks Rails boot on its own. Carry it to [Runtime surface](#runtime-surface).

`bundler-audit` and `npm audit` only know published advisories. A clean audit is not evidence for this step.

## Release notes

Completion criterion: the changelog for every version between old and new is read or keyword-scanned, and every hit that names an API, option, or default the app uses is grepped for in the codebase.

Get the changelog at the new tag, per the ecosystem's "Changelog" section. Heading styles vary (`## 2.42.0`, `# 6.0.0`, `## [1.2.3] - date`, underlined), so cut the range by line number:

```sh
grep -nE '^#+ .*\b<new>\b|^#+ .*\b<old>\b' CHANGELOG.md
sed -n '<start>,<end>p' CHANGELOG.md
```

A repository with no changelog file has the releases API; a repository with neither has `git log <old>..<new>`.

For a major, read every `.0` section and the upgrade guide in full. For a minor/patch or a long range, read every "Breaking" and "Important" section in full, keyword-filter the rest, and read the hits. Grep the app only for the hits:

```sh
grep -niE 'break|deprecat|remov|renam|default|drop|no longer|require|minimum|peer|migrat'
```

For each item that names a breaking change, a renamed or removed API, a changed default, a deprecation, a new peer or minimum version of another package, or dropped runtime support:

- Grep the codebase for the API or option. A renamed option we set in `config/initializers` fails at boot, not in specs. Report every hit.
- Check a new peer or minimum against the app's version of that package. A mis-declared peer range gives no install warning; the build fails instead.
- Compare dropped runtime support against `.tool-versions`, `.ruby-version`, and the `engines` field in `package.json`. A dropped runtime we still run is a **stop**.
- Check a default that changes only on some runtime versions ("on by default on CRuby 4.0 and later") against the same files. A match is a [Runtime surface](#runtime-surface) item, since the CI log cannot show a default that only gated code reads.

Say in the evidence which ranges were read in full and which were keyword-filtered.

## CI output

Completion criterion: every job in every workflow run on the head SHA is listed as success, failure, or skipped; on a red run every failure is attributed; on a green run of a framework minor or a runtime major, the deprecation diff against `main` is reported.

```sh
gh pr checks <pr> --json name,state,link      # link carries /runs/<run-id>/job/<job-id>
gh run view <run-id> --json workflowName,headSha,createdAt,conclusion
```

A PR usually has two or more workflow runs. Jobs skipped downstream of a failed build are skipped, not missing; say so. Type check, lint, and the asset build must all be present, not only RSpec and Jest.

### Red run

Pull one failing job's log, strip the prefix, timestamp, and color, then read the first error before counting anything. Frame counts mislead when the error carries no gem frames.

```sh
gh run view --job <job-id> --log-failed \
  | cut -f3- | perl -pe 's/^\xEF\xBB\xBF//; s/^\S+Z //; s/(\e|\^\[)\[[0-9;]*m//g' > fail.log
grep -n '##\[error\]' fail.log | head
grep -oE '\b[A-Z][A-Za-z:]*(Error|Exception)\b' fail.log | sort | uniq -c | sort -rn | head
grep -oE 'gems/[a-z_-]+-[0-9.]+/' fail.log | sort | uniq -c | sort -rn | head
```

Attribute by signature:

| Signature                                                               | Cause                                    | Verdict                                                                                                                                                                                                         |
| ----------------------------------------------------------------------- | ---------------------------------------- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| Ruby error with frames in a gem from the lockfile diff                  | That gem                                 | **stop** on that gem, even when it is a transitive. Pin it and `@dependabot recreate`.                                                                                                                          |
| `Gem::LoadError: can't activate <pkg> (< N), already activated <pkg>-N` | A consumer's constraint, not the package | **stop**. Check whether a newer consumer release lifts the constraint (its changelog, or the same file at its newest tag); then upgrade the consumer, or `@dependabot ignore this major version` until it does. |
| `error TS` naming `node_modules/<a>/node_modules/<b>`                   | Duplicate resolution                     | Finding: dedupe in a hand-made PR.                                                                                                                                                                              |
| `error TS` in app code on a package's export                            | Package API change                       | **stop** on that package; its notes name the change.                                                                                                                                                            |
| `Rollup failed to resolve import "<x>" from node_modules/<pkg>`         | The package needs a peer the app lacks   | **stop**. Pin the package or bump the peer in a hand-made PR.                                                                                                                                                   |
| `bundle install` or `yarn install` authentication or network error      | Workflow configuration                   | Not a stop. Compare the failing job with a job in the same run that installed: one job's `permissions:` block can omit `packages: read`. A green sibling PR can be a cache hit. Report it as structural.        |
| Failure in a gem or package that is not in the diff                     | Flake, or `main` was red                 | Not a stop. Verdict is "merge after re-run".                                                                                                                                                                    |

The ecosystem sections list the log shapes for each test runner.

### Green run

Run this only for a framework minor or a major of a runtime package. A test log carries dozens of pre-existing warnings, so a raw grep proves nothing. Take the same grep on the baseline and report only lines that appear on the PR and not on the baseline. The baseline is the latest successful run of the same workflow on `main`; for a workflow that runs only on pull requests, it is the latest merged PR's run.

```sh
gh run list --branch main --status success --limit 5 --json databaseId,workflowName,createdAt
gh run view <baseline-run-id> --json jobs --jq '.jobs[] | "\(.databaseId) \(.name)"'

warnings() {
  gh run view --job "$1" --log \
    | cut -f3- | perl -pe 's/^\xEF\xBB\xBF//; s/^\S+Z //; s/(\e|\^\[)\[[0-9;]*m//g' \
    | grep -Ei 'deprecat|warning' \
    | perl -pe 's/\(node:\d+\)/(node:PID)/g; s/\d{4}-\d{2}-\d{2}[ T][0-9:.]+Z?/TS/g; s#_temp/[0-9a-f-]+#_temp/X#g; s/\b\d+ ?m?s\b/N/g' \
    | sort -u
}
warnings <pr-job-id> > pr.txt; warnings <baseline-job-id> > main.txt
comm -23 pr.txt main.txt
```

Pick the job that exercises the package: a test job for a runtime gem, the asset build for a build-time npm package. Test shards differ between runs, so diff the union of all shards of a workflow, not one shard against one shard. Read the remaining lines by hand; a new deprecation is what the next major removes.

## Runtime surface

Completion criterion: each titled package is matched against the list below, and matches are reported as **needs QA**. Report a match even when another check already produced a stop; the QA item outlives the fix.

First establish whether specs exercised the package at all. An initializer gated on an environment or a variable (`Rails.env.production?`, `ENV["DD_APM_ENABLED"]`, a DSN in a meta tag) runs in CI only when a workflow sets that variable; check `env:` and `services:` in `.github/workflows/*.yml`, and `config/environments/test.rb` for what the test environment swaps out (a memory cache store means the Redis cache store never ran). Ungated in CI, specs are evidence for the code paths they hit. Gated off, every changed default in the release notes is a QA item. Production-only configuration, such as Heroku config vars, is not observable from the repo; name the variables the notes mention and ask the human.

Build-time npm devDependencies (postcss, tailwind, vite plugins, eslint, prettier, jest) are exercised by the build, lint, and jest jobs. They match nothing below and need no QA.

A package in one of these areas gets a QA pass on a review app or staging and an agreed merge window:

- Boot and configuration: any package with a file in `config/initializers`, or that added a railtie, engine, or generator in the artifact diff.
- Background jobs: Sidekiq and its plugins, Redis clients, Action Cable adapters.
- Database access: ActiveRecord adapters, `pg`, Sequel, connection pooling.
- Web server and TLS: Puma, Rack, OpenSSL, HTTP clients.
- Observability: Sentry, Datadog, Prometheus exporters. A broken tracer fails quietly.
- Time and locale data: `tzinfo-data`, `moment-timezone`, ICU, `money`.
- Regulated output: PDF generation, label rendering, barcode and ISBT 128 libraries, device integration parsers. A format change here is a QA event, not a spec failure.
- Deploy and release workflows: an action that runs only on `workflow_run`, a tag push, or `if: failure()` had no run on this PR. Its first run is after merge, with production secrets.

## Families

Completion criterion: for a family row, every open sibling PR is listed, and the lockfile diff says whether this PR moves the whole family or one member.

A family is a set of packages that constrain each other to one version, such as `sentry-ruby`, `sentry-rails`, and `sentry-sidekiq` (`~> 7.0.0` between them), or `rubocop` and `rubocop-buoy`. The ecosystem's "Families" section lists the known ones; the constraint in the lockfile is the test. Packages that merely share a vendor and release on their own cadence, such as `datadog` and `datadog-ci`, are not a family and merge independently.

The result is `pass` when this PR's lockfile moves every member to the new version, with the sibling PRs named as redundant in the evidence. It is **stop** when the PR moves one member and leaves the others behind; the fix is in [Merging rules](#merging-rules-for-the-human).

## Verdict

Post one review comment with `gh pr review <pr> --comment -F review.md`. Never approve or request changes; the verdict line carries the decision. On **merge** or **merge after re-run**, post the verdict and the three lines under it. On **stop** or **needs QA**, add the table and findings, blocking findings first.

```
Verdict: merge | merge after re-run | stop | needs QA

Shape: <row from Classify>
CI: <head-sha> on <date>, <n> commits behind main
Siblings: <#numbers, none, or n/a for a non-family row>

| Check           | Result   | Evidence |
| --------------- | -------- | -------- |
| Lockfile diff   | pass     | only sentry-ruby, sentry-rails, sentry-sidekiq moved; json 2.21 -> 3.0 is a resolver choice, see finding 1 |
| Provenance      | pass     | sole owner `sentry` unchanged; tag 7.0.0 present; all three artifacts match the tag's subdirectory |
| Release notes   | pass     | 6.0.0 and 7.0.0 sections read in full, 6.x keyword-filtered; no hits for the removed options |
| CI output       | stop     | rspec 2917/10154 failing; every failure is ArgumentError in JSON.parse from json-3.0.2 |
| Runtime surface | needs QA | Sentry.init runs only in production; logs and metrics default on in 7.0 |
| Families        | pass     | lockfile moves all three sentry gems to 7.0.0; #412 and #413 are redundant |

Findings:
- ...
```

Result values are `pass`, `stop`, `needs QA`, `flake`, and `n/a`. The verdict is the first of these that any check produced: `stop` gives **stop**, `needs QA` gives **needs QA**, `flake` gives **merge after re-run**, and all `pass` or `n/a` gives **merge**. When the cause is a package other than the one in the PR title, the first finding names that package and says the titled package is not at fault. A **stop** verdict says which check produced it, names the team `CODEOWNERS` lists for the changed files, and adds it with `gh pr edit <pr> --add-reviewer <org>/<team>`; when no entry matches, say so and let the human pick. A stop is a stop with or without a published advisory. A **needs QA** item for a changed default names the setting that restores the old behaviour without a revert, so whoever deploys knows the rollback.

## Merging rules for the human

- Use `@dependabot rebase` first to update the branch, and `@dependabot recreate` when the rebase conflicts. After a human push Dependabot abandons the branch, and merging `main` into it creates a merge commit that GitHub's rebase button then refuses. Replaying the bump onto `main` in a new branch is the fallback, not the default. The Dependabot branch is the one exception to [Code Review](/code-review/).
- Rebase before merging if CI ran against a stale `main` ([Git](/git/#merge)).
- Merge low-risk bumps within the week they open. Aged PRs accumulate conflicts and bury security updates.
- Use `@dependabot ignore this major version` when a major is blocked, and open a Jira ticket that says why.
- If the upgrade needs code changes beyond the lockfile, a pin, a dedupe, or a SHA pin for an action, close the Dependabot PR, open a normal PR with the upgrade and the change, and link back.
- For a [family](#families), merge the one PR whose lockfile pulls every sibling and let Dependabot close the rest, or close them all and bump the family in one hand-made PR. Never merge one sibling alone.

### Cooldown

`cooldown` in `.github/dependabot.yml` delays a release before Dependabot proposes it, to give upstream time to notice a hijacked release. The configured value is the source of truth. Security updates ignore the cooldown.

## Hand-made bumps

A bump made by hand, for example to clear a `bundler_audit` advisory, gets the same review before the PR exists. Record CI as pending until the PR opens, and put the verdict in the PR description instead of a review comment. Nothing enforces `cooldown` on a hand-made bump, so check that each new version is older than the configured cooldown.

## Publishing our own packages

Anyone who publishes a BuoySoftware package is a target for the same account takeover that hit `strong_password`.

- Require MFA on every RubyGems.org, npm, and GitHub account that can publish or release a BuoySoftware package.
- Prefer trusted publishing from CI (OIDC) over long-lived API keys stored in a developer's shell or in repository secrets.
- Publish from a tag, so the artifact on the registry always has a matching commit that a reviewer downstream can diff against.
