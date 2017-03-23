# Plural

Use the `thPlural` filter to pluralize or singularize a word automatically given a count.

For applications where the word(s) are known ahead of time, you can use a simple
ternary / function as it is a much lighter alternative over a filter.

### Example:

```html
  <span>{{demo.amount}} {{"post" | pluralize: demo.amount}}</span>
```
