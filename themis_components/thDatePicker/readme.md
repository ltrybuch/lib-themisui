# `thDatePicker`

## Description

You use 'thDatePicker' to create an input field that contains a string according to a date format. On focus, a Date Picker grid is displayed. After selecting a date, or deselecting the component, the grid disappears.

### Date Formats
The date format can be set through a `format` parameter.  
- 'YYYY-MM-DD' (default)
- 'MM/DD/YYYY'
- 'DD/MM/YYYY'

If the input field is blank, it will display a placeholder message based on the current date format. (E.g., 'YYYY-MM-DD')

## Usage

### Markup
```
<th-date-picker ng-model="date"></th-date-picker>
```
With optional format parameter:
```
<th-date-picker ng-model="date" format='DD/MM/YYYY'></th-date-picker>
```