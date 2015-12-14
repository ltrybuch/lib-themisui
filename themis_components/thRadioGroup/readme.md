# Radio Buttons - `thRadioGroup` / `thRadioButton`

## Description

Use radio buttons to display a set of choices from which the user can only choose one. The `thRadioGroup` element delimits the set of related choices while each choice is specified using the `thRadioButton` element.

## Usage

### Markup

```
<th-radio-group ng-model="colour">
  <th-radio-button value="red"></th-radio-button>
  <th-radio-button value="green"></th-radio-button>
  <th-radio-button value="blue"></th-radio-button>
</th-radio-group>
```

Specify an optional expression to evaluate using ng-change and/or ng-click on the `thRadioGroup` / `thRadioButton` elements.

```
<th-radio-group ng-model="colour" ng-change="colourChanged()">
  <th-radio-button value="red" ng-click="redClicked()"></th-radio-button>
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


