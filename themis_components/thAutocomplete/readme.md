# Autocomplete - `thAutoComplete`

Autocomplete is used to suggest options to the user based on keyboard input.

## Design Patterns

Autocomplete looks similar to a text input in its default state. When the user begins typing, autocomplete suggests a list of options to the user that matches what they've entered so far. The list is updated based on continued user input.

Users can navigate and select an option from the list using keyboard or mouse. 

Users are unable to enter an incomplete selection. That is, users are unable to enter arbitrary text, see [thInput](.\thInput).

Autocomplete can be used to retrieve a list of options remotely through an api.

Autocomplete should be used when the list of options can be intuited by the user (ie. contacts). Otherwise, see [thSelect](.\thSelect).

## Usage

The `th-autocomplete` element wraps the input and delimits any default options.

Options can be specified in one of two ways or a combination of both.

* Static options can be specified through either:
  * an `option` tag with optional `selected` attribute, see [option tag](http://www.w3schools.com/tags/tag_option.asp)
  * angular directive `ng-options`, see [ngOptions](https://docs.angularjs.org/api/ng/directive/ngOptions)


* Dynamic options specified from a remote source
  
  In this case, options can be retrieved through an api or other source. You must provide a `fetchData` callback to the directive that accepts a query parameter and returns a sorted array of key-value pairs that match the term.

### Markup

```
<th-autocomplete ng-model="colour">
  <option value="0" selected>red</option>
  <option value="1">blue</option>
  <option value="2">green</option>
</th-autocomplete>
```

```
<th-autocomplete ng-model="colour" ng-options="colour.text for colour in colours">
</th-autocomplete>
```

```
<th-autocomplete ng-model="colour" options(init? params?)="parentController.options">
</th-autocomplete>
```

```
options = {
  fetchData: ({term}, updateData) ->
    data = getData(term) // optional api request

    updateData(data)
}
```

The following optional parameters can be included in the `options` dictionary:

## (Very tentative)

`delay`- delay in ms between successive requests to `fetchData`

## Notes


