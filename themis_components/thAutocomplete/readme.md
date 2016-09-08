# Autocomplete - `thAutoComplete`

Autocomplete is used to suggest options to the user based on keyboard input.

## Design Patterns

Autocomplete looks similar to a text input in its default state. When the user begins typing, autocomplete suggests a list of options to the user that matches what they've entered so far. The list is updated based on continued user input.

Users can navigate and select an option from the list using keyboard or mouse.

Users are unable to enter an incomplete selection. That is, users are unable to enter arbitrary text, see [thInput](../thInput).

Autocomplete can be used to retrieve a list of options remotely through an api.

Autocomplete should be used when the list of options can be intuited by the user (ie. contacts). Otherwise, see [thSelect](../thSelect).

## Usage

The `th-autocomplete` accepts the following parameters:

* `ng-model` (*optional*) is updated to `value` when the user selects an option from the component.

* `ng-change` (*optional*) is called whenever `value` is updated.

* `placeholder` (*optional*) is the default text that is displayed prior to the user selecting an option.

* `name` (*optional*) is the name used when submitting `thAutocomplete` as part of a form.

* `icon` (*optional*) is the name of any
  [Font Awesome](https://fortawesome.github.io/Font-Awesome/icons/ "icons!")
  font. Eg. `icon="dollar"` for `fa-dollar`

* `condensed` (*optional*) applies condensed styling to the component.

* `multiple` (*optional*) enables multiple-selection, allowing the user to select more than
one value. Styling is condensed by default.

* `delegate` (**required**) represents a dictionary of arguments passed to the component.

  * `fetchData({searchString}, updateData)` (**required**)

    * represents a callback that accepts a search term reflecting the user's current input and a callback that is used to update the list of options that match the user's current input

      * `searchString` is the string used to compare against for matches.

      * `updateData(data)` is a function that accepts an array of matches. Once your query returns, call `updateData` with parameter `data` where `data` is an object of type `Array` and each element contains the fields referenced by `displayField` and `trackField` (defaults to `name` and `id` respectively, see below)

  * `displayField` (*optional*)

    * the item field to display (defaults to `name`)

  * `trackField` (*optional*)

    * defines the unique key to use for indexing list items internally

### Markup

```html
<th-autocomplete
  ng-model="demo.value"
  ng-change="demo.onChange"
  delegate="demo.delegate"
  placeholder="Select an option"
  >
</th-autocomplete>
```

```
delegate =
  displayField: 'name'
  trackField: 'id'
  fetchData: ({searchString}, updateData) ->
    if searchString?.length
      $http
        method: 'GET'
        url: 'https://api.github.com/search/repositories'
        params:
          q: searchString
      .then (response) ->
        updateData(response.data.items)
```

### Notes

The array that is passed to `updateData` represents the list of options that match the user's current input.
