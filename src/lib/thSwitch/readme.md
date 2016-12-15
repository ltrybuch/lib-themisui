# `thSwitch`

## Description

You use `thSwitch` create and manage the On/Off buttons used, for example, in the toggle between Clio Next and Legacy. They are also used do toggle inline settings and can often be used in place of a checkbox. These objects are known as switches.

## Usage

### Markup
```
<th-switch ng-model="state"></th-switch>
```
Specify an optional expression to evaluate using `ng-change` and/or `ng-click`.
```
<th-switch ng-model="state" ng-change="someAction()"></th-switch>
```
