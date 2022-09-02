# Cypress

- Try to follow the [best practices] outlined by Cypress.
- Use the [Page Object Pattern] when designing tests.
  - We try to encapsulate all modules into one (or more) module(s) for each widget.
    Such as the ReceptionWidget, we have a ScreeningPage and RegistrationPage that
    will instantiate all of the submodules in order to keep our imports and complexity
    in the test spec to a minimum.
- Use PascalCase when creating new files ex. => `Login.spec.ts`, `PaymentsModal.ts`
- Prefer [fixtures] over hard coded values.
- Use [i18n] (where applicable) instead of hard-coding text, buttons, inputs, form fields, etc.
- Assertions:
  - Prefer [.should() or .and()] with callback over .then() for assertions.
  - High level assertions (such as business logic) should be kept in a spec or
    helper file, low-level assertions such as i18n are acceptable in page objects.
- Any element you use should have a `data-testid` selector attached to it,
  if not, prioritize working with a dev (or add it yourself) to remedy the issue.
- Don't try to automate every test, these are some good guidelines to follow from [SmartBear].
- [Test structure] should follow the pattern of `describe()`, `context()` and `it()`
  - We'll want this pattern to be readable by anyone outside of the engineering team,
    such as (Physicals Widget - Vitals Review - phys sub cannot select `acceptable? no`
    when the donor has acceptable vitals)

[page object pattern]: https://www.toolsqa.com/cypress/page-object-pattern-in-cypress/
[fixtures]: https://www.toolsqa.com/cypress/fixtures-in-cypress/
[.should() or .and()]: https://docs.cypress.io/api/commands/should#Differences
[i18n]: https://www.i18next.com/
[smartbear]: https://smartbear.com/learn/automated-testing/best-practices-for-automation/
[best practices]: https://docs.cypress.io/guides/references/best-practices
[test structure]: https://docs.cypress.io/guides/core-concepts/writing-and-organizing-tests#Test-Structure
