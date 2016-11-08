Modal
===

<!-- TOC depthFrom:1 depthTo:6 withLinks:1 updateOnSave:1 orderedList:0 -->

- [Overview](#overview)
- [`ModalManager`](#modalmanager)
	- [Promise](#promise)
	- [Context](#context)
- [`thModalAnchor`](#thmodalanchor)
	- [Usage](#usage)
- [`thModalTitlebar`](#thmodaltitlebar)
	- [Usage](#usage)
	- [Accessibility](#accessibility)
	- [Attributes](#attributes)
		- [`title` &lt;string&gt;](#title-ltstringgt)
		- [`show-close-button` &lt;boolean&gt; [optional]](#show-close-button-ltbooleangt-optional)
		- [`type` &lt;string&gt; [optional]](#type-ltstringgt-optional)

<!-- /TOC -->

# Overview

Creating a simple modal for your content is easy!

1. `<th-modal-anchor></th-modal-anchor>` is required in the body of your application.

2. You must inject the `ModalManager` service into your controller in order to push your modal into the queue of modals

3. Use
  `ModalManager.show(path: "/template-path", params: {optional: params}, name: "class-name", context: {id: 100})` or `ModalManager.show(template: "<h1>Header</h1>", name: "class-name", context: {id: 100})`
  to add your modal and show it.

  - **`path`**: path to the template to be used.
  - **`template`**: string to be passed into the modal as its template
  - **`name` [optional]**: will add that name as a class to the modal
  - **`context` [optional]**: pass local data into the modal
  - **`params` [optional]**: any required params for your template.


  Note that one of `path` or `template` must be provided.

---

# `ModalManager`





## Promise

`show()` will return a promise [?](http://andyshora.com/promises-angularjs-explained-as-cartoon.html "Learn about promises") which you can use to grab data from the just closed modal.

  - Use `modal.dismiss(reason)` in your template to dismiss the modal rejecting the promise.

  - Use `modal.confirm(response)` in your template to dismiss the modal resolving the promise.

  - Use `$scope.modal.dimiss()` or `$scope.modal.confirm()` inside your modal controller to perform your own actions before resolving the promise.

      ```coffeescript
        $scope.confirmModal = ->
          #do stuff...
          $scope.modal.confirm("yes!")
      ```

- If you are not using the modal as a confirm action or something else that requires a promise it's probably easiest to just use `dismiss`.

---

## Context

- Access the context passed into the modal either in the template itself or through the associated modal controller.

    ```coffeescript
      angular.module("ExampleApp").controller "modalController", ($scope) ->
        localContext = $scope.modal.context # now you can use me in your controller
    ```
    --**or**--
    ```HTML
      <body>
        /** the context is being used directly in the view **/
        <h3>You are editing Item # {{modal.context}}</h3>
      </body>
    ```

---

# `thModalAnchor`

This is required once in your application template. It will the anchor point from which any modals
will be opened.

## Usage

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

## Usage

`thModalTitlebar` should be the first element within your modal.

```html
<th-modal-titlebar
  title="Foo"
  show-close-button="true|false"
  type="standard|destroy"
  >
</th-modal-titlebar>
```

## Accessibility
TODO: Checkin with Craig on this.

## Attributes

### `title` &lt;string&gt;
> The title text to show in the titlebar.
>
> A long title will be truncated with ….

### `show-close-button` &lt;boolean&gt; [optional]
> Control if the close button is visible or not.

Defaults to true.

### `type` &lt;string&gt; [optional]
> Set the type of titlebar. This is used for different styles of titlebar if, for example you are
> displaying a message of a particular type to the user.

Accepts:
  - `standard`
  - `destroy`

Defaults to `standard`

---
