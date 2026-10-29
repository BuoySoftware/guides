# Dependency Upgrades: GitHub Actions

Commands for the checks in [Dependency Upgrades](README.md) when the PR changes `.github/workflows/*.yml` or `.github/actions/*`. Actions run with repository secrets, so review them as production code.

This file has one section per check, in the order of the README, rather than the Source, Consumption, Lockfile, Publisher, Artifact, Changelog, and CI log shapes sections of the package ecosystems. Consumption does not apply: the workflow file is the consumer. Families do not apply: actions release on their own. [Tag references](#tag-references) is a check only this ecosystem has, and it runs on every Actions PR.

## Source and inventory

There is no lockfile and no registry. The source is the `uses:` string, and the artifact is the repository at the referenced commit.

```sh
gh pr diff <pr> > pr.diff
grep -E '^\+.*uses:' pr.diff | sed -E 's/.*uses: *//' | sort | uniq -c | sort -rn
```

Every line in that inventory must appear in the PR's table. Group them into internal (`BuoySoftware/*`) and third-party.

## Lockfile

The inventory is the lockfile check. A new action that the PR title does not name is a stop.

## Publisher

The publisher is whoever created the tag and authored the commit it points to.

```sh
gh api repos/<owner>/<repo>/commits/<sha> --jq '{author: .author.login, verified: .commit.verification.verified, date: .commit.author.date}'
gh api orgs/<org>/members/<login> >/dev/null && echo member    # internal actions
```

For an internal action the author must be an organisation member. For a third-party action the author should appear in the repository's recent history.

## Tag

The pinned SHA must be the commit the tag points to. An annotated tag's ref points at a tag object, so dereference it:

```sh
gh api repos/<owner>/<repo>/git/ref/tags/<tag> --jq '.object | "\(.type) \(.sha)"'
gh api repos/<owner>/<repo>/git/tags/<tag-object-sha> --jq '.object.sha'   # when type is "tag"
```

Use the singular `git/ref/`; the plural form is a prefix match and `v1.1` returns `v1.10.0` too.

The commit must be on the default branch:

```sh
gh api repos/<owner>/<repo>/compare/<default-branch>...<sha> --jq '"\(.status) ahead_by=\(.ahead_by)"'
```

`behind` or `identical` with `ahead_by=0` means it is on the branch.

## Artifact

Diff `action.yml` between the old and new tags. The compiled `dist/index.js` is not readable in a review; the SHA-equals-tag check is the artifact check for it.

```sh
for t in <old-tag> <new-tag>; do
  gh api "repos/<owner>/<repo>/contents/action.yml?ref=$t" -H 'Accept: application/vnd.github.raw' > action-$t.yml
done
diff action-<old-tag>.yml action-<new-tag>.yml
```

Report:

- `runs.using` changes. `node24` needs runner 2.327.1 or newer; the runner version is the first line of any job log (`Current runner version`).
- New inputs whose default is enabled, and inputs with a `deprecationMessage` that the workflows still pass.
- For a composite action, every `uses:` inside it. Those transitive references run with the caller's secrets, and Dependabot does not update them.

For an internal repository, clone it and `git diff <old-tag> <new-tag> -- <action-dir>` per action.

## Release notes

Read the `.0` section of each major crossed and the `action.yml` diff above; minor and patch bodies are mostly Dependabot noise. An internal repository without a changelog or releases has `git log <old-tag>..<new-tag>`.

## CI output

Which updated references ran on this PR is the main CI question. A step behind `if: failure()`, a step skipped for the Dependabot actor, and a workflow triggered by `workflow_run`, a tag push, or `workflow_dispatch` had no run here.

```sh
gh api repos/<owner>/<repo>/actions/jobs/<job-id> --jq '.steps[] | "\(.conclusion)\t\(.name)"'
```

Runtime deprecations for actions are check-run annotations, not log lines:

```sh
gh api repos/<owner>/<repo>/check-runs/<job-id>/annotations --jq '.[] | "\(.annotation_level)\t\(.message)"'
```

Diff the set across all PR jobs against the same jobs on `main`.

## Runtime surface

Every reference that did not execute on this PR is **needs QA**: its first run is after merge, with production secrets. Name the workflow and the trigger that will run it.

## Tag references

Every `uses:` must be a full commit SHA with the version in a trailing comment. A tag reference is mutable: whoever controls the action's repository can repoint it, and the workflow runs the new code before any PR exists. The [`tj-actions/changed-files` compromise](https://github.com/tj-actions/changed-files/issues/2463) repointed tags to a commit that dumped CI secrets.

Dependabot rewrites only the references it finds, so a PR that bumps `@v6` to `@v7` cannot pin what was never pinned. A tag reference the PR introduces is a **stop**. A tag reference that predates the PR is a finding: list them with the SHA each currently resolves to, and open a hand-made PR that pins them all.

```sh
grep -rnE 'uses: .*@v?[0-9]' .github/ | grep -vE '@[0-9a-f]{40}'
```
