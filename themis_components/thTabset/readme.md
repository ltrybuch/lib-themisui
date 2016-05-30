# Tabs — `thTabset` / `thTab`

## Description

Want some tabs? The `th-tabset` & `th-tab` power duo are just what you were looking for.

Each `th-tab` gets a `name` which will be used as the label for the tab bar.
Any content inside of `th-tab` will be the content of that tab.

## Attributes

[name="string"]
- `name` is used as the label for the tab bar. This is not required but the tab
will not be visible in the tab bar without a name.

[ngClick="function"]
- Pass in an expression that can be evaluated upon clicking the tab in the tab bar
using `ng-click`. Using `ng-click` will not effect the normal usage of `thTabset`
but just allow a click event to attach to. See example 3 below.
[Angular docs](https://docs.angularjs.org/api/ng/directive/ngClick)

[type="string"]
- `type` allows you to modify the `thTabset` styling based on it's intended purpose. Currently `sub-header` is the only option.

## Usage

```
<th-tabset>
  <th-tab name="Tab One">
    Tab One Content
  </th-tab>
  <th-tab name="Tab Two">
    Tab Two Content
  </th-tab>
</th-tabset>
```

## Notes

- Combine this with `th-lazy` for an extreme team of lazy-loaded tabs!
