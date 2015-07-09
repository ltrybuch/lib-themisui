# `thButton`

## Description

You use `thButton` create and manage the buttons used, for example, in the submit button on a form.

## Usage

To get the standard Clio button colors, we can add a class.

- creation : Clio's green button used for form submissions that create an object

- destructive: Clio's red button used for destroying an object

- default: Clio's blue button used for the 'default option' pattern 

A thButton with no class specified will be given the Clio's grey button styling.

### Markup
```
<th-button ng-click="controller.action()" text="JS Action"></th-button>
```

```
<th-button type="submit" text="Submit"></th-button>
```

```
<th-button href="http://google.com" text="Visit URL"></th-button>
```