# `thLoader`

## Description

`thLoader` can be used while in a state of loading data or rendering new elements to the dom.

Will default the loading message to `Loading...` if no text is given.

Will accept time in `millisecs`, a `promise` to be resolved, or a `boolean` as a trigger to hide loader.




## Usage

### Markup

Custom text with timer:

```
<th-loader timeout="6000">Loading. Hang tight...</th-loader>
```

or

Default text with a promise:

```
<th-loader promise="promise"></th-loader>
```
