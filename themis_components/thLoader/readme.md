# `thLoader`

## Description

`thLoader` can be used while in a state of loading data or rendering new elements to the dom.

Will default the loading message to `Loading...` if no text is given.

Will accept time in `milliseconds`, a `promise` to be resolved, or a `boolean` as a trigger to hide loader.

Accepts a `size` attribute to adjust icons size.
- `'small'` == `30px x 30px`
- `'large'` == `90px x 90px`
- With no size attribute == `60px x 60px`

## Usage
```html
<th-loader trigger="boolean"></th-loader>
```

---
