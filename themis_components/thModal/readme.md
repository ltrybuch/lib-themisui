Modal
===

<!-- TOC depthFrom:1 depthTo:3 withLinks:1 updateOnSave:1 orderedList:0 -->

- [`ModalManager`](#modalmanager)
	- [Syntax](#syntax)
	- [Methods](#methods)
		- [`show(options<object>)` > `Promise`](#showoptionsobject-promise)
		- [`dismiss(name<string>, response<object>)`](#dismissnamestring-responseobject)
		- [`confirm(name<string>, response<object>)`](#confirmnamestring-responseobject)
	- [Scope Properties](#scope-properties)
		- [`modal.dismiss(response<object>)`](#modaldismissresponseobject)
		- [`modal.confirm(response<object>)`](#modalconfirmresponseobject)
		- [`modal.context`](#modalcontext)
- [`thModalAnchor`](#thmodalanchor)
	- [Syntax](#syntax)
- [`thModalTitlebar`](#thmodaltitlebar)
	- [Syntax](#syntax)
	- [Attributes](#attributes)
		- [`title<string>`](#titlestring)
		- [`show-close-button<boolean>` [optional]](#show-close-buttonboolean-optional)
		- [`type<string>` [optional]](#typestring-optional)

<!-- /TOC -->

# `ModalManager`

`ModalManager` is the main point of interaction when showing and hiding modals.

## Syntax

#### With template URL.
```coffeescript
ModalManager.show
	path: "/template-path"
	params:
		optional: params
	name: "class-name"
	context:
		id: 100
```

#### With template string.
```coffeescript
ModalManager.show
	template: "<h1>Header</h1>"
	name: "class-name"
	context:
		id: 100
```

#### Confirm and close a modal within a controller.
```coffeescript
$scope.confirmModal = ->
	#do stuff...
	$scope.modal.confirm("yes!")
```

#### Referencing `context` within a controller.
```coffeescript
angular.module("ExampleApp").controller "modalController", ($scope) ->
	localContext = $scope.modal.context # now you can use me in your controller
```

#### Referencing `context` within a template.
```html
<body>
	/** the context is being used directly in the view **/
	<h3>You are editing Item # {{modal.context}}</h3>
</body>
```

## Methods

### `show(options<object>)` > `Promise`
> The returned promise will resolve if the modal is closed with a `confirm` action or reject if the
> modal is closed with a `dismiss` action.

#### Options
**Note:** When creating a modal you are required to provide one of `path` or `template`.

- `path<string>`
  - The URL path to the template to be used for the modal.
- `template<string>`
  - Template string to be passed into the modal as its template.
- `name<string>` [optional]
  - The name will be added as a class to the modal/
- `context<object>` [optional]
  - Values in this object will be made available within the modal.
- `params` [optional]
  - Any required params for your template URL.

### `dismiss(name<string>, response<object>)`
> Close the modal named `name`. This will also *reject* the promise that was returned when creating
> this modal with the contents of `response`.

### `confirm(name<string>, response<object>)`
> Close the modal named `name`. This will also *resove* the promise that was returned when creating
> this modal with the contents of `response`.

## Scope Properties
A number of properties are made available on the scope within your modal template. They can be
referenced from within the template as listed below. Or, from within your template's controller by
injecting `$scope`.

### `modal.dismiss(response<object>)`
> This an alias to `ModalManager.dismiss` referencing the context of the current modal and passing
> `response` through.

### `modal.confirm(response<object>)`
> This an alias to `ModalManager.confirm` referencing the context of the current modal and passing
> `response` through.

### `modal.context`
> Any values passed to the current modal in `context` upon its creaton will be available here.

---

# `thModalAnchor`

This is required once in your application template. It will the anchor point from which any modals
will be opened.

## Syntax

```html
<html>
  <body>

    <!-- Page Content -->

    <th-modal-anchor></th-modal-anchor>

  </body>
</html>

```

---

# `thModalTitlebar`

A modal's titlebar is used to visibly name the modal and commonly provide it with a close button.

## Syntax

`thModalTitlebar` should be the first element within your modal's view.

```html
<th-modal-titlebar
  title="Foo"
  show-close-button="true|false"
  type="standard|destroy"
  >
</th-modal-titlebar>
```

## Attributes

### `title<string>`
> The title text to show in the titlebar.
>
> A long title will be truncated with ….

### `show-close-button<boolean>` [optional]
> Control if the close button is visible or not.

Defaults to true.

### `type<string>` [optional]
> Set the type of titlebar. This is used for different styles of titlebar if, for example you are
> displaying a message of a particular type to the user.

Accepts:
  - `standard`
  - `destroy`

Defaults to `standard`
