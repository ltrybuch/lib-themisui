# `thDatePicker`

## Description

You use 'thDatePicker' to create an input field that contains a string according to a date format. On focus, a Date Picker grid is displayed. After selecting a date, or deselecting the component, the grid disappears.

The date format can be set through a `format` parameter.  The default format is 'YYYY-MM-DD', but two other expected formats can be set: 'MM/DD/YYYY' and 'DD/MM/YYYY'.

If the input field is blank, it will display a placeholder message based on the current date format. (E.g., "yyyy-mm-dd")

## Usage

### Markup
```
<th-date-picker ng-model="date"></th-date-picker>
```
With optional format parameter:
```
<th-date-picker ng-model="date" format='dd/mm/yyyy'></th-date-picker>
```