# Datepicker

You use 'thDatePicker' to create an input field that contains a string according to a date format.

The input field can be edited by the user, allowing dates to be entered on the keyboard as well. If an invalid date is entered, the input field will give an error message on losing focus.

## Usage
To be notified of a value change, pass a function reference to on-change. This function will be called whenever the internal value of the component has been updated and will be passed the new value as an argument.

```html
<th-date-picker ng-model="date" on-change="onchange"></th-date-picker>
```
## API Reference

### Properties
|              | Property        | Type            | Description   |
|:------------ |:--------------- | :---------------|---------------|
| *optional*   | **name**        | String          | The name used when submitting value as part of a form. **Required** for date validation to work.
| required     | **ng-model**    | Object (moment) | Updates to `value` in datepicker input box when the user selects a date from the component. Value passed in should be `moment` object.
| *optional*   | **ng-disabled** | Boolean         | Disables the component when true.
| *optional*   | **ng-required** | Boolean         | Enables `required` validate when true.
| *optional*   | **on-change**   | Function        | Called whenever `value` is updated within datepicker. Pass by reference only. The only parameter will be a `moment` object. If not provided, the value property of the datepicker input element would still update.
| *optional*   | **max**         | Object (moment) | Specifies the max value for dates. Unavailable dates would not appear in the picker. Takes a `moment` object.
| *optional*   | **min**         | Object (moment) | Specifies the min value for dates. Unavailable dates would not appear in the picker. Takes a `moment` object.
| *optional*   | **date-format** | String          | The format of the displayed date. Defaults to `yyyy-mm-dd`. See below for further options.
| *optional*   | **placeholder** | String          | Default text that is displayed prior to the user selecting a date. If not specified, will default to value of date format.
| *optional*   | **condensed**   | String          | Applies condensed styling to the component.
| *optional*   | **with-label**  | String          | Adds a label wrapping to the datepicker. For more options, see component `thWithLabel`.
| *optional*   | **custom-validator** | Object          | Customize validator rules as well as error messages. See details below.
| *optional*   | **revert-to-valid**  | Boolean          | When specified to `true`, invalid dates will not output error messages. Instead, it will revert to the last selected valid date or today's date if there wasn't one. Does not work with `ng-required`, and should not be used in forms.

### Date Formats
The date format can optionally be set through a `date-format` parameter, or the `thDefaults` service. Otherwise, date format is defaulted to `yyyy-mm-dd`. Valid building blocks of date formats include:
- `y`: December, 2017
- `yy`: 17
- `yyy`: 17y
- `yyyy`: 2017
- `m`: December 31
- `mm`: 12
- `mmm`: Dec
- `mmmm`: December
- `d`: 12/31/2017
- `dd`: 31
- `ddd`: Sun
- `dddd`: Sunday

If the input field is blank, it will display a placeholder message based on the current date format. (E.g., 'yyyy-mm-dd')

### Custom Validator
There are two built in validators for `<th-date-picker>`: `required` and `valid`. To override or add new rules or error messages, an object in the following shape can be passed in via the `custom-validator` binding:

```javascript
{
  rules: {
    required: function() {},
    valid: function() {},
    newRule: function() {}
  },
  messages: {
    required: "THIS IS ABSOLUTELY REQUIRED",
    valid: "NO WAY IS THIS VALID",
    newRule: "New Rule Error Message"
  }
}
```

To only override messages but not rules, omit the rules property in the custom validator object and vice versa. See demo #5 for an example usage.
