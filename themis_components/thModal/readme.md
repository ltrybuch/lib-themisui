# Modal — `thModal` / `thModalAnchor`

## Description

Creating a simple modal for your content is easy!

1. `<th-modal-anchor></th-modal-anchor>` is required in the body of your application

2. You must inject the `ModalManager` service into your controller in order to push your modal into the queue of modals

3. Use `ModalManager.show path: path, params: params, name: name` to add your modal and show it.
Both `name` & `params` are optional. `path` is **not** optional.

---

### Notes

`show()` will return a promise [?](http://andyshora.com/promises-angularjs-explained-as-cartoon.html "Learn about promises")

Use `modal.dismiss(reason)` in your template to dismiss the modal rejecting the promise.

Use `modal.confirm(response)` in your template to dismiss the modal resolving the promise.

If you are not using the modal as a confirm action or something else that requires a promise it's probably best to use `dismiss`.

Passing a `name` option will add that name as a class to the modal.

Use `$scope.modal.dimiss()` or `$scope.modal.confirm()` inside your modal controller to perform your own actions before resolving the promise.

```coffeescript
  $scope.confirmModal = ->
    #do stuff...
    $scope.modal.confirm("yes!")
```

