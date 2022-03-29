# Cypress

- Try to follow the [best practices] outlined by Cypress.
- Use the [Page Object Pattern] when designing tests.
- Prefer [fixtures] over hard coded values.
- Use [i18n] (where applicable) instead of hard-coding text, buttons, inputs, form fields, etc.
- Assertions:
  - Prefer [.should() or .and()] with callback over .then() for assertions.
  - High level assertions (such as business logic) should be kept in a spec or helper file, low-level assertions such as i18n are acceptable in page objects.
- Any element you use should have a `data-testid` selector attached to it, if not, prioritize working with a dev to remedy the issue.
- Don't try to automate every test, these are some good guidelines to follow from [SmartBear].

[page object pattern]: https://www.toolsqa.com/cypress/page-object-pattern-in-cypress/
[fixtures]: https://www.toolsqa.com/cypress/fixtures-in-cypress/
[.should() or .and()]: https://docs.cypress.io/api/commands/should#Differences
[i18n]: https://www.i18next.com/
[smartbear]: https://smartbear.com/learn/automated-testing/best-practices-for-automation/
[best practices]: https://docs.cypress.io/guides/references/best-practices
