# Input — `with-label` / `with-subtext`

## Description

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

`<th-input
  with-label="My Label Name"
  with-subtext="Additional info here"
  ng-model="myModel"
  >
</th-input>`

- It can only be used as an attribute in conjunction with the `with-label` component.
- Existing labels for input types `checkbox` and `radio`,
will be moved to the top of their container, and the new label for the subtext will appear below.
- It can only be used with `thCheckbox` and `thRadioButton` components,
provided they are also using the `thWithLabel` component.

---
