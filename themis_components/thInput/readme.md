# Input — `thInput`

## Description

Add your input fields with a little style. Unlike `<input>`, `<th-input>` must be
explictly closed. This is a browser enforced limitation of custom elements.

#### Plenty of options can be passed into your input including.. Icons, Postfix, Prefix:

[condensed="boolean"]
- Set to `true` to reduce the height of `th-input` by 25%. Defaults to `false`.

[icons="string"]
- Any [Font Awesome](https://fortawesome.github.io/Font-Awesome/icons/ "icons!")
font can be used by just passing in the relevant name. ex: `icon="dollar"` for `'fa fa-dollar'`

[prefix="string"]
- Prepend text to the begining of your input field.

[postfix="string"]
- append text to the end of your input field.

#### HTML `<input>` attributes can be passed in like you normally would:

[name="string"]
- Property name of the form under which `th-input` is added.

[placeholder="string"]
- The placeholder attribute specifies a short hint that describes the expected value.

[value="string"]
- The value attribute specifies the value of `th-input`. When using `ng-model` this
attribute is ignored.

[type="string"]
- The type attribute specifies the type of element to display. The default type is: text.
[HTML docs](https://developer.mozilla.org/en-US/docs/Web/HTML/Element/input)

[ng-disabled="string"]
- Set the disabled attribute if the expression inside evaluates to truthy.

Angular's input validation attributes are all optional attributes for `<thInput>`
  - [[ng-required="string"]](https://docs.angularjs.org/api/ng/directive/ngRequired)
  - [[ng-minLength="number"]](https://docs.angularjs.org/api/ng/directive/ngMinlength)
  - [[ng-maxLength="number"]](https://docs.angularjs.org/api/ng/directive/ngMaxlength)
  - [[ng-pattern="string"]](https://docs.angularjs.org/api/ng/directive/ngPattern)

---

## Notes

- If adding an icon to your input field you *cannot* also add a prefix as they exist in the same space.
- This component is mainly useful for text input ex: `type="text"` `type="password"` but also works great for a file selector ex: `type="file"`
