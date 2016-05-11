# Input — `with-Messages`

## Description

Use the `with-messages` directive as an attribute on a input component to add
styled error messages.

`with-messages` works with:
- `th-select`
- `th-input`
- `th-textarea`
- `th-radio-group`
- `th-checkbox`
- `th-switch`

---
## Usage
This is a quick example before digging deeper into the requirements and options available.

```html
<form name="form" novalidate>
  <th-input
    with-messages
    ng-model="modelName"
    ng-required="true"
    name="text"
    >
  </th-input>
</form>
```

- In order for `with-messages` to work the element it is attached to must be part
of a form. This means that `with-messages` will look for the form element as its
parent element and will throw an error if not found.

- A `name` attribute is required for both the form element and the input element
using `with-messages`. Adding the `name` will include the element in the form
validation object. [Angular form docs](https://docs.angularjs.org/guide/forms)

- `ng-model` is also required on the element using `with-messages`.

- `with-messages` stores its own default messages per each type of validation:
  - `required` = "This field is required."
  - `minlength` = "Please enter at least minlength* characters."
  - `maxlength` = "Please enter no more than maxlength* characters."
  - `pattern` = "The formatting is incorrect."
  - `number`** = "Please enter a number."
  - `min`\*\* = "Please enter a valid number equal to or greater than minNumberValue*."
  - `max`\*\* = "Please enter a valid number less than or equal to maxNumberValue*."
  - If both the `min` and `max` attributes are set then a number range message will be
  applied for both the `min` and `max` message.
  - `min` & `max` = "Please enter a number between minNumberValue\* and maxNumberValue\*"


  \* Value taken from the validation attribute.

  ** These attributes are only applicable to input `type="number"` and will be
  ignored without it.

- These default messages can (and probably be should) be overridden by passing in a
collection of custom messages that cover the validation types that you are using.
Each object should have key of validation type and a value of the message to return.
Any type that is missed will gracefully fall back to the default messages.

```coffeescript
# controller
@customValidationMessages =
  required: "Hey, sucka! I'm required!"
  maxlength: "I got no time for the jibba-jabba."
  minlength: "I pity the fool, who don't add more text."
  pattern: "Life's tough, but I'm tougher."
  number: "Hey fool, this ain't no number!"
  min: "I don't hate low number values, I pity them!"
  max: "Don't make me mad with your high number value, Arrr!"

# view
<form name="form" novalidate>
  <th-input
    with-messages="ctrl.customValidationMessages"
    ng-model="modelName"
    ng-required="true"
    name="text"
    >
  </th-input>
</form>
```

---
## Notes
- Note that `novalidate` is used on the form element to disable the browser's
native form validation. Otherwise there may be some unwanted message duplication.
- Use the same custom message array on all of your form elements if they apply to
save from duplicating the messages. If your field element is *not* using one of the
`type`s in the messages array passed in then it will just be ignored by that message.
- A great reference when writing your own custom validation messages can be found
[here](http://uxmovement.com/forms/how-to-make-your-form-error-messages-more-reassuring)
- The error message is triggered in several ways depending on the input type being used:
  - `type = "text"` : triggered when then value is invalid and the field loses focus.
  - `type = "select"` : triggered when then value is invalid and the field loses focus.
  - `type = "textarea"` : triggered when the value is invalid and the field loses focus.
  - `type = "checkbox"` : triggered when the value is invalid and the form has been submitted.
  - `type = "radiogroup"` : triggered when the value is invalid and the form has been submitted.

