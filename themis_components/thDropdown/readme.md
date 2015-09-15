# Dropdown Button — `thDropdown`

### Description

Add a button that when clicked displays a dropdown list.

`thDropdown` will accept an array of objects that when created correctly will display each as list items

---

### Markup

`<th-dropdown name="click me" list="listItems"></th-dropdown>`

---

### Notes

The colors grey, red, and green can be passed to style the button accordingly. Blue is set by default.

ex. `[{name: "first", url: "/link", color: "red"}]`

Icons can be passed as a property of your objects and will be added before the corresponding list name.
You can choose from any of the icons from the [Font Awesome](https://fortawesome.github.io/Font-Awesome/icons/ "icons!") collection.
Include only the relevant name of the icon you want and we'll fill in the rest.

ex. `[{name: "first", url: "/link", icon: "thumbs-o-up"}]`

Dividers - styled divider can be added by just including it as an object in your array

ex. `[{name: "first", url: "/link"}, {type: "divider"}, {name: "second", url: "/link"}]`

Pass a function to be invoked on click instead of a url. Take a look at some of the examples to see this in action.

---
