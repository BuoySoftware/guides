# Shared

- Use the [Page Object Pattern] when designing tests.
  - We try to encapsulate all modules into one (or more) module(s) for each widget.
    Such as the ReceptionWidget, we have a ScreeningPage and RegistrationPage that
    will instantiate all of the submodules in order to keep our imports and complexity
    in the test spec to a minimum.
- Use PascalCase when creating new files ex. => `Login.spec.ts`, `PaymentsModal.ts`
- Prefer [fixtures] over hard coded values.
- Use [i18n] (where applicable) instead of hard-coding text, buttons, inputs, form fields, etc.
- Any element you use should have a `data-testid` (`testID` for detox) selector attached to it,
  if not, prioritize working with a dev (or add it yourself) to remedy the issue.
- [Test structure] should follow the pattern of `describe()`, `context()` and `it()`
  - Prefer to use present tense in [test titles]
- Don't try to automate every test, these are some good guidelines to follow from [SmartBear].

# Cypress

[Cypress Documentation]

- A few practices that we follow that Cypress does not recommend:
  - Using the Page Object Pattern
  - Tightly coupling tests (e2e suites only)
    - Example: We want to test the entire flow of a donor's journey. If we
      were to mock this data between tests we wouldn't be testing the system
      as a cohesive unit.
- Assertions:
  - Prefer [.should() or .and()] with callback over .then() for assertions.
  - Prefer `have.text` over `contains.text`
  - High level assertions (such as business logic) should be kept in a spec or
    helper file, low-level assertions such as i18n are acceptable in page objects.
- [Try not to nest callbacks] and avoid the "pyramid of doom"

# Detox

[Detox Documentation]

# Resources

[Many examples] from the former VP of Engineering for Cypress

[page object pattern]: https://www.toolsqa.com/cypress/page-object-pattern-in-cypress/
[fixtures]: https://www.toolsqa.com/cypress/fixtures-in-cypress/
[.should() or .and()]: https://docs.cypress.io/api/commands/should#Differences
[i18n]: https://www.i18next.com/
[smartbear]: https://smartbear.com/learn/automated-testing/best-practices-for-automation/
[best practices]: https://docs.cypress.io/guides/references/best-practices
[test structure]: https://docs.cypress.io/guides/core-concepts/writing-and-organizing-tests#Test-Structure
[detox documentation]: https://wix.github.io/Detox/docs/introduction/getting-started
[cypress documentation]: https://docs.cypress.io/guides/overview/why-cypress
[test titles]: https://www.betterspecs.org/#should
[try not to nest callbacks]: https://glebbahmutov.com/cypress-examples/recipes/concat-labels.html
[many examples]: https://glebbahmutov.com/cypress-examples
