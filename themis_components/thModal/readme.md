# Modal — `thModal` / `thModalAnchor`

## Description

Creating a simple modal for your content is easy!

1. `<th-modal-anchor></th-modal-anchor>` is required in the body of your application

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
