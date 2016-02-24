# `thDatePicker`

## Description

You use 'thDatePicker' to create an input field that contains a string according to a date format. 

On focus, a Date Picker grid is displayed. After selecting a date, or deselecting the component, the grid disappears. (Current implementation excludes popover behavior, and Themis styling.)

The input field can be edited by the user, allowing dates to be entered on the keyboard as well. When the element loses focus, it will attempt to make a date out of the input field contents. If an invalid date is entered, the input field contents do not alter the date selected in the datepicker. It will always revert to the last known good date entered.

### Date Formats
The date format can optionally be set through a `format` parameter.  
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
