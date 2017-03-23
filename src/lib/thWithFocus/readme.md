# With focus

Use the `with-focus` directive to manually set the focus on that element.
This is particularly useful for edit modals as the user can immediately interact
with form elements.

## Markup

`<th-input with-focus></th-input>`

## Notes
- Any element using the `with-focus` directive will always be the first focus
on the page. This means that [tabindex](https://developer.mozilla.org/en-US/docs/Web/API/HTMLElement/tabIndex)
ordering will be overridden.
- You can use `with-focus` with form elements such as `<input>`, `<select>`,
`<textarea>`, and links (`<a href>`)
- It is the developer's responsibility to make sure there is only one element with
focus on the same page. If there happens to be more than one the **last** element
with `with-focus` is used.
- `with-focus` works well with themisUi components:
  - `thInput`
  - `thSelect`
