# Dependency Upgrades: npm

Commands for the checks in [Dependency Upgrades](README.md) when the PR changes `package.json` and `yarn.lock`. The repo uses Yarn Berry, so `package-lock.json` rules do not apply.

## Source

```sh
npm view <pkg>@<ver> --json | jq -r '.repository.url, .gitHead, .dist.tarball'
```

`gitHead` is the commit the version was built from and is the fallback when the repository never tags. A `repository.directory` field means a monorepo.

## Consumption

```sh
git grep -nE "(from|import|require\() *['\"]<pkg>" origin/main -- app/javascript
git grep -n '<pkg>' origin/main -- '*.config.*' package.json
```

The first grep covers named imports, side-effect imports, and `require` calls.

A package that appears only in a config file is loaded by the tool that reads that config, and the tool may bundle its own copy: vite resolves its own nested `postcss` regardless of the root version.

## Lockfile

Each `yarn.lock` entry is a resolution key (`"<pkg>@npm:<range>"`), a `resolution:` line, a `dependencies:` block, and a `checksum:` line. Entries with `conditions:` are platform binaries and have no checksum; that is normal.

Dependents of a package are the entries whose `dependencies:` block names it. Run it on the PR's copy of the lockfile, from `git show <head-sha>:yarn.lock`:

```sh
awk '/^"?[^ ].*:$/{cur=$0} /^    <pkg>: /{print cur}' yarn.lock | sort -u
```

Duplicate resolutions are two resolution keys for the same package resolving to different versions:

```sh
grep -A1 -E '^"?<pkg>@' yarn.lock
```

Advisories for a version that remains in the tree:

```sh
gh api '/advisories?ecosystem=npm&affects=<pkg>@<ver>' --jq '.[] | "\(.ghsa_id) \(.severity) \(.summary)"'
```

Install scripts do not run: `.yarnrc.yml` sets `enableScripts: false`. Still check what the artifact declares, since a new `postinstall` is a signal even when it does not run:

```sh
npm view <pkg>@<ver> scripts
```

Source hosts are the `resolution:` prefixes (`@npm:` is the default registry) and `npmScopes` in `.yarnrc.yml`. There is no `.npmrc`.

For a grouped bundle of dozens of packages, parse both lockfiles into `name -> {versions, required-by}` with a script and emit moved, added, removed, and duplicated packages, each traced to the titled package that requires it.

## Publisher

```sh
npm view <pkg> --json | jq '{maintainers, time: (.time | to_entries | map(select(.key == "<old>" or .key == "<new>")))}'
npm view <pkg>@<new> --json | jq '{_npmUser, attestations: .dist.attestations}'
```

A publisher of `GitHub Actions` or `GitLab CI/CD` is trusted publishing. Confirm the attestation binds the tarball to the expected repository and tag:

```sh
curl -s 'https://registry.npmjs.org/-/npm/v1/attestations/<pkg>@<new>' \
  | jq -r '.attestations[] | select(.predicateType | test("slsa")) | .bundle.dsseEnvelope.payload | @base64d | fromjson
           | .predicate.buildDefinition | (.externalParameters.workflow.repository // ""), (.resolvedDependencies[0].uri // "")'
```

The two lines are the workflow's repository and the source URI with its ref. Both must name the registry's `repository`. The ref is often a branch (`refs/heads/main`) rather than the tag; then take the attested commit and confirm it is the commit the tag points to:

```sh
curl -s 'https://registry.npmjs.org/-/npm/v1/attestations/<pkg>@<new>' \
  | jq -r '.attestations[] | select(.predicateType | test("slsa")) | .bundle.dsseEnvelope.payload | @base64d | fromjson
           | .predicate.buildDefinition.resolvedDependencies[0].digest.gitCommit'
git ls-remote --tags https://github.com/<owner>/<repo>.git | grep -E '<ver>(\^\{\})?$'
```

A mismatch between the attested commit and the tag's commit is a **stop**.

## Artifact

```sh
npm pack <pkg>@<new> && mkdir <pkg>-<new> && tar -xzf <tarball> -C <pkg>-<new> --strip-components=1
git clone -q --depth 1 --branch <tag> https://github.com/<owner>/<repo>.git <repo>-src

diff -rq <repo>-src/<directory> <pkg>-<new> | grep -v 'Only in <repo>-src'   # 1. artifact against tag; no output means identical
npm diff --diff=<pkg>@<old> --diff=<pkg>@<new> > pkg.diff                     # 2. new against old
```

Expected publish-time differences: `package.json` without `devDependencies` and `scripts`, stripped comments, generated `.cjs` or `.mjs` twins of the sources, a trimmed README. Compare `lib/` or the `files` list, and treat those as noise.

A scoped tag name (`<pkg>@<ver>`) needs quoting in `--branch`. Cloning an annotated tag prints "is not a commit" and a detached-HEAD notice, which is not an error.

## Changelog

```sh
gh api "repos/<owner>/<repo>/contents/<directory>/CHANGELOG.md?ref=<tag>" -H 'Accept: application/vnd.github.raw' > CHANGELOG.md
```

The contents API returns nothing for a file over 1 MB; use `https://raw.githubusercontent.com/<owner>/<repo>/<tag>/CHANGELOG.md` then. Repositories without a changelog (`herb`, DefinitelyTyped) have the releases API or `git log`.

Dependabot proposes the minimum patched version on a security update while `dist-tags.latest` may be newer; expect a follow-up version-update PR.

## CI log shapes

- `tsc`: `<file>(<line>,<col>): error TS<code>: <message>`. A message naming `node_modules/<a>/node_modules/<b>` is a duplicate resolution.
- Vite build: `[vite]: Rollup failed to resolve import "<x>" from "<file>"`. The file's path names the package that needs the missing peer.
- Jest: `● <suite> › <test>` followed by the assertion, then `Tests: N failed, M passed`.
- eslint via reviewdog: annotations, not log lines. `gh api repos/<owner>/<repo>/check-runs/<job-id>/annotations`.

## Families

npm packages that pin each other, such as `@graphql-codegen/*` plugins against `@graphql-codegen/cli`, or `@sentry/*` packages. Plugin ecosystems that merely share a prefix (`postcss-*`, `eslint-plugin-*`, `@testing-library/*`) are separately maintained and are not families.
