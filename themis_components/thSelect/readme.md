# Select — `thSelect`

## Description
`th-select` is a replacement for the standard HTML select element. Use `th-select`
instead of `<select>` when you want to present a list of options from which the
user can choose one.


`th-select` can be used either as a **single directive** or as a **traditional select**
with `option` elements included. See below for more details.

---

### Attributes
- [ng-required="string"] Adds required attribute and required validation constraint
to the element when the ngRequired expression evaluates to true.
- [ng-change="string"] Expression to be executed when selected option changes due
to user interaction with the select element. Note, this **requires** ngModel to be present.
- [ng-model="string"] Assign a model
- [ng-disabled="string"] Adds disabled attribute to the element when the ngDisabled
expression evaluated to true.
- [name="string"] Property name of the form under which `th-select` is added.

  #### Applicable to option 2 only

- [placeholder="string"] Adds an initial option as a placeholder. Useful if the
value is optional. **Note:** If you do **not** need a placeholder then it's advised
to set the `ng-model` to reference a object from your `options` array. If not, then
a blank option will be inserted and set to `selected`. This attribute will be ignored
when using transcluded options (option 1).
- [options="array"] An array of `option` objects. Requires a `name` and `value` property.
Optionally add a `group` property to group your `options` together.

---

### Option 1 (HTML)
The `th-select` can be used in the same manner as a native `select` if Angular
controllers are not being utilized. Mark one of the `options` as `selected` to
set it as checked.

You are free to use the `optgroup` element inside the component as it will be
transcluded along with the rest of the `option`s passed.

Make sure to set a `selected` option so that `th-select` knows which value
to display on default.

### Markup
```HTML
  <th-select name="color">
    <option value="red" selected>Red</option>
    <option value="blue">Blue</option>
    <option value="White">White</option>
  </th-select>
```

---

### Option 2 (Angular Ctrl)
Use by passing an array of objects with the property names of `name` and `value`
as an attribute. The `ng-model` must be a reference to one of the object for it
be set as `selected` in the dropdown options list.

Adding the `placeholder` attribute is necessary for `ng-required` to work. The
`placeholder` is added as a separate `option` outside of the array of `options`
because anything inside the array of `options` is considered valid by Angular and
thus will never trigger a `form.selectName.$error.required` error in your Angular form.

### Markup
```HTML
  <th-select
    placeholder="Choose.."
    name="transportation_type"
    options="vehicles"
    ng-model="type">
  </th-select>
```
```coffeescript
  vehicles = [
    {name: "Car", value:"1", group: "ground"}
    {name: "train", value:"2", group: "ground"}
    {name: "plane", value:"2", group: "air"}
    {name: "helicopter", value:"2", group: "air"}
  ]
  type = vehicles[0]
```

---

## Notes
- `th-select` implementation must be either with **option 1 (HTML)** or **option
2 (Angular Ctrl)**. If there is a mix of styles the **option 2** will be the default
and the `options` array will be used to build the options list.
- The `option` elements (dropdown list items) are rendered by the OS so will look slightly
different depending on what OS is being used.
