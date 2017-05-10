# Popover

<span class="badge orange">In Progress</span>

`th-popover` is used to add overlays of content to any element for housing secondary information.

### Example

```html
<th-popover template="demo.template">
  <!-- Insert trigger element here -->
</th-popover>

<th-popover template="demo.template">
  <th-button>Filters</th-button>
</th-popover>
```

## API Reference

### Properties
| Property         | Type        | Description   |   |
|:-------------    |:-------     | :-------------|---|
| **template**      | String/Object      | The text or content that will be shown within the popover. | **required** |
| **side**     | String      | Which side of the anchor element that the popover should align with (defaults to `left`). Options include (`left` and `right`). | *optional* |
