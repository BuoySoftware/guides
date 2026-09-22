# React

- Prefer setting default values for form fields when using [react-hook-form] at
  the form level, with `useForm`'s `defaultValues` option, instead of at the
  individual input level. Use [`reset`] to load values that arrive
  asynchronously.

[react-hook-form]: https://react-hook-form.com/docs/useform
[`reset`]: https://react-hook-form.com/docs/useform/reset
