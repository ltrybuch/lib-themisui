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
    onApply: ({trackedCollection, allSelected, selectedAction}, reset) ->
      # Processing our selected data
      # reset() on completed changes

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
  >
  <span>Content that will be included</span>
</th-table-action-bar>
```

## Attributes
- `thTableActionBar` accepts a couple of attributes.

**[delegate="object"]**
- A required object that manages the state of the action bar.

- The `delegate` accepts an object of options as an argument:
  - `onApply: ({trackedCollection, allSelected, selectedAction}, triggerReset) ->`

    - This is a **mandatory** field

    - `onApply` is a callback that you can call with 3 optional parameters:

      - `trackedCollection`: This collection is context aware.

      - `allSelected`: A `boolean` flag indicating the selected state of the
      entire collection. See below for details.

        - When `allSelected` is `true`: `trackedCollection` will start off empty
        and include **all the unselected items** as they are unselected.

        - When `allSelected` is `false`: This collection contains **all
        selected items** as they are selected.

        - Use the value of `allSelected` to determine which collections you are
        receiving to act on them correctly. `true` means a **negative** collection
        and `false` means a **positive** collection.

      - `selectedAction` is a string indicating the chosen action.

    - `triggerReset` is a callback function to let the action bar know that it should
    no longer be in a loading state. This will also clear the internal collection
    and reset all checked list items.

  - `availableActions`:
    - This is a **mandatory** field

    - An array of objects used to populate the select dropdown.

  - `pageSize`:
    - Number, tells the actionbar the maximum number of rows are on the page.

    - This is a **mandatory** field

    - `pageSize` lets the delegate know how many items are visible at one time.

  - `trackBy`:
    - This is the property that `thTableActionBar` will use internally to track
    the selected items. Most commonly it would be "id" as these are normally unique
    numbers that are easily compared.

    - Defaults to `id` if no value is given.

**[item-name="string"]**
- Optional, default value: item.

- This is referenced in the action bar view when items are selected.

## Usage

In order to make items in the view selectable several method are exposed once
the `ActionBarDelegate` has been initialized:
  - `makeSelectable({data: data, totalItems: 10, currentPage: 1, resetSelection: false})`

    - It expects an object as an argument:
      - `data`: The page array that you wish to make selectable. The length
      should be **equal to or less than** the page size. The

      - `totalItems`: All possible items that can be selected.

      - `currentPage`: The table page currently visible.

      - `resetSelection`: Used to reset the internal selected collection. Useful, for example,
      when combined with filter functionality (see [thFilter](.\thFilter)) to reset
      selected items with filtered data. Defaults to false.

    - `makeSelectable` will return a new array of view models
    (see [thViewModel](.\thViewModel)) that we can now use in our view to toggle
    their selectable state. This array can then be passed along to your table
    implementation.

    - To access the original data model you must use the `model` property name.
    - When selecting the item in the view you'll want to access the `view.selected`
    property in the view model. See the `toggleSelected` function below for more
    on the view object.

    - Example:

      Original collection:
        ```coffeeScript
        [{id: 1, name: "a"}, {id: 2, name: "b"}]
        ```
      Return collection:
        ```coffeeScript
        [
          {model: {id: 1, name: "a"}, view: {selected: false}}
          {model: {id: 2, name: "b"}, view: {selected: false}}
        ]
        ```

    - Everytime the table data is updated use `makeSelectable` to tell the action
    bar about those changes.

  - `toggleSelected(viewModel)`
    - Used to pass a selected item into the `ActionBarDelegate`s internal selected
    collection.

    - Whenever a row in your table is selected call `toggleSelected` with that
    item to update the selected collection similar to the example below.

    - Attach `item.view.selected` to `ng-model` on the element that will be toggling
    the selected item. This way our ActionBarDelegate can update the select view state
    programmically.

    - This exposed method allows for flexibility in how the items are selected by
    allowing any HTML element or component to be used just so long as the model is
    set to `item.view.selected` and `toggleSelected` is triggered on click.

    - Example:

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
