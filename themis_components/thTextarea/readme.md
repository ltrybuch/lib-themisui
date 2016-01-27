# Input — `thTextarea`

## Description

The `<textarea>` tag defines a multi-line text input control. The height of a text
area can be specified by the rows attributes, or even better; through CSS' height property.
`<thTextarea>` is a replacement to the standard `<textarea>` element. It accepts many
of the same attributes such as `name`, `value`, `rows`, and `placeholder`.
## Markup

```html
  <th-textarea
    ng-model="value"
    placeholder="I'll be here if there is no value"
    icon="edit"
    rows="3">
  </th-textarea>
```
### Optional attributes
- [ng-required="string"] Adds required attribute and required validation constraint
to the element when the ngRequired expression evaluates to true.
- [ng-minLength] Sets `minlength` validation error key if the value is shorter than minlength.
- [ng-maxLength] Sets `maxlength` validation error key if the value is longer than maxlength.
- [ng-pattern] Sets `pattern` validation error key if the ngModel $viewValue does not match
a RegExp found by evaluating the Angular expression given in the attribute value.
[read more...](https://docs.angularjs.org/api/ng/directive/ngPattern)
- [ng-model="string"] Assign a model
- [ng-disabled="string"] Adds disabled attribute to the element when the ngDisabled
expression evaluated to true.
- [name="string"] Property name of the form under which `th-textarea` is added.
- [placeholder="string"] Adds placeholder text to the element.
- [icon="string"] Sets a icon on the right side of the textarea.
Any [Font Awesome](https://fortawesome.github.io/Font-Awesome/icons/ "icons!")
font can be used by just passing in the relevant name. ex: `icon="dollar"` for `'fa fa-dollar'`


## Notes
- Because `th-textarea`'s width is set to 100% there is no need to set the `cols`
attribute. Override the width using CSS.
