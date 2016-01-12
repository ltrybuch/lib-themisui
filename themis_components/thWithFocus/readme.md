# Input — `with-focus`

## Description

Use the `with-focus` directive to manually set the focus on that element. This is particularly useful for edit modals as the user can immediately interact with form elements.

## Markup

`<th-input with-focus></th-input>`

## Notes
- Any element using the `with-focus` directive will always to be first focus on the page. This means that tabindex ordering will be overridden.
- You can use `with-focus` with form elements such as `<input>`, `<select>`, `<textarea>`, and links (`<a href>`)
- `with-focus` works well with themisUi components:
  - [thInput](.\thInput)
  - [thSelect](.\thSelect)

---

