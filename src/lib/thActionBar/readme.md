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
  onApply: ({ids, selectedAction}, reset) ->
    # Processing our selected data
    # reset() to reset the actionbar and internally tracked collection
  availableActions: [
    {name: "Print", value: "print"}
    {name: "Download Archive", value: "download"}
  ]
```

```html
<th-action-bar delegate="demo.actionBarDelegate">
  <span>Content that will be included</span>
</th-action-bar>
```

## Attributes

### delegate="object"

Required object that manages the state of the action bar.
The `delegate` accepts an object of options as an argument:
  * `buttonName`: **Optional** property. This does exactly what it describes. Use this attribute
    to customize the text of your button. Defaults to "APPLY".
  * `onApply: ({ids, selectedAction}, reset) ->`
    * This is a **mandatory** property that you must pass into the delegate.
    * The function is the only way to interact with the selected collection.
    * When triggered by clicking on the action bar's buttton it:
      * Move the action bar into a loading state. This means that all interactable elements will be
        disabled and the button will display a processing spinner.
      * Will supply 2 arguments. These arguments are listed below:
        *  An object with the keys listed below:
          * `ids`: A collection of ids.
          * `selectedAction` is a string indicating the action chosen from the
            dropdown menu if the optional menu persists.
        * `reset`: A callback function that, when executed, removes the loading state from
          the action bar and clears the internal collection which in tern will reset all selected
          list items.
    ```
  * `availableActions`:
    * This is a **optional** field
    * An array of objects used to populate the select dropdown. Without this
    property the select dropdown will not included with the action bar.

## Usage

In order to make items in the view selectable several method are exposed once
the `ActionBarDelegate` has been initialized:
  * `makeSelectable(apiData)`
    * Use this function to update the action bar everytime there is a change to your table / list.
    * It expects an data array as an argument something similar to what a typical API would return.
    * `makeSelectable` will return a new array of view models (see [thViewModel](.\thViewModel))
      that we can now use in our view to toggle their selectable state. This array can then be passed
      along to your table / list implementation.
    * Note:
      * To access the original data model you must use the `model` property name.
      * When selecting the item in the view you'll want to access the `view.selected` property in
        the view model.
      * Whenever `makeSelectable` is called it will reset the current tracked collection. ie the
        selected values will be lost.

    The data array passed to `makeSelectable` should look something as follows:
    ```coffeescript
    apiData = [
      {id: 1, name: "Connor", position: "C"}
      {id: 2, name: "Leon", position: "C"}
      {id: 3, name: "Jordan", position: "L"}
    ]

    shinyNewSelectableData = actionBarDelegate.makeSelectable(apiData)
    # returns ==>
    [
      {model: {id: 1, name: "Connor", position: "C"}, view: {selected: false}
      {model: {id: 2, name: "Leon", position: "C"}, view: {selected: false}
      {model: {id: 3, name: "Jordan", position: "L"}, view: {selected: false}
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
