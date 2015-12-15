# Radio Buttons - `thRadioGroup` / `thRadioButton`

Radio buttons are used to present a set of related choices, from which the user can only choose one.

## Design Patterns

Use radio buttons when you need to display a set of mutually exclusive choices to the user. For cases when the user can choose more than one element at a time, see [thCheckbox](.\thCheckbox).

Radio buttons are typically used in groups of two or more. As such, they are not used for toggling state on/off, see [thSwitch](.\thSwitch).

Radio buttons are not typically used to initiate an action, see [thButton](.\thButton).

It is possible for none of the buttons to be selected initially, but this state cannot be restored through interacting with the radio group.

## Usage

The `th-radio-group` element delimits the set of choices.

The `th-radio-button` element indicates one choice within a set.

The `th-radio-group` element must specify an `ng-model` attribute. This property is updated by the radio group when the user interacts with the widget. The value of `ng-model` determines which element is initially selected by comparing to the `value` attribute of `th-radio-button`. If `ng-model` evaluates to null or undefined, none of the buttons will be selected initially. 

When using in a form, a `name` attribute must be present on `th-radio-group`. If no `name` attribute is present or no button is checked, a name-value pair is not passed when the form is submitted.

`ng-change` is optionally specified on `th-radio-group` and `th-radio-button` elements. When specified on `th-radio-group`, the expression is evaluated every time the user selects a new button. On `th-radio-button`, the expression is evaluated only when that button becomes checked or unchecked.

### Markup

```
<th-radio-group ng-model="colour">
  <th-radio-button value="red"></th-radio-button>
  <th-radio-button value="green"></th-radio-button>
  <th-radio-button value="blue"></th-radio-button>
</th-radio-group>
```

Specify an optional expression to evaluate using ng-change on the `thRadioGroup` / `thRadioButton` elements.

```
<th-radio-group ng-model="colour" ng-change="colourChanged()">
  <th-radio-button value="red"></th-radio-button>
</th-radio-group>
```

Style radio buttons in group.

```    
<th-radio-group name="avatar" ng-model="demo.avatar">
  <label class="image-label">
    <img src="http://placehold.it/150x150?text=One">
    <br>
    <th-radio-button value="one"></th-radio-button>
  </label>
</th-radio-group>
```

## Notes
- Add a `name` attribute to `th-radio-group` for use in forms.


