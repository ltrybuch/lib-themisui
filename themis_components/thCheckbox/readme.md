# `thCheckbox`

## Description

You use `thCheck` create and manage checkboxes used, for example, in forms. This directive can be used in place of the default checkbox to help keep the view identical regardless of OS or browser.

## Usage

### Markup
```
<th-checkbox ng-model="state"></th-checkbox>
```
Specify an optional expression to evaluate using `ng-change` and/or `ng-click`.
```
<th-checkbox ng-model="state" ng-change="someAction()"></th-checkbox>
```
