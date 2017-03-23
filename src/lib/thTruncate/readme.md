# Truncate

Use `thTruncate` to truncate long paragraphs of text. A toggleable control is included to show/hide the text in it's entirety.

## Markup:

```html
  <th-truncate text="{{demo.paragraph}}"></th-truncate>
```

### Attributes

* `text` (**required**) The text that will be truncated.

* `limit` (*optional*) The number of characters displayed before truncation is
  enabled. The default character limit is `100`.
