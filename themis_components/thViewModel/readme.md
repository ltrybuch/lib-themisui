# thViewModel

View models are meant to store application state (e.g. whether a table row is
selected) and regular models are meant to store data state. We don't really
want to store properties like `isVisible` or `selected` in the data model because
these details only exist for the UI and not something our data model cares about.

We can create a view model by passing our data and an object of ui properties
to the ViewModel class. This will wrap the base model so changes in the original
non-wrapped model will be in sync with the corresponding view model.

### Example:

Once set up we can now access our view properties in the view and make UI decisions
based on that state without the need to alter the attached data model.

```coffeeScript
# data from our API:
models = [{id: 1, name: "a"}, {id: 2, name: "b"}]

uiProperties = {selected: false, color: "red", fontSize: 12}

viewModels = models.map (model) -> new ViewModel(model, uiProperties)

# [
#   {model: {id: 1, name: "a"}, view: {selected: false, color: "red", fontSize: 12}}
#   {model: {id: 2, name: "b"}, view: {selected: false, color: "red", fontSize: 12}}
# ]

```

When selecting the item in the view you'll want to access the `view.selected`
property in the view model. See the `addItem` function to see this in action.

View:

```html
<div ng-repeat="vm in viewModels">
  <th-checkbox
    ng-model="vm.view.selected"
    ng-change="addItem(vm)"
    label="vm.model.name"
    ng-class="[{green: vm.view.color == 'green'}, {red: vm.view.color == 'red'}]"
    >
  </th-checkbox>
</div>
```
Controller:

```coffeescript
@addItem = (viewModel) ->
  viewModel.view.color = "green"
  selected.push viewModel.model.id
```
