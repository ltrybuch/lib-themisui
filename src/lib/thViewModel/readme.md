# View Model

View models are meant to store application state (e.g. whether a table row is
selected) and regular models are meant to store data state. We don't really
want to store properties like `isVisible` or `selected` in the data model because
these details only exist for the UI and not something our data model cares about.

We can create a view model by passing our data and an object of ui properties
to the ViewModel class. This will wrap the base model so changes in the original
non-wrapped model will be in sync with the corresponding view model.

**Note** that you must pass the view properties that you wish to include within a
`default` property object so `thViewModel` knows this is the inital value.

View Model can even extend EventEmitter to allow event emitting on view property
changes! Just pass the `evented` property along with your `view` property. Whenever
your view property changes an event named `view:changed:#{viewPropertyName}` will
emit with the changed value. See below for example.

### Example:

Once set up we can now access our view properties in the view and make UI decisions
based on that state without the need to alter the attached data model.

```coffeescript
model = {id: 1, name: "a"}

uiProperties =
  selected: {default: false, evented: true}
  color: {default: "red"}

viewModel = new ViewModel(model, uiProperties)
# ==> {model: {id: 1, name: "a"}, view: {selected: false, color: "red"}

```

When selecting the item in the view you'll want to access the `view.selected`
property in the view model. See the `addItem` function to see this in action.

View:

```html
<th-checkbox
  ng-model="viewModel.view.selected"
  label="viewModel.model.name"
  ng-class="[
    {green: viewModel.view.color == 'green'},
    {red: viewModel.view.color == 'red'}
  ]"
  >
</th-checkbox>
```
Controller:

```coffeescript
# Because the 'selected' value is 'evented' the changed will trigger an emit.
changeColor = (viewModel, selected) ->
  viewModel.view.color = if selected then "green" else "red"

viewModel.on "view:changed:selected", (selected) ->
  changeColor(this, selected)
```
