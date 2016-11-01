# `thButton`

Use `thButton` to create and manage the buttons or links. For example, a submit
button in a form or link to add a matter.

---

## Usage

### Markup
```
<th-button type="create">Submit</th-button>
```

### Attributes

* `loading` [boolean] *(optional)* Sets the loading state of the button.

---

## Accessibility

The `thButton` component adheres to the standards set in the [WAI-ARIA Authoring Practices 1.1](https://www.w3.org/TR/wai-aria-practices-1.1/#button) document.

### Keyboard Interaction
`thButton` can be activated with either the `Space` or `Enter` keys.

### Optional Accessibility Attributes
* `aria-label` [string] Screen readers will read the button's text content by
default. Setting the `aria-label` attribute will override the text read by the
screen reader.

* `aria-describedby` [string] A description of a button's function can be
provided by setting the `aria-describedby` attribute to that of the `id` of the
description element.

---
