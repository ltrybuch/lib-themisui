# With label / With subtext / With tooltip

Wrap your input fields in a styled label easily by adding this `with-label` component to it.

`<th-input with-label="My Label Name" ng-model="myModel"></th-input>`

- It can only be used as an attribute to an existing input element.
- By default the label prepended is to the input field which means that it will
show up above the element.
- Labels for input types `checkbox`, `switch` and `radio` are set inline.
- It can be used with any HTML element if one were so inclined but it is really
recommended for use with input elements.
- `with-label` works well with themisUi components:
  - thSelect
  - thInput
  - thCheckbox
  - thSwitch
- Using the `ng-required` attribute with any input element will add a "required" indicator.

Extend the functionality of `with-label` component by using it
in conjunction with the `with-subtext` component.

```
<th-input
  with-label="My Label Name"
  with-subtext="Additional info here"
  ng-model="myModel"
  >
</th-input>
```

- It can only be used as an attribute in conjunction with the `with-label` component.
- It currently works with thCheckbox, thRadio, and thInput.
- When added to inline elements such as `thCheckbox` and `thRadio` it will:
  - move the existing label to the top of their container, and the subtext will appear below it.
- When added to block elements such as `thInput` it will:
  - position the subtext directly below the input component.

You can also use `with-tooltip` with `with-label`.

```
<th-input
  with-label="My Label Name"
  with-tooltip="{{demo.tooltipTemplate}}"
  ng-model="myModel"
  >
</th-input>
```

- It currently only works with block elements such as `thInput`.
- It will place the tooltip directly beside the label.
- To properly format the content, css exists for the following elements inside an element 
with the class `help-wrapper`:
  - `<h4>`
  - `<p>`
  - `<a>`
- Most css is built-in to the component, but `width` should still be specified inside the template.

In the future, support should be added for inline elements.


---
