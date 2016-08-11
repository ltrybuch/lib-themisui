# `thTableActionBar`

The action bar component is used to interact with a collections of items.
This component is meant primarily to be used with a table (see [thTable](.\thTable)).

It consists of a delegate object that is used to set up the desired behavior
and an HTML view used for interacting with the collection.

Any content inside of `th-table-action-bar` will be included but will be **justified
on the right side** of action bar. Use this space to set up neccessary buttons or
actions such as a link to a filter dropdown. See examples below.

Often this transcluded area of the action bar is used as a [disclosure toggle](.\thDisclosure)
for a filter dropdown so using the `filter-toggle` class on this element will add
a Themis themed styling to the link. Check out example 2 to see this in action.

## Example
```coffeescript
  @actionBarDelegate = new ActionBarDelegate
    onApply: ({trackedCollection, allSelected, selectedAction}, triggerReset) ->
      # Processing our selected data
      # triggerReset() on completed changes
    availableActions: [
      {name: "Print", value: "print"}
      {name: "Download Archive", value: "download"}
    ]
    pageSize: 10
```

```html
<th-table-action-bar
  delegate="demo.actionBarDelegate"
  item-name="post"
  button-name="Update"
  >
  <span>Content that will be included</span>
</th-table-action-bar>
```

## Attributes

### [delegate="object"]

Required object that manages the state of the action bar.
The `delegate` accepts an object of options as an argument:
  * `onApply: ({trackedCollection, allSelected, selectedAction}, triggerReset) ->`

    * This is a **mandatory** field that you must pass into the delegate.
    * The function is the only way to interact with the selected collection.
    * It will be called whenever the action bar's button is clicked.
    * `onApply` is a callback that you can call with 3 optional parameters:
      * `trackedCollection`: This collection is context aware.
      * `allSelected`: A `boolean` flag indicating the selected state of the
      entire collection. See below for details.
        * When `allSelected` is `true`: `trackedCollection` will start off empty
        and include **all the unselected items** as they are unselected.
        * When `allSelected` is `false`: `trackedCollection` contains **all
        selected items** as they are selected.
        * Use the value of `allSelected` to determine which collections you are
        receiving to act on it accordingly.
        * TLDR: `true` means a **negative** collection. `false` means a **positive**
        collection.
      * `selectedAction` is a string indicating the action chosen from the
      dropdown menu if the optional menu persists.

    * `triggerReset` is a callback function to let the action bar know that it should
    no longer be in a loading state. This will also clear the internal collection
    and reset all checked list items.
  * `pageSize`:
    * This is a **mandatory** field
    * `pageSize` lets the delegate know how many items are visible at one time.
  * `availableActions`:
    * This is a **optional** field
    * An array of objects used to populate the select dropdown. Without this
    property the select dropdown will not included in the action bar.
  * `trackBy`:
    * This is a **optional** field, default value `id`.
    * This is the property that `thTableActionBar` will use internally to track
    the selected items. Most commonly it would be "id" as these are normally unique
    numbers that are easily compared.

### [item-name="string"]

* Optional, default value: "item".
* This is referenced in the action bar view when items are selected.
* Use this to customize your view so instead of the action bar showing
`1 item selected` it will display `1 person selected`.
* This will automatically be pluralized for you when needed.

### [button-name="string"]

* Optional, default value: "Apply"
* This does exactly what it describes. Use this attribute to customize the text
of your button.

## Usage

In order to make items in the view selectable several method are exposed once
the `ActionBarDelegate` has been initialized:
  * `makeSelectable({data: data, totalItems: 10, currentPage: 1, resetSelection: false})`
    * Use this function to update the action bar everytime there is a change to
    your table.
    * `makeSelectable` will return a new array of view models
    (see [thViewModel](.\thViewModel)) that we can now use in our view to toggle
    their selectable state. This array can then be passed along to your table
    implementation.
    * It expects an object as an argument with properties:
      * `data`: The page array that you wish to make selectable. The length
      should be **equal to or less than** the page size. The
      * `totalItems`: All possible items that can be selected.
      * `currentPage`: The table page currently visible.
      * `resetSelection`: (*optional*) Used to reset the internal selected collection.
      Useful, for example, when combined with filter functionality
      (see [thFilter](.\thFilter)) to reset selected items with filtered data.
      Defaults to `false`.
    * Note:
      * To access the original data model you must use the `model` property name.
      * When selecting the item in the view you'll want to access the `view.selected`
      property in the view model. See the `toggleSelected` function below for more
      on the view object.
    * Example:

      Original collection:
        ```coffeeScript
        [{id: 1, name: "a"}, {id: 2, name: "b"}]
        ```
      Returned collection:
        ```coffeeScript
        [
          {model: {id: 1, name: "a"}, view: {selected: false}}
          {model: {id: 2, name: "b"}, view: {selected: false}}
        ]
        ```

  * `toggleSelected(viewModel)`
    * Used to pass a selected item into the `ActionBarDelegate`s internal selected
    collection.
    * Whenever a row in your table is selected call `toggleSelected` with that
    item to update the selected collection similar to the example below.
    * Attach `item.view.selected` to `ng-model` on the element that will be toggling
    the selected item. This way our ActionBarDelegate can update the select view state
    programmically.
    * This exposed method allows for flexibility in how the items are selected by
    allowing any HTML element or component to be used just so long as the model is
    set to `item.view.selected` and `toggleSelected` is triggered on click.
    * Example:

      View:
      ```html
      <th-table-cell class="action-column">
        <th-checkbox
          ng-model="item.view.selected"
          ng-change="demo.toggleSelected(item)"
          >
        </th-checkbox>
      </th-table-cell>
      ```
      Controller:
      ```coffeescript
      @toggleSelected = (viewModel) ->
        actionBarDelegate.toggleSelected(viewModel)
      ```
