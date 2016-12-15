# Tabs — `thTabset` / `thTab`

## Description

Want some tabs? The `th-tabset` & `th-tab` power duo are just what you were looking for.

Each `th-tab` gets a `name` which will be used as the label for the tab bar.
Any content inside of `th-tab` will be the content of that tab.

---

## Attributes

#### thTab
[name="string"]
- `name` is used as the label for the tab bar. This is not required but the tab
will not be visible in the tab bar without a name.

[ngClick="function"]
- Pass in an expression that can be evaluated upon clicking the tab in the tab bar
using `ng-click`. Using `ng-click` will not effect the normal usage of `thTabset`
but just allow a click event to attach to. See example 3 below.
[Angular docs](https://docs.angularjs.org/api/ng/directive/ngClick)

[badge="number" | "string"]
- Optional: `badge` allows a value to be displayed as a badge beside the tab. See example 7 below.

[letter-spacing="boolean"]
- Optional: When `letter-spacing` is true, tabs have reduced horizontal spacing
to accommodate alphabet pattern (i.e. `A B C D ...`).

#### thTabSet
[type="string"]
- `type` allows you to modify the `thTabset` styling based on it's intended purpose.
Current options include `header` and `sub-header`.

[activeTab="string"]
- Use `active-tab` to set which tab should be active by passing the corresponding
`th-tab` name.
- Optional: `th-tabset` sets the first tab to active by default.

---

## Usage
### Standard Markup

```html
<th-tabset>
  <th-tab name="Tab One">
    Tab One Content
  </th-tab>
  <th-tab name="Tab Two">
    Tab Two Content
  </th-tab>
</th-tabset>
```

You can also include transclude elements (such as `thButton` and `thDropdown`) by placing them in an `th-tab-action-bar` element:

### Markup with Buttons

```html
<th-tabset type="header">
  <th-tab name="Tab One">
    Tab One Content
  </th-tab>
  <th-tab name="Tab Two">
    Tab Two Content
  </th-tab>

  <th-tab-action-bar>
    <th-dropdown name="Dropdown" type="standard">
      <th-item url="#" name="First"></th-item>
      <th-item url="#" name="Second"></th-item>
    </th-dropdown>
    <th-button>Button</th-button>
  </th-tab-action-bar>
</th-tabset>
```

---

## Accessibility

The `thTabset` component adheres to the standards set in the [WAI-ARIA Authoring Practices 1.1](https://www.w3.org/TR/wai-aria-practices-1.1/#tabpanel) document.

### Keyboard Interaction
`thTabset` tabs be navigated (and toggled) with the `Left` and `Right` arrow keys.

`thButton` and `thDropdown` elements in the `th-tab-action-bar` element can be
navigated with the `Tab` key as expected.

---

## Notes

- Combine this with `th-lazy` for an extreme team of lazy-loaded tabs!

---
