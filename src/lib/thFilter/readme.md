# Filter

The filter component is used to filter a set of data by applying operators to
the fields of a dataset. It consists of the set of models used to generate a
filter query and the set of views used for interacting with these models.

## Design Patterns

The filter component is used for filtering presentation data, most commonly
found in a table (see [thTable](.\thTable)).

The filter view is comprised of a set of filter fields. The filter view supports
a number of filter field types including text, number, autocomplete, etc.

A wrapper directive `th-filter` is provided for consistent styling across filter
views.

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
<th-filter options="demo.filterOptions">
  <th-static-filters></th-static-filters>
  <th-custom-filters></th-custom-filters>
  <th-search-row></th-search-row>
</th-filter>
```

## Usage

The directives operate on a `FilterSet` object. They manage
adding and removing filters to and from the `FilterSet` over the lifetime of the
directive. You can query the `FilterSet` at any point to get the status of the
the entire `FilterSet` or individual filters.

### FilterSet

All directives accept and modify a `FilterSet` object. The `FilterSet` accepts
as arguments a hash containing the following options:

* `onFilterChange` (*required*) gets called when the filter set changes.

* `onInitialized` (*optional*) gets called when the filter is finished
initializing.

`FilterSet` extends `Array` type with the following properties:

* getState()

  * Returns a hash representing the filter state, where hash key is the
  field identifier and value is an object representing the state of the field.

* getMetadata()

  * Returns a hash representing the filter metadata, where hash key is the field
  identifier and value is the metadata passed in as part of the filter options.

### Filter options

The directives accept an array of filter options that define the filters in each
component.

All filter types require the following options:

* `type` specifies the type of filter. Supported types include:

  * `select`
  * `input`
  * `number`
  * `currency`
  * `checkbox`
  * `url`
  * `email`
  * `autocomplete`
  * `date`

* `name` is the string representation indicating the filter type to the user.

* `fieldIdentifier` indicates the name of the field in your data that the filter
is acting on.

Optional fields:

* `metadata` (*optional*) specifies additional data that will be returned from
`getMetadata()`.

#### Select filter options

```json
{
  "type": "select",
  "name": "Sample Select",
  "fieldIdentifier": "sampleFieldId",

  "placeholder": "Placeholder string",

  "selectOptions": [
    {"name": "Option one", "value": "1"},
    {"name": "Option two", "value": "2"}
  ],

  "selectOptionsUrl": "./sampleoptions.json",
  "selectOptionsNameField": "altname",
  "selectOptionsValueField": "altvalue"
}
```
The select filter type takes the following options:

* `placeholder` (*optional*) defines the placeholder string of the element in its default
state.

The select filter *requires* one of the following attributes:

* `selectOptions` defines the array of possible options available to the user.

  * Options consist of name-value pairs.

* `selectOptionsUrl` indicates the url returning the array of options
available to the user.

  * `selectOptionsNameField` (*optional*) indicates the name-field to use in
  the returned JSON. Defaults to "name".

  * `selectOptionsValueField` (*optional*) indicates the value-field to use
  in the returned JSON. Defaults to "value".

  * `selectOptionsCallback` (*optional*) is the function to call with the
  response from `selectOptionsUrl` as a parameter. `selectOptionsCallback`
  should return the array of options to use, with each option specifying a
  `name` and `value` attribute.

#### Input filter options

```json
{
  "type": "input",
  "name": "Sample Input",
  "fieldIdentifier": "sampleFieldId",

  "placeholder": "Placeholder string"
}
```

* `placeholder` (*optional*) defines the placeholder string of the element in its default
state.

#### Autocomplete filter options

```json
{
  "type": "autocomplete",
  "name": "Sample Input",
  "fieldIdentifier": "sampleFieldId",

  "placeholder": "Placeholder string",

  "autocompleteOptions": {
    "modelClass": "Contact",
    "trackField": "id",
    "displayField": "name",
    "queryField": "query",
    "queryParams": {
      "sampleQueryParam": "test data"
    }
  }
}
```

* `placeholder` (*optional*) defines the placeholder string of the element in its default
state.

* `autocompleteOptions` (*required*)

  * `modelClass` (*required*) indicates the class name of the service that will
  provide query functionality. The autocomplete field will instantiate a
  `modelClass` instance and call `query` for each request, passing the
  search term and any additional parameters supplied in `queryParams`.

  * `trackField` (*optional*) indicates the unique key to use for each item
  returned from `ModelClass.query`, for indexing autocomplete options. Defaults
  to `id`.

  * `displayField` (*optional*) indicates the field to display to the user, for
  each item returned from `ModelClass.query`. Defaults to `name`.

  * `queryField` (*optional*) indicates the field to query. Defaults to `query`.

  * `queryParams` (*optional*) indicates any additional parameters to pass to
  `ModelClass.query`.

## Directives

### `th-filter`

The `th-filter` element is used to wrap the following filter views. It provides consistent
styling across views and accepts an `options` attribute as an object containing the following properties:

* `filterSet` (*required*) is the `FilterSet` instance that the enclosed components will
modify.

* `initialState` (*optional*) is a hash of key/value pairs where key is the
`fieldIdentifier` of the field you wish to initialize and value is a hash
representing the initial state of the field.

The following property is supported when the `th-static-filters` component is included as a child element of `th-filter`:

* `staticFilters` (*required*) is an array of filter options hashes.

The following properties are supported when the `th-custom-filters` component is included as a child element of `th-filter`:

* `customFilterTypes` (*required*) is the array of filter options.

* `customFilterUrl` (*required*) indicates a url that returns the array of filter options.

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

The following property is supported when the `th-search-row` component is included as a child element of `th-filter`:

* `fieldIdentifier` (*optional*) is the name of the field the search row will
query. Defaults to "query".

### `th-static-filters`

The `th-static-filters` element is a container for a block of filters that are
always visible to the user.

### `th-custom-filters`

The `th-custom-filters` element is a container for allowing users to add custom filters
to the set.

### `th-search-row`

The `th-search-row` element defines the search row pattern consisting of an
input field and "Search" button.
