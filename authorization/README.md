# Authorization

## Permission Changes

- Use the `verb:noun` naming convention. IE: `manage:donor` `read:donor`
- Use the `manage` verb to represent all actions for the given noun. IE: `manage:donor`
  represents `create:donor` `read:donor` `update:donor` `delete:donor`.
- Don't update roles or permissions directly within Auth0.
- Use Terraform in the [DevOps] repository to update permissions.
- Ensure new permissions added in Terraform have detailed descriptions. Our customers need
  to understand what the permission grants access to so they can properly manage roles.
- Ensure new customer facing permissions are added to the `app/policies/permission_policy.rb`
  allow list or they will not be visible to manage in roles and permission.
- Prefer conditionally adding new permissions to allow list based on the feature flag.
- Ensure permissions are updated in all Auth0 tenants.
  - Current tenants include: Development, Staging, Validation and Production
  - Non-breaking changes can be rolled out to all environments at the same time
  - Breaking changes need to be rolled out as the affected code moves to new environments
- Ensure that a CHANGELOG entry has been added to the [Permission Change Log] in Notion for
  the permissions update.
- The introduction of a new role is a non-breaking change that may be surprising to
  JoinParachute, ping Luke Winter and Erin Galarza
- Ensure permission changes are documented in Asana. The transparency helps
  other departments know when and how permissions are changing.
  - Be sure to include what areas of the product are affected by this change.
  - Be sure to include what roles are impacted by this change.
- When in doubt, be overly communicative. Most permission changes will require
  a SOP change.
- Prefer having another engineer verify the permission change, [[Four Eyes Principle]]

[DevOps]: https://github.com/BuoySoftware/DevOps
[Four Eyes Principle]: https://www.openriskmanual.org/wiki/Four_Eyes_Principle
[Permission Change Log]: https://www.notion.so/Permissions-Change-Log-4d85a45f8bba41a99b16540f150285d4

## Pundit Policies

- Ensure the `manage?` permission represents all actions for the given noun.
  [Example Pundit Policy].
- Ensure `master_grant?` represents all actions for all nouns.
  [Example Pundit Policy].

[Example Pundit Policy]: /authorization/example_policy.rb

## CASL

- `manage:noun` and `manage:all` are supported out of the box.
  [CASL Basics].

[CASL Basics]: https://casl.js.org/v6/en/guide/intro#basics
