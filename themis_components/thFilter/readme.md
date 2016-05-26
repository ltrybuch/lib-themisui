# Filter - `thFilter`

The filter component is used to filter a set of data by applying operators to
the fields of a dataset. It consists of the set of models used to generate a
filter query and the set of views used for interacting with these models.

## Design Patterns

The filter component is used for filtering presentation data, most commonly
found in a table (see [thTable](.\thTable)).

The filter view is comprised of a set of filter fields. The filter view supports
'select' and 'input' type filter fields.

Three types of views exist for filter fields.

* Static filter fields are presented in a grid and are always visible to the user.
They are limited to the most frequently used operators and provide easy access
to commonly used filter fields.

* Custom filter fields allow the user to add additional filter fields to a set.
They allow for greater flexibility when specifying an operator (greater than,
between, etc.), but are hidden until the user adds the custom field to the
filter set.

* The search row consists of a query field and corresponding 'Search' button.

## Example

```coffeescript
@filterOptions = [
  name: 'Tier'
  type: 'select'

  fieldIdentifier: 'tier'
  placeholder: 'Select an option'
  selectOptions: [
    {name: 'One', value: 'one'}
    {name: 'Two', value: 'two'}
    {name: 'Three', value: 'three'}
  ]
]

@filterSet = new FilterSet
  onFilterChange: =>
    @tableDelegate.reload {currentPage: 1}

@filterOptions = {
  filterSet: @filterSet
  staticFilters: @filterOptions
  customFilters: @filterOptions
}
```

```html
<th-static-filters options="demo.filterOptions"></th-static-filters>
<th-custom-filters options="demo.filterOptions"></th-custom-filters>
<th-search-row options="demo.filterOptions"></th-search-row>
```

## Usage

The directives operate on a `FilterSet` object. They manage
adding and removing filters to and from the `FilterSet` over the lifetime of the
directive. You can query the `FilterSet` at any point to get the status of the
the entire `FilterSet` or individual filters.

### FilterSet

All directives accept and modify a `FilterSet` object. The `FilterSet` accepts
as arguments a hash containing the following option:

* `onFilterChange` (*required*) is the function that gets called when the filter
set changes.

`FilterSet` extends `Array` type with the following properties:

* getQueryParameters()

  * Returns a hash representing the query parameters, where hash key is the
  filter field.

### Filter options

The directives accept an array of filter options that define the filters in each
component.

All filter types require the following options:

* `type` specifies the type of filter. Supported types include:

  * `select`
  * `input`

* `name` is the string representation indicating the filter type to the user.

* `fieldIdentifier` indicates the name of the field in your data that the filter
is acting on.

#### Select filter options

```json
{
  type: "select"
  name: "Sample Select"
  fieldIdentifier: "sampleFieldId"

  placeholder: "Placeholder string"

  select-options: [
    {name: "Option one", value: 1}
    {name: "Option two", value: 2}
  ]

  select-options-url: "./sampleoptions.json"
  select-options-name-field: "altname"
  select-options-value-field: "altvalue"
}
```
The select filter type takes the following options:

* `placeholder` defines the placeholder string of the element in its default
state.

The select filter *requires* one of the following attributes:

* `select-options` defines the array of possible options available to the user.

  * Options consist of name-value pairs.

* `select-options-url` indicates the url returning the array of options
available to the user.

  * `select-options-name-field` (*optional*) indicates the name-field to use in
  the returned JSON. Defaults to "name".

  * `select-options-value-field` (*optional*) indicates the value-field to use
  in the returned JSON. Defaults to "value".

#### Input filter options

```json
{
  type: "input"
  name: "Sample Input"
  fieldIdentifier: "sampleFieldId"

  placeholder: "Placeholder string"
}
```

* `placeholder` defines the placeholder string of the element in its default
state.

## Directives

### `th-static-filters`

The `th-static-filters` element is a container for a block of filters that are
always visible to the user. It accepts an `options` attribute which is a hash
consisting of the following options:

* `filterSet` is the `FilterSet` instance that the component will modify.

* `staticFilters` is an array of filter options hashes.

### `th-custom-filters`

The `th-custom-filters` element accepts an `options` attribute which is a hash
consisting of the following options:

* `filterSet` is the `FilterSet` instance that the component will modify.

`th-custom-filters` *requires* one of the following two options:

* `customFilterTypes` is the array of filter options.

* `customFilterUrl` indicates a url that returns the array of filter options.

  * `customFilterConverter` (*optional*) is an object that subclasses
    `CustomFilterConverter`. `customFilterConverter.mapToCustomFilterArray` is
    called with the data returned from `customFilterUrl` and returns an array
    containing the custom filter objects. A general `customFilterConverter` will
    be created in Themis that handles conversion of all custom filter api calls.

    ```json
    class MyCustomFilterConverter extends CustomFilterConverter
      mapToCustomFilterArray: (data) ->
        data.map (item) ->
          fieldIdentifier: item.id
          name: item.name
          type: ( ->
            switch item.field_type
              when "picklist"
                "select"
              when "text_line"
                "input"
              else
                throw new Error "unsupported field_type"
            )()
          selectOptions: ( ->
            if item.custom_field_picklist_options?
              item.custom_field_picklist_options.map (option) ->
                name: option.option
                value: option.id
            )()
    ```

### `th-search-row`

The `th-search-row` element defines the search row pattern consisting of an
input field and "Search" button. It accepts an `options` attribute which is a
hash consisting of the following options:

* `filterSet` is the `FilterSet` instance that the component will modify.

* `fieldIdentifier` (*optional*) is the name of the field the search row will
query. Defaults to "query".
