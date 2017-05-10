# Button

<span class="badge green">Ready</span>

`th-button` is used to create and manage the buttons or links. For example, a submit button in a form or link to add a matter.

### Example

```html
<th-button type="create">Submit</th-button>
<th-button menu menu-template="demo.popoverTemplate">Menu Button</th-button>
```

## API Reference

### Properties
| Property          | Type         | Description   |   |
|:------------------|:-------      | :-------------|---|
| **type**          | String       | Which side of the anchor element that the popover should align with (defaults to `standard`). Options include (`standard`, `create`, `destroy`, and `secondary`). | *optional* |
| **loading**       | String       | Sets the loading state of the button. | *optional* |
| **menu-template** | String/Object| The text or content that will be shown within the menu button's popover. | *optional* |
| **menu-side**     | String       | Which side of the button that the popover should align with (defaults to `left`). Options include (`left` and `right`). | *optional* |

### Attributes
| Property     | Description   |   |
|:-------------| :-------------|---|
| **menu**| Applies menu button functionality. | *optional* |

## Accessibility

The `thButton` component adheres to the standards set in the [WAI-ARIA Authoring Practices 1.1](https://www.w3.org/TR/wai-aria-practices-1.1/#button) document.

### Keyboard Interaction
`thButton` can be activated with either the `Space` or `Enter` keys.

### Optional Accessibility Attributes

| Property             | Description   |   |
|:-------------------  | :-------------|---|
| **aria-label**       | Screen readers will read the button's text content by default. Setting the `aria-label` attribute will override the text read by the screen reader. | *optional*
| **aria-describedby** | A description of a button's function can be provided by setting the `aria-describedby` attribute to that of the `id` of the description element. | *optional*
