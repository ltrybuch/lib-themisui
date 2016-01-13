# Select — `thSelect`

## Description
`th-select` is a replacement for the standard HTML select element.

#### Option 1 (HTML)
The `th-select` can be used in the same manner as a native `select` if databinding
/ angular controllers are not being utilized. Mark one of the `options` as `selected`
to set it as checked.
```HTML
  <th-select name="color">
    <option value="red" selected>Red</option>
    <option value="blue">Blue</option>
    <option value="White">White</option>
  </th-select>
```
#### Option 2 (Angular Ctrl)
It can also be used by passing an array of objects with the property names of `name`
and `value` as an attribute. The `ng-model` must be a reference to one of the object
for it be set as `selected` in the dropdown options list.
```HTML
  <th-select
    name="color"
    options="colors"
    ng-model="defaultColor">
  </th-select>
```
```coffeescript
  colors = [
    {name: "Red", value: "red"}
    {name: "Blue", value: "blue"}
    {name: "White", value: "white"}
  ]
  defaultColor = colors[0]
```
## Notes
- `th-select` inplementation must be either with **option one (HTML)** or **option
two (Angular Ctrl)**. If there is a mix of styles the option 2 will be the default
and the `options` array will be used to build the options list.


