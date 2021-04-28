# Authorization

## Permission Changes

- Use the `verb:noun` naming convention. IE: `manage:donor` `read:donor`
- Keep permissions in the [DevOps] repository up to date.
- Ensure the [Permissions Matrix] is up to date.
- Ensure permissions are updated in all Auth0 tenants.
  - Current tenants include: Development, Staging, Validation and Production
  - Non-breaking changes can be rolled out to all environments at the same time
  - Breaking changes need to be rolled out as the affected code moves to new environments
- Ensure permission changes are documented in Trello. The transparency helps
  other departments know when and how permissions are changing.
  - Be sure to include what areas of the product are affected by this change.
  - Be sure to include what roles are impacted by this change.
  - Be sure to attach screenshots of permission changes in each environment to the ticket.
  - Example documentation in Trello: [Allow Phys. Subs to end deferrals]
- When in doubt, be overly communicative. Most permission changes will require
  a SOP change.
- Prefer having another engineer verify the permission change, [[Four Eyes Principle]]

[Allow Phys. Subs to end deferrals]: https://trello.com/c/CPBNyM1i
[DevOps]: https://github.com/BuoySoftware/DevOps
[Four Eyes Principle]: https://www.openriskmanual.org/wiki/Four_Eyes_Principle
[Permissions Matrix]: https://www.notion.so/0b902ab8e86e4f158772d2939837365e?v=f84d5f6e8cd04ff3a3c2b1b41c53404c
