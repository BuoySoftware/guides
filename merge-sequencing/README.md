# Merge Sequencing

We have a number of repositories that rely on each other. Occasionally, we may
need to hold off on merging a PR to main to ensure that the corresponding
changes in another repo have already been released.

## An example

Take the following example:

 * A database column change has been made to RepoA
 * RepoB replicates the database of RepoA
 * RepoC reads via APIs in RepoB and writes via APIs in RepoA

In the above scenario, RepoA needs to be released before RepoB, which needs to
be released before RepoC.

### Mitigating the issue

It is likely that the same engineer did all the necessary work in all of the
mentioned repositories. The engineer should document the PRs accordingly, with
information on when each is safe to merge.

Given the example above, take the following steps to clearly document when each
PR is safe to merge:

  * RepoA
    * Merge RepoA PR on approval
  * RepoB
    * Add label to PR on RepoB: "Do Not Merge"
    * Add label to PR on RepoB: "Awaiting RepoA Release"
    * Add link from the dependent PR on RepoA
  * RepoC
    * Add label to PR on RepoC: "Do Not Merge"
    * Add label to PR on RepoC: "Awaiting RepoA Release"
    * Add label to PR on RepoC: "Awaiting RepoB Release"
    * Add link from the dependent PR on RepoA
    * Add link from the dependent PR on RepoB

The links to the dependent PRs are useful in identifying whether or not a
release has gone out with the dependent code changes.
