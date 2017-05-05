# Dropdown Button

<span class="badge red">Deprecated</span>

Add a button that when clicked displays a dropdown list.
`thDropdown` will accept an array of objects that when created correctly will display each as list items.
Acceptable attributes include `url`, `type`, `divider`, `name`, `icon`. Examples below.

## Usage
```
<th-dropdown name="click me" list="listItems"></th-dropdown>
```

-------- and / or ---------

`thDropdown` will transclude anything passed in and append to the end of the button menu. The `thItem` component, as an example, is avaiable to populate your shiny new menu.
```
<th-dropdown name="click me">
  <th-item name="Item One" url="#"></th-item>
  <th-item name="Item Two" ng-click="someAction()"></th-item>
</th-dropdown>
```

## Notes

- The types `destroy`, `create`, and `secondary` are accepted to color the button. If a type is not given it will set the button color to blue.

  ```
  <th-dropdown name="New" type="create" list="menuItems"></th-dropdown>
  ```
- An `icon` type is accepted. The icon will be added before the corresponding list name.
You can choose from any of the icons from the [Font Awesome](https://fortawesome.github.io/Font-Awesome/icons/ "icons!") collection.
Include only the relevant name of the icon.
  ```
  [{name: "first", url: "/link", icon: "thumbs-o-up"}]
  ```
- Use the `th-divider` component or include `{divider:"true"}` in your array to add a styled divider.
  ```
  <th-dropdown name="Btn">
    <th-item name="#1" url="#"></th-item>
    <th-divider></th-divider>
    <th-item name="#2" url="#"></th-item>
  </th-dropdown>
  ```
- ng-click can be used instead of the `href` attribute. When the corresponding menu item is clicked that `ng-click` will be invoked. If both are added the `href` attr will override.
- If multiple action attributes are included the menu item will select `url` first, `action` next, and divider last. If nothing is passed in it will set the menu item to a `th-divider`.

## Accessibility

The `thDropdown` component adheres to the standards set in the [WAI-ARIA Authoring Practices 1.1](https://www.w3.org/TR/wai-aria-practices-1.1#Listbox) document.

### Keyboard Interaction
`thDropdown` can be activated with either the `Space` or `Enter` keys. Once active, it can be navigated with the `Down` and `Up` arrow keys or be closed with the `Escape` key.

### Optional Accessibility Attributes
* `aria-label` [string] Screen readers will read the button's text content by
default. Setting the `aria-label` attribute will override the text read by the
screen reader.

* `aria-describedby` [string] A description of a button's function can be
provided by setting the `aria-describedby` attribute to that of the `id` of the
description element.
