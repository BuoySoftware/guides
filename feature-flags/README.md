# Feature Flags

At Buoy we utilize feature flags to enable us to develop features without
blocking merges into main or releasing often.  Feature Flags can fall into one
of 3 categories:

1. Release Toggle - This is a feature flag which is used to allow in progress
   features to be merged into the main branch and go out to production "dark".
2. Ops Toggles - A feature flag designed to allow us to incrementally release a
   feature to production, typically targetted at the center level.
3. Configuration Toggles - These are flags that enable / disable features on a
   per customer or per environment basis and are not considered "temporary".

## Guide

- For release toggles, prefer database backed feature flags
- For configuration toggles, prefer environment variable backed feature flags
- Avoid creating feature flags with LaunchDarkly. This is considered deprecated
  unless used in React during our transition away from React.
- Prefer using a feature flag when implementing a change which impacts SOPs.
- Prefer a feature flag to a [feature branch].
- Once a release toggle feature is turned on in production, create an Asana task in your
  project's respective project to remove the feature. Schedule it 1 week out to
  ensure feature adoption.
- Be proactive in removing feature flags that are no longer needed.
- Name feature flag environment variables with the `_ENABLED` suffix.
- Prefer using data migrations when introducing feature flags (`FeatureFlag.create!(...)`).

[feature branch]: https://www.atlassian.com/git/tutorials/comparing-workflows/feature-branch-workflow
