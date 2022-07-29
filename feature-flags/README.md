# Feature Flags

At Buoy we utilize feature flags to enable us to develop features without
blocking merges into main or releasing often. To accomplish this we typically
implement one or both of the following:

- [LaunchDarkly] feature flags for client side control or for features which
  might be per user dependent.
- Server environment variables for toggling features on the server side.

## Guide

- Prefer using a feature flag when implementing a change which impacts SOPs.
- Prefer a feature flag to a [feature branch].
- Avoid creating feature flags within the LaunchDarkly UI. Instead utilize
  [terraform].
- Name feature flag environment variables with the `_ENABLED` suffix.

[launchdarkly]: https://launchdarkly.com/
[feature branch]: https://www.atlassian.com/git/tutorials/comparing-workflows/feature-branch-workflow
[terraform]: https://registry.terraform.io/providers/launchdarkly/launchdarkly/latest/docs
