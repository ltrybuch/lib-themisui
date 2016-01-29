# Select — `thSelect`

## Description
`th-select` is a replacement for the standard HTML select element. Use `th-select`
instead of `<select>` when you want to present a list of options from which the
user can choose one.


`th-select` can be used either as a **traditional select (option 1)**  with `option`
elements to be transcluded or as a **single directive (option 2)** with an array of
object that will be rendered by the directive as `options`. See below for more
details.

---
### Option 1 (HTML)
- The `th-select` can be used in the same manner as a native `select` if Angular
controllers are not being utilized.

- Elements inside the component will be transcluded.

- Make sure to set a `selected` option so that `th-select` knows which value
to display on default. If none of the options are `selected` then no initial
text will be displayed.

### Markup
```html
  <th-select name="city">
    <optgroup>British Columbia</optgroup>
    <option value="bby" selected>Burnaby</option>
    <option value="van">Vancouver</option>
    <optgroup>Alberta</optgroup>
    <option value="cal">Calgary</option>
    <option value="edm">Edmonton</option>
  </th-select>
```
---
### Option 2 (Angular Ctrl)
- Use by passing an array of objects with the property names of `name` and `value`
as an attribute.

- If the `ng-model` value is a reference to one of the object in the array then the
`option` rendered will be set to `selected` in the dropdown list.

- `placeholder` can be used to add a initial `option` to your dropdown list. This
`option`'s value will be set to an empty string and the `option`'s text use the
placeholder's value.

- Example of a placeholder option:

  `placeholder="select one..."`

  **will result in**

  `<option value="">select one...</option>`

- If you plan to use `ng-required` to validate your `select` then adding the
`placeholder` attribute is neccessary. Because the `placeholder` adds a initial
"blank" `option` it is considered an invalid select value in your form and
Angular will set the `$error.required` to be `true` if selected. Example 4 shows
working demo of this.

### Markup
```html
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
## Attributes

[ng-required="string"]
- Adds required attribute and required validation constraint to the element when
the `ngRequired` expression evaluates to true.

[ng-change="string"]
- Expression to be executed when selected option changes due to user interaction
with the select element.
- This **requires** ngModel to be present.
[ng-change Angular docs](https://docs.angularjs.org/api/ng/directive/ngChange).

[ng-model="string"]
- Assign a model.

[ng-disabled="string"]
- Adds disabled attribute to the element when the ngDisabled expression evaluated
to true.

[name="string"]
- Property name of the form under which `th-select` is added.

#### Applicable to option 2 only

[placeholder="string"]
- Adds an initial "blank" option as a placeholder. Useful if the value is optional.
- If you do **not** need a placeholder then it's advised to set the `ng-model`
to reference a object from your `options` array. This will set that `option` as
`selected`. If the `placeholder` is not present and `ng-model` is not referencing
a object in the `options` array or is not present then the first `option` will be
set as `selected` by default.

[options="array"]
- An array of `option` objects. Requires a `name` and `value` property. Optionally
add a `group` property to group your `options` together. See example 2.
---
## Notes
- `th-select` implementation must be either with **option 1 (HTML)** or **option
2 (Angular Ctrl)**. If there is a mix of styles the **option 2** will be the default
and the `options` array will be used to build the options list and any elements inside
of `th-select` will be ignored.
- The `option` elements (dropdown list items) are rendered by the OS so will look slightly
different depending on what OS is being used.
