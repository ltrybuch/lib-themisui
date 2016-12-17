# `thActionBar`
The action bar component is used to interact with a collections of items.
This component is meant primarily to be used with a table (see [thTable](.\thTable)).

It consists of a delegate object that is used to set up the desired behavior
and an HTML view used for interacting with the collection.

Any content inside of `th-action-bar` will be included but will be **justified
on the right side** of action bar. Use this space to set up neccessary buttons or
actions such as a link to a filter dropdown. See examples below.

Often this transcluded area of the action bar is used as a [disclosure toggle](.\thDisclosure)
for a filter dropdown so using the `filter-toggle` class on this element will add
a Themis themed styling to the link. Check out example 2 to see this in action.

When interacting with the action bar using the "Apply" button the action bar will
set itself to a loading state and becomes disabled until the implementer (you!) tell
it to remove this state. This ensure no more than one actions can be taken at a time
on your collection.

## Example
```coffeescript
@actionBarDelegate = new ActionBarDelegate
  onApply: ({trackedCollection, selectedAction}, triggerReset) ->
    # Processing our selected data
    # triggerReset() to resset the actionbar and tracked collection
  availableActions: [
    {name: "Print", value: "print"}
    {name: "Download Archive", value: "download"}
  ]
  retrieveIds: (viewModel) ->
    # fetch ids when selecting all or selecting a sub collection.
  collectionReferences: ["contacts"]
```

```html
<th-action-bar
  delegate="demo.actionBarDelegate"
  item-name="contact"
  button-name="Update"
  >
  <span>Content that will be included</span>
</th-action-bar>
```

## Attributes

### delegate="object"

Required object that manages the state of the action bar.
The `delegate` accepts an object of options as an argument:
  * `onApply: ({trackedCollection, selectedAction}, triggerReset) ->`
    * This is a **mandatory** field that you must pass into the delegate.
    * The function is the only way to interact with the selected collection.
    * When triggered by clicking on the action bar's buttton it:
      * Move the action bar into a loading state. This means that all interactable elements will be
        disabled and the button will display a processing spinner.
      * Will supply 2 arguments. These arguments are listed below:
        *  An object with the keys listed below:
          * `trackedCollection`: A dictionary of selected values.
          * `selectedAction` is a string indicating the action chosen from the
            dropdown menu if the optional menu persists.
        * `triggerReset`: A callback function that, when executed, removes the loading state from
          the action bar and clears the internal collection which in tern will reset all selected
          list items.
  * `objectCollectionReferences`:
    * This is a **mandatory** field that you must pass into the delegate.
    * An array of reference that should match the collection properties to be used.
    For example if you have a list of contacts then `["contacts"]` would work.
    * If your collection also has a *nested* collection then both references would
    be needed. For example: `["books", "chapters"]`. This would mean that each "book" is
    expected to have a property "chapters".
    * This is only used internally to tracked incoming parent / children data relationships.
    example structure for clarity:
    ```coffeescript
    books = [
        {
          title: "ng-book"
          author: "Ari Lerner"
          chapters: [
            number: 1, title: "Forewords"
            number: 2, title: "Acknowledgments"
          ]
        },
        {# next book…}
    ]
    ```
  * `retrieveIds: (viewModel) ->`
    * This is a **mandatory** field that you must pass into the delegate.
    * Because we probably want to limit the amount of items in our collection (ie. first page)
    we need a way of retrieving all our identifiers a view model's selected value is changed.
    regardless of how many are visible.
    This also applies to our nested collections. `retrieveIds` is used to do this. Everytime either
    the entire collection is selected or a parent with children is selected the `retrieveIds`
    function is triggered. It expected a promise that will resolve to an object of all ids which
    can used internally to tracked the remaining items not visible on the page. This allows us to
    correctly return all **selected** ids when the `onApply` function is triggered. The `retrieveIds`
    function returns a argument of a view model which you can use to return the correct ids.
      * If the view model's id is equal to `"root"` then we know that this is the top level collection
      and **all** ids are required. In other words the "Select All" checkbox has been checked.
      * If the view model's id is NOT `root` but a number id then we know that this is a parent that
      has been selected and we need all its children ids.
      Example:
      ```coffeescript
      retrieveIds: (viewModel) ->
        if viewModel.model.id is "root"
          # Let's get 'em all
          serviceWhichReturnsAPromiseWithAllIds()
          # ==> {1: [1, 3, 4], 2: [3, 4, 5], 3: [7, 8, 9]})
        else
          # A parent selected. We only need the children ids.
          parentId = viewModel.model.id
          serviceWhichReturnsAPromiseWithChildrendIds(parentId)
          # ==> {3: [7, 8, 9]}
      ```
  * `availableActions`:
    * This is a **optional** field
    * An array of objects used to populate the select dropdown. Without this
    property the select dropdown will not included with the action bar.
  * `trackBy`:
    * This is a **optional** field, default value `id`.
    * This is the property that `thActionBar` will use internally to track
    the selected items. Most commonly it would be "id" as these are normally unique
    numbers that are easily compared.

### item-name="string"

* **Optional**, default value: "item".
* This is referenced in the action bar view when items are selected.
* Use this to customize your view so instead of the action bar showing
`1 item selected` it will display `1 person selected`.
* This will automatically be pluralized for you when needed.

### button-name="string"

* **Optional**, default value: "Apply"
* This does exactly what it describes. Use this attribute to customize the text
of your button.

## Usage

In order to make items in the view selectable several method are exposed once
the `ActionBarDelegate` has been initialized:
  * `makeSelectable(apiData)`
    * Use this function to update the action bar everytime there is a change to your table / list.
    * It expects an object as an argument something similar to what a typical API would return.
    * `makeSelectable` will return a new array of view models
    (see [thViewModel](.\thViewModel)) that we can now use in our view to toggle
    their selectable state. This array can then be passed along to your table / list
    implementation.
    Along with the selected state each view model's view object will also come with a indeterminate
    state. This is useful when working with nested collections as we might want to show a "mixed"
    view for a parent view model with partially selected children. More on this below.

    * Note:
      * To access the original data model you must use the `model` property name.
      * When selecting the item in the view you'll want to access the `view.selected`
      property in the view model.

    The object should be structured as follows:
    ```coffeescript
    apiData = {
      # Data to be tracked. Likely the first page of a table.
      collection: [
        {id: 1, name: "Connor"}
        {id: 2, name: "Leon"}
        {id: 3, name: "Jordan"}
      ]
      meta: {
        # Total items available.
        totalItems: 23
      }
    }
    shinyNewSelectableData = actionBarDelegate.makeSelectable(apiData)
    # returns ==>
    [
      {model: {id: 1, name: "Connor"}, view: {selected: false, indeterminate: false}}
      {model: {id: 2, name: "Leon"}, view: {selected: false, indeterminate: false}}
      {model: {id: 3, name: "Jordan"}, view: {selected: false, indeterminate: false}}
    ]
    ```
    You can then used your returned collection in your view:
    ```html
    <ul ng-repeat="player in players">
      <li>
        <th-checkbox ng-model="player.view.selected"></th-checkbox>
        <span>{{player.model.id}} | {{player.model.name}}</span>
      </li>
    </ul>
    ```
    * The View models that are returned from `makeSelectable` will trigger an event when
      their `selected` property changes. This event will then be automatically tracked for you by
      your `SelectableCollection` instance. See examples below for clarity.

## Usage with Nested Collection

It is possible to work with nested collections of data (1 parent has many children). The child
collection must also be structured in the same way as the parent using the `collection` and `meta`
properties in the object.
Example:
```coffeescript
nestedApiData = {
  collection: [
    {
      id: 1
      name: "Homer"
      children: {
        collection: [
          {id: "1", name: "Bart"}
          {id: "2", name: "Lisa"}
        ]
        meta: {
        # Total children
          totalItems: 3
      }
    }
  meta: {
    # Total parents
    totalItems: 2
  }
}

```
To add to the nested collection we first need to access the children through the parent. We do
this buy targeting the parent's model property. The children collection instance expose a
`addToSelectableCollection` function which accepts a collection of data structured as follows:
```coffeescript
  children = viewModel.model.children
  moreChildren = [
    {id: 1, name: "Maggie"}
    {id: 2, name: "Santa's little helper"}
    {id: 3, name: "Snowball"}
  ]
  children.addToSelectableCollection(moreChildren)

```
When working with a *nested collection* you can take advantage of the indeterminate state attached
to each view model. If a view model has *children view models* and those children are partially
selected, it would be nice to be able to show that.

You can do that by taking advantage of [`thCheckbox`](.\thCheckbox)! Just add the indeterminate state
from the view objet to your checkbox as an attribute and when your children are partially selected it
will automagically set this state for you.
```html
<ul ng-repeat="member in family">
  <li>
    <th-checkbox
      ng-model="member.view.selected"
      indeterminate="member.view.indeterminate"
      >
    </th-checkbox>
    <span>{{member.model.id}} | {{member.model.name}}</span>
  </li>
</ul>
```
See example 3 for a working example of using `thActionBar` with a nested collection.
