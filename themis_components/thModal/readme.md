# Modal — `thModal` / `thModalAnchor`

## Description

Creating a simple modal for your content is easy!

1. `<th-modal-anchor></th-modal-anchor>` is required in the body of your application

2. You must inject the `ModalManager` service into your controller in order to push your modal into the queue of modals

3. Add the content source `path` to scope

4. The modal accepts a `name` and `params` object

5. Use `ModalManager.showModal(path, params, name)` to add your modal and show it

Use `modal.dismiss()` to dismiss.

