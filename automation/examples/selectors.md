# Selectors

When finding elements on a page, it's best to have a unique and stable selector. `data-testid` is the ideal selector to use, as it is resilient to DOM changes and gives the user the exact element they intend to interact with.

There are times when `data-testid` may not be needed. An element can also be found by `role` or by `label`. Due to our extensive use of i18n translations within our test automation code, we can utilize these translations when finding elements by `role` or `label`.

Whether we use `data-testid`, `role` or `label`. We should try to associate the locator with the i18n translation.

## data-testid example

```erb
<%= button_tag "Submit", data: { testid: "submit-button" }, class: "btn-primary" %>
```

In this case, the element is identified by the `data-testid="submit-button"`, which provides a stable and unique selector that isn't affected by visual or structural changes to the DOM.

## By role example

```erb
<%= button_tag "Submit", role: "button", aria: { label: "Submit" }, class: "btn-primary" %>
```

When using roles, elements can be identified by their semantic role. This example uses the `role="button"` attribute, along with the `aria-label` to describe the element's purpose. This is helpful for accessibility and can be used as a selector as well.

## By label example

```erb
<%= label_tag :username, "Username" %>
<%= text_field_tag :username, nil, id: "username", aria: { labelledby: "username" }, class: "form-control" %>
```

In this example, the element is identified by its associated label. The `aria-labelledby` attribute links the input field to the label, allowing it to be found through the label's text.

## Do

- Use `data-testid` for elements that are stable and need to be uniquely identified in tests.
- Leverage `role` or `label` attributes when `data-testid` isn't necessary, especially for accessibility purposes.
- Consider using translations in i18n-enabled applications when identifying elements by `data-testid`, `role` or `label`.

## Don't

- Rely on unstable or overly generic selectors like class names or element types in tests, as these can break easily with UI changes.
