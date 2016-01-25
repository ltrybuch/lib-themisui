# Select — `thSelect`

## Description
`th-select` is a replacement for the standard HTML select element. Use `th-select`
when you want to present a list of options from which the user can select one. The
`option` elements are the same native rendered `option` elements used with a standard
`select` element but the `select` itself has been styled to match the ThemisUI theme.

`th-select` can be used either as a single component or as a more traditional select
with `option` elements included.

---

### Option 1 (HTML)
The `th-select` can be used in the same manner as a native `select` if Angular
controllers are not being utilized. Mark one of the `options` as `selected` to
set it as checked.
```HTML
  <th-select name="color">
    <option value="red" selected>Red</option>
    <option value="blue">Blue</option>
    <option value="White">White</option>
  </th-select>
```
#### Optional attributes
- [ng-required="string"] Adds required attribute and required validation constraint
to the element when the ngRequired expression evaluates to true.
- [ng-change="string"] Expression to be executed when selected option changes due
to user interaction with the select element. Note, this **requires** ngModel to be present.
- [ng-model="string"] Assign a model
- [ng-disabled="string"] Adds disabled attribute to the element when the ngDisabled
expression evaluated to true.
- [name="string"] Property name of the form under which `th-select` is added.
- You are free to use the `optgroup` element inside the component as it will be
transcluded along with the rest of the `option`s passed.
- **Note**: Make sure to set a `selected` option so that `th-select` knows which value
to display on default.

---

### Option 2 (Angular Ctrl)
It can also be used by passing an array of objects with the property names of `name`
and `value` as an attribute. The `ng-model` must be a reference to one of the object
for it be set as `selected` in the dropdown options list.
```HTML
  <th-select
    placeholder="Pick a color.."
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
#### Optional attributes
- [ng-required="string"] Adds required attribute and required validation constraint
to the element when the ngRequired expression evaluates to true.
- [ng-change="string"] Expression to be executed when selected option changes due
to user interaction with the select element. **Note**: this requires `ngModel` to be present.
- [ng-model="string"] Assign a model
- [ng-disabled="string"] Adds disabled attribute to the element when the ngDisabled
expression evaluated to true.
- [name="string"] Property name of the form under which `th-select` is added.
- [placeholder="string"] Adds an initial option as a placeholder. Useful if the
value is optional. **Note:** If you do **not** need a placeholder then it's advised
to set the `ng-model` to reference a object from your `options` array. If not, then
a blank option will be inserted and set to `selected`.
- [options="string"] An array of objects. Requires a `name` and `value` property.
- Grouping your `options` together is also possible with option 2. Just add a
`group` property to the objects in your array of `options` that are passed in. Example:
```coffeescript
  vehicles = [
    {name: "Car", value:"1", group: "ground"}
    {name: "train", value:"2", group: "ground"}
    {name: "plane", value:"2", group: "air"}
    {name: "helicopter", value:"2", group: "air"}
  ]
```

---

## Notes
- `th-select` implementation must be either with **option 1 (HTML)** or **option
2 (Angular Ctrl)**. If there is a mix of styles the **option 2** will be the default
and the `options` array will be used to build the options list.
- Adding the `placeholder` attribute is necessary for `ng-required` to work. The
`placeholder` is added as a separate `option` outside of the array of `options`
because anything inside the array of `options` is considered valid by Angular and
thus will never trigger a `form.name.$error.required` error in your Angular form.
