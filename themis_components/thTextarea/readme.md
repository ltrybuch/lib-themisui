# Input — `thTextarea`

## Description

The `<textarea>` tag defines a multi-line text input control. `<thTextarea>` is
a replacement to the standard `<textarea>` element.

Unlike `<textarea>`, `<thTextarea>` ignores the `cols` and `rows` attributes for
sizing opting to instead require utilizing CSS' height and width properties.
## Markup

```html
  <th-textarea
    ng-model="model"
    placeholder="I'll be here if there is no value"
    icon="edit"
    >
  </th-textarea>
```
### Optional attributes
- Angular's textarea validation attributes are all optional attributes for `<thTextarea>`
  - [[[ng-required="string"]](https://docs.angularjs.org/api/ng/directive/ngRequired)
  - [[ng-minLength="number"]](https://docs.angularjs.org/api/ng/directive/ngMinlength)
  - [[ng-maxLength="number"]](https://docs.angularjs.org/api/ng/directive/ngMaxlength)
  - [[ng-pattern="string"]](https://docs.angularjs.org/api/ng/directive/ngPattern)
- [ng-model="string"] Assign a model
- [ng-disabled="string"] Adds disabled attribute to the element when the ngDisabled
expression evaluated to true.
- [ng-change="function"] Expression to be executed when selected option changes due
to user interaction with the select element. This **requires** ngModel to be present.
[ng-change Angular docs](https://docs.angularjs.org/api/ng/directive/ngChange).
- [name="string"] Property name of the form under which `th-textarea` is added.
- [placeholder="string"] Adds placeholder text to the element.
- [icon="string"] Sets a icon on the right side of the textarea.
- [expandable="boolean"] Lets you control the resizability of `th-textarea`. Defaults to `true`.
- [font="string"] Any [Font Awesome](https://fortawesome.github.io/Font-Awesome/icons/ "icons!")
font can be used by just passing in the relevant name. ex: `icon="dollar"` for `'fa fa-dollar'`.

## Notes
- `th-textarea`'s width is set to 100% so it will conform to the parent's width.
Set your width adjustments to the parent element and not directly on `th-textarea`.


