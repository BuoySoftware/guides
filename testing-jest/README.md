# Testing with Jest

- Use [eslint-plugin-jest] to enforce testing style.
- Use [Fishery] for building factories.
- Prefer `describe` and `it` blocks over `test` blocks.

## React (web)

- Use [React Testing Library] for testing [React](/react/) components, including
  hooks (the standalone react-hooks-testing-library is deprecated; its
  `renderHook` now ships with React Testing Library).
- Use [@testing-library/jest-dom] for supplemental expectation matchers, and
  [eslint-plugin-jest-dom] to enforce their use.
- Use [User Event] for simulating user interactions.

## React Native

- Use [React Native Testing Library] for testing components and hooks. Its
  built-in matchers replace `@testing-library/jest-native`, which is deprecated.
- Use its `userEvent` export for simulating user interactions, in preference to
  `fireEvent`.

[eslint-plugin-jest]: https://github.com/jest-community/eslint-plugin-jest
[eslint-plugin-jest-dom]: https://github.com/testing-library/eslint-plugin-jest-dom
[@testing-library/jest-dom]: https://github.com/testing-library/jest-dom
[react testing library]: https://github.com/testing-library/react-testing-library
[react native testing library]: https://github.com/callstack/react-native-testing-library
[user event]: https://github.com/testing-library/user-event
[fishery]: https://github.com/thoughtbot/fishery
