# `thCheckbox`

## Description

You use `thCheck` create and manage checkboxes used, for example, in forms. This directive can be used in place of the default checkbox to help keep the view identical regardless of OS or browser.

### Attributes

[indeterminate="boolean"]
- Use this attribute to visually set your checkbox to a "mixed" state. Helpful when working with nested
lists or tree views and the entire collection is not selected / deselected. This value can only be assigned
programmatically and will always be overridden by the underlying checkbox value when clicked.
- The value of indeterminate has no baring on the `thCheckbox`'s value and will continue to be whatever
it was prior to the `indeterminate`'s toggling.
- The indeterminate state can give the illusion that `thCheckbox`'s value has change but it has not
so be sure to update boolean checkbox's values when needed.

[ng-disabled="boolean"]
- Set the disabled attribute if the expression inside evaluates to truthy.

[ng-change="expression"]
- Expression to be executed when selected option changes due to user interaction. ie When `thCheckbox`
is clicked.
- This **requires** ngModel to be present.
[ng-change Angular docs](https://docs.angularjs.org/api/ng/directive/ngChange).

---

## Usage

### Markup
```
<th-checkbox ng-model="state"></th-checkbox>
```
Specify an optional expression to evaluate using `ng-change` and/or `ng-click`.
```
<th-checkbox ng-model="state" ng-change="someAction()"></th-checkbox>

```

---

## Accessibility

The `thCheckbox` component adheres to the standards set in the [WAI-ARIA Authoring Practices 1.1](https://www.w3.org/TR/wai-aria-practices-1.1/#checkbox) document.

### Keyboard Interaction
`thCheckbox` can be toggled with the `Space` key.

### Optional Accessibility Attributes
* `aria-describedby` [string] A description of a checkbox's function can be
provided by setting the `aria-describedby` attribute to that of the `id` of the
description element.

---
