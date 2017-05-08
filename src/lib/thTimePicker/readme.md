# Time Picker

<span class="badge orange">In Progress</span>

`thTimePicker` is used for inputting a time either from a dropdown list or through text entry.
Valid formats for the user include:
* H:mt
* Hmt
* H:m t
* Hm t
* Ht
* H t
* H:m
* Hm
* H

## Usage

```html
<th-time-picker
  ng-model="time"
  on-change="onChange"
  min="min"
  max="max"
  >
</th-time-picker>
```

## API Reference

| Property         | Type        | Description   |   |
|:-------------    |:-------     | :-------------|---|
| **name**  | String    | The name used when submitting value as part of a form. | *optional* |
| **ng-model**  | Moment    | Used for providing initial value to the time picker. | *required* |
| **on-change**  | Function  | Called whenever the selected time is changed. | *optional* |
| **format**  | String   | Specifies the format used for displaying the selected time. | *optional* |
| **min**  | Moment    | The minimum value of the time picker. | *optional* |
| **max**  | Moment    | The maximum value of the time picker. | *optional* |
| **placeholder**  | String    | Default text that is displayed prior to the user selecting a time. | *optional* |
| **custom-validator**  | Object    | Customize validator rules as well as error messages. See [Custom Validators](.\component\thDatePicker#custom-validator). | *optional* |
