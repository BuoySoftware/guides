# Shared

Playwright is the only supported web framework; Appium with WebdriverIO covers mobile. Cypress and Detox are retired.

- Use the [Page Object Pattern] when designing tests.
  - We try to encapsulate all modules into one (or more) module(s) for each widget.
    Such as the ReceptionWidget, we have a ScreeningPage and RegistrationPage that
    will instantiate all of the submodules in order to keep our imports and complexity
    in the test spec to a minimum.
- Use snake_case when creating new files ex. => `login.spec.ts`, `payments_modal.ts`
- Use snake_case when creating new folders ex => `test_results`
- Use the literal text the user sees for expected copy and text locators, such as `filter({ hasText: "Save" })`. Don't read it through an i18n lookup: a test that reads the app's own locale file cannot fail when the copy is wrong, and a moved key resolves to an empty string and a timeout.
- Use application-level APIs and GraphQL whenever available. If neither option exists or will be removed or deprecated, fall back to the automation-managed GraphQL.
- Use prefix action functions according to element type.
  - `click` for links and buttons.
  - `select` for elements with options like dropdowns, radios, and checkboxes.
- Use test flows for repeated logic and assertions. Refer to [test flows](examples/test_flows.md) for additional details.
- Prefer [fixtures] for injecting page objects and test flows into a spec.
- Prefer to find elements using [testid, role or label](examples/selectors.md)
- Prefer to find elements by multiple locators versus creating new pageobjects
  - Example: If a React page has been migrated to Rails, update the existing page
    locators with an `or` statement => `this.page.locator("dt").or(this.page.locator("dd"))`
- Prefer the use of `Base` classes (forms, breadcrumbs, footers, etc) to reduce code duplication.
  - This may not be applicable to every component. If you see a pattern in similar components, it may be worth adding a new `Base` class!
- Prefer data generation within the test spec, avoid the [mystery guest].
- Don't put `expect()` in a PageObject. Assertions live in the spec or a test flow, so a page object stays reusable across happy and sad paths. Two exceptions: a `goTo` method may assert its URL, and a base action class may verify the action it just performed. Wait for state with `.waitFor()` instead.
- Prefer the [Test structure] of `describe()` and `it() or test()`
  - The `it() or test()` block should be clear and concise to the intention of the test.
  - Prefer to use present tense in [test titles]
- Don't try to automate every test, these are some good guidelines to follow from [SmartBear].

# Playwright

[Playwright Documentation]

- Use [test.skip(conditional, message)] for conditional executions of a test. This can be used for tests that rely on a feature flag being enabled.
- Prefer to keep tests independent of each-other. If that is not easily attainable, run tests in [serial] mode or combine flows into one test.
- Keep the use of tags to a minimum. Team tags go in the `tag` option, never in the title. Don't hand-add a test-management id tag; the reporter fills it in after a run.

[page object pattern]: https://playwright.dev/docs/pom
[fixtures]: https://playwright.dev/docs/test-fixtures
[smartbear]: https://smartbear.com/learn/automated-testing/best-practices-for-automation/
[test structure]: https://playwright.dev/docs/writing-tests
[playwright documentation]: https://playwright.dev/docs/intro
[test titles]: https://www.betterspecs.org/#should
[serial]: https://playwright.dev/docs/test-parallel#serial-mode
[test.skip(conditional, message)]: https://playwright.dev/docs/api/class-test#test-skip-3
[mystery guest]: https://thoughtbot.com/blog/mystery-guest
