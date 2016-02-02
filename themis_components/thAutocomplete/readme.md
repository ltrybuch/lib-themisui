# Autocomplete - `thAutoComplete`

Autocomplete is used to suggest options to the user based on keyboard input.

## Design Patterns

Autocomplete looks similar to a text input in its default state. When the user begins typing, autocomplete suggests a list of options to the user that matches what they've entered so far. The list is updated based on continued user input.

Users can navigate and select an option from the list using keyboard or mouse. 

Users are unable to enter an incomplete selection. That is, users are unable to enter arbitrary text, see [thInput](.\thInput).

Autocomplete can be used to retrieve a list of options remotely through an api.

Autocomplete should be used when the list of options can be intuited by the user (ie. contacts). Otherwise, see [thSelect](.\thSelect).

## Usage

The `th-autocomplete` accepts the following parameters:

* `ng-model` is updated to `value` when the user selects an option from the component.
* `delegate` is a **required** field that represents a dictionary of arguments passed to the component.
  * `fetchData` (**required**)
    * represents a callback that accepts a search term reflecting the user's current input and a callback that is used to update the list of options that match the user's current input
* `placeholder` is the default text that is displayed prior to the user selecting an option.

### Markup

```html
<th-autocomplete
  ng-model="demo.value"
  delegate="demo.delegate"
  placeholder="Select an option"
  >
</th-autocomplete>
```

```
delegate =
  fetchData: (searchString, updateData) ->
    if searchString?.length
      $http
        method: 'GET'
        url: 'https://api.github.com/search/repositories'
        params:
          q: searchString
      .then (response) ->
        repos = response.data.items.map (item) ->
          Object.assign(item, {
            # Required parameters
            text: item.name
            id: item.id
          })
        updateData(repos)
```

### Notes

The array that is passed to `updateData` represents the list of options that match the user's current input. The following are **required** fields:

* `id`- unique identifier used by the component
* `text`- display string used by the component 

