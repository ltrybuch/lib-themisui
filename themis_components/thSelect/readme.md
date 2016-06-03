# Select — `thSelect`

## Description
`th-select` is a replacement for the standard HTML select element. Use `th-select`
instead of `<select>` when you want to present a list of options from which the
user can choose one.

`th-select` can be used either as a **traditional select**  with `option` or `optgroup`
elements to be transcluded or as a **single directive** with an array of object
that will be rendered by the directive as `option`s or `optgroup`s. See below for
more details.

---
### Markup with HTML elements
```html
   <th-select>
    <optgroup label="British Columbia">
      <option value="bby" selected>Burnaby</option>
      <option value="van">Vancouver</option>
    </optgroup>
    <optgroup label="Alberta">
      <option value="cal">Calgary</option>
      <option value="edm">Edmonton</option>
    </optgroup>
  </th-select>
```

- The `th-select` can be used in the same manner as a native `select` if Angular
controllers are not being utilized.
- Make sure to set a `selected` option so that `th-select` knows which value
to display on default. If none of the options are `selected` then no initial
text will be displayed.

---
### Markup with options array
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
    {name: "Car", value:"1", group: "Ground"}
    {name: "Train", value:"2", group: "Ground"}
    {name: "Plane", value:"2", group: "Air"}
    {name: "Helicopter", value:"2", group: "Air"}
  ]
  type = vehicles[0]
```

- Use by passing an array of objects with the property names of `name` and `value`
as an attribute.
- If the `ng-model` value is a reference to one of the object in the array then the
`option` rendered will be set to `selected` in the dropdown list.

---
## Attributes

[placeholder="string"]
- can be used to add a initial `option` to your dropdown list. This `option`'s
value will be set to an empty string and the `option`'s text use the placeholder's
value.

[ng-required="string"]
- Adds required attribute and required validation constraint to the element when
the `ngRequired` expression evaluates to true.
- Because the `placeholder` adds a initial "blank" `option` it is considered an
invalid select value in your form and Angular will set the `$error.required` to
be `true` if selected. Example 4 shows working demo of this.

[ng-change="function"]
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

[options="array"]
- An array of `option` objects. Requires a `name` and `value` property.
- Optionally add a `group` property to group your `options` together. See example 2.
- Since the `group` property's value will be the corresponding `<optgroup>`'s label
(making it visible to the user) be sure to style the text appropriately.

[condensed="boolean"]
- Set to `true` to reduce the height of `th-select` by 25%. Defaults to `false`.

---
## Notes
- The `option` elements (dropdown list items) are rendered by the OS so will look
slightly different depending on what OS is being used.
- If you do **not** need a placeholder then it's advised to set the `ng-model` to
reference a object from your `options` array to set it as `selected`.
- If the `placeholder` is not present and `ng-model` is not referencing an object
in the `options` array or is not present then `th-select` will initially be blank.
