# Testing with Jest

- Use [eslint-plugin-jest] and [eslint-plugin-jest-dom] to enforce testing
  style.
- Use [@testing-library/jest-dom] for supplemental expectation matchers.
- Use [React Testing Library] for testing [React](/react/) components, including
  hooks (the standalone react-hooks-testing-library is deprecated; its
  `renderHook` now ships with React Testing Library).
- Use [User Event] for simulating user interactions on components under test, in
  preference to firing raw DOM events.
- Use [Fishery] for building factories.
- Prefer `describe` and `it` blocks over `test` blocks.

[eslint-plugin-jest]: https://github.com/jest-community/eslint-plugin-jest
[eslint-plugin-jest-dom]: https://github.com/testing-library/eslint-plugin-jest-dom
[@testing-library/jest-dom]: https://github.com/testing-library/jest-dom
[react testing library]: https://github.com/testing-library/react-testing-library
[user event]: https://github.com/testing-library/user-event
[fishery]: https://github.com/thoughtbot/fishery
