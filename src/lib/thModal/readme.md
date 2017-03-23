# Modal

`ModalManager` is the main point of interaction when showing and hiding modals.

## Syntax

### With template URL
```coffeescript
ModalManager.show
  path: "/template-path"
  params:
    optional: params
  name: "class-name"
  context:
    id: 100
```

### With template string
```coffeescript
ModalManager.show
  template: "<h1>Header</h1>"
  name: "class-name"
  context:
    id: 100
```

### Showing a full page modal
**Note:** This is not ready for production launch yet. Do not use this feature
unless you are behind an Apollo related feature flag, and do not launch to public yet.
```coffeescript
ModalManager.show
  template: "<h1>Full Page Modal</h1>"
  name: "my-fullpage-modal"
  size: "fullpage"
```

### Confirm and close a modal within a controller.
```coffeescript
$scope.confirmModal = ->
  #do stuff...
  $scope.modal.confirm("yes!")
```

### Referencing `context` within a controller.
```coffeescript
angular.module("ExampleApp").controller "modalController", ($scope) ->
  localContext = $scope.modal.context # now you can use me in your controller
```

### Confirm and close a modal within a template.
```html
<div>
  <th-modal-titlebar title="Foo"></th-modal-titlebar>
  <h3>Very exciting message!</h3>
  <button ng-click="modal.confirm('Yes!')">Confirm</button>
  <button ng-click="modal.dismiss('Never!')">Cancel</button>
</div>
```

### Referencing `context` within a template.
```html
<div>
  <th-modal-titlebar title="Foo"></th-modal-titlebar>
  <h3>You are editing Item # {{modal.context.id}}</h3>
</div>
```

## Methods

### `show(options<object>)` → `Promise`
> The returned promise will resolve if the modal is closed with a `confirm` action.

#### Options
**Note:** When creating a modal you are required to provide one of `path` or `template`.

- `path<string>`
  - The URL path to the template to be used for the modal.
- `template<string>`
  - Template string to be passed into the modal as its template.
- `name<string>` [optional]
  - The name will be added as a class to the modal.
- `context<object>` [optional]
  - Values in this object will be made available within the modal.
- `params` [optional]
  - Any required params for your template URL.
- `size` [optional]
  - **NOT READY FOR PRODUCTION LAUNCH** Do not use this feature unless you are behind an
  Apollo related feature flag, and do not launch to public yet.
  - Set to "fullpage" for a Full Page Modal. Defaults to "medium" if not specified.

### `dismiss(name<string>, response<object>)`
> Close the modal named `name`. **Note:** The `response` parameter is deprecated and will be
> removed in a future release.

### `confirm(name<string>, response<object>)`
> Close the modal named `name`. This will also *resove* the promise that was returned when creating
> this modal with the contents of `response`.

## Scope Properties
A number of properties are made available on the scope within your modal template. They can be
referenced from within the template as listed below. Or, from within your template's controller by
injecting `$scope`.

### `modal.dismiss(response<object>)`
> This an alias to `ModalManager.dismiss` referencing the context of the current modal and passing
> `response` through. **Note:** The `response` parameter is deprecated and will be removed in a
> future release.

### `modal.confirm(response<object>)`
> This an alias to `ModalManager.confirm` referencing the context of the current modal and passing
> `response` through.

### `modal.context`
> Any values passed to the current modal in `context` upon its creaton will be available here.


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
> A long title will be truncated with an ellipsis.

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
