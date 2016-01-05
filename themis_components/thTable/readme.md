# DataTable — `thTable`

## Description

This is a set of components and services that you can use to implement
datatables in Clio.

The objective here is to provide an API that's much simpler and more flexible
than the current Rails implementation.

Components:
* [`th-table`](#thtable)
* [`th-table-row`](#thtablerow)
* [`th-table-cell`](#cells)

Services:
* [SimpleTableDelegate](#simpletabledelegate)
* [TableHeader](#tableheader)
* [TableSort](#tablesort)



## Example

Before digging into the details, here's a quick example of implementing a table
to keep in mind and go back to while reading the rest of this document.

```html
<th-table delegate="controller.tableDelegate">
  <th-table-row type="cells">
    <th-table-cell>
      {{item.firstName}}
    </th-table-cell>

    <th-table-cell>
      {{item.lastName}}
    </th-table-cell>
  </th-table-row>
</th-table>
```

```coffeescript
controller: (SimpleTableDelegate, TableHeader, TableSort) ->
  data = [
    {firstName: "John", lastName: "Brown"}
    {firstName: "Alice", lastName: "Wonderland"}
  ]

  @tableDelegate = SimpleTableDelegate
    headers: [
      TableHeader
        name: 'First Name'
        sortField: 'firstName'
        sortActive: true

      TableHeader
        name: 'Last Name'
        sortField: 'lastName'
    ]

    fetchData: ({sortHeader}, updateData) ->
      sortedData = TableSort.sort data, sortHeader
      updateData {data: sortedData, totalItems: sortedData.length}

  return
```

The components and services used in this example are explained in detail below.



## thTable

`th-table` receives a single attribute, the `delegate`, which is an object that
manages the entire state of the table:
* data
* headers
* pagination
* sorting
* loading and error states

The delegate actually does more than this - it's responsible for generating the
entire table template, but you don't need to worry about this.

Inside `th-table` you don't actually define the contents of the table. You must
only define the row types that you want your table to display. These are then
used and displayed in the table for each data object that's managed by the
delegate.

```html
<th-table delegate="parentController.tableDelegate">
  <th-table-row type="..."> ... </th-table-row>
  ...
  <th-table-row type="..."> ... </th-table-row>
</th-table>
```



## thTableRow

A row can be defined by adding a `th-table-row` component inside `th-table`.

It accepts 2 attributes:
* `type`, which is needed to differentiate between multiple row types.
* `object-reference` (optional, default value: `item`), which defines the symbol
  that you can use to reference each data object inside the template for row.

Do not add any attributes or styling to `th-table-row`, as it's only used to
define row types - this element will not be actually included in the final
rendered table.

The following types are currently supported:

### cells

```html
<th-table-row type="cells">
  <th-table-cell>
    {{item.name}}
  </th-table-cell>

  <th-table-cell>
    {{item.email}}
  </th-table-cell>
</th-table-row>
```

This allows the developer to define each cell for a table row. This is the only
row type that is **mandatory** - you cannot have tables without cells.

Do not add any attributes or styling to `th-table-cell`, as it's only used to
define cells.

The internal contents are transcluded in the final rendered table and they have
access to `th-table`'s parent scope.

### actions

```html
<th-table-row type="actions" object-reference="person" start-column="2">
  <a href ng-click="showEditModal(person)">Edit</a>
</th-table-row>
```

This allows the developer to define an additional actions row for each data
object, which will be rendered just below the cells row.

The actions start by default in the first column, but this can be customized by
defining an optional attribute `start-column`, as you can see above.

The internal contents are transcluded in the final rendered table and they have
access to `th-table`'s parent scope.

Please note that the value of `object-reference` for the actions row must be
identical to that of the cells row.

### no-data

```html
<th-table-row type="no-data">
  Can't find any data - what now?
</th-table-row>
```

This allows the developer to customize the message that's displayed when the
table has no data to display.

If not defined, it shows by default the following message: `No Results`.



## SimpleTableDelegate

This is a service that you can use to create table delegates to pass on to
`th-table`.

```coffeescript
tableDelegate = SimpleTableDelegate({fetchData, headers, pageSize, currentPage})
```

It accepts a dictionary of options as an argument:

* `fetchData: ({currentPage, pageSize, sortHeader}, updateData) ->`
  * This is the only **mandatory** field that you must pass to `SimpleTableDelegate`.
  * This function is the only way to send data to your table. You will have to
    fetch data here from an external source (it can be an API request for example)
    and call `updateData({error, data, totalItems})` to actually send the data
    to the table.
  * It is called once by the delegate when `th-table` initializes.
  * It will also be called whenever the user changes pages or sorts the table.
  * It can also be triggered programmatically by calling `triggerFetchData()` on
    the delegate instance. This method is described below.
  * `currentPage`, `pageSize` and `sortHeader` are all optional and will be sent
    only if they are relevant (for example if the table even has pagination or
    sorting in place)
  * `updateData` is a callback that you can call with 3 optional parameters:
    * `error` if there was an error while retrieving the data
    * `data` which is an array of data objects
    * `totalItems` which is used to compute the total number of pages

* `headers` (optional)
  * An array of TableHeader instances that define the name and sorting
    capabilities of each table header.

* `pageSize` (optional)
  * Number, tells the table how many objects to display on one page.
  * When this is set, the table will display pagination controls at the bottom.

* `currentPage` (optional, default value: 1)
  * Number, represents the current page to display when the table is initialized.

The SimpleTableDelegate instance exposes the following methods and properties
that you can use:

* `headers`
  * Reference to the TableHeader objects array that you pass to the delegate
    on creation.

* `triggerFetchData()`
  * Manually calls `fetchData()` with the current state of the table
    (pagination, sorting parameters)

* `getData()`
  * Returns an array of data that the table currently displays.

* `getError()`
  * Returns any error that was passed to `updateData` in the `fetchData` function.

* `isLoading()`
  * Returns `true`/`false` whether or not the table is currently waiting for
    data to load.

* `hasNoData()`
  * Returns `true` if the table successfully finished loading data and it
    received no data objects.

* `sortData(header)`
  * Manually sorts the table.

* `isFirstPage()`
  * Returns `true` / `false` whether or not the current page is the first one.

* `isLastPage()`
  * Returns `true` / `false` whether or not the current page is the last one.

* `goToNextPage()`
  * Manually navigate to the next page.

* `goToPrevPage()`
  * Manually navigate to the previous page.

* `goToPage(pageIndex)`
  * Manually navigate to the specified page.



## TableHeader

This service creates table header objects that you can pass to the delegate.

```coffeescript
header = TableHeader({name, sortField, sortActive, sortDirection})
```

* `name` (optional, default value: `""`) is what will be displayed as a column
  title in the table.

* `sortField` (optional) is the field in the data objects that sorting will be
  made by. Setting this field enables sorting for that specific column. It can
  have the following values:
  * `""` - this means that the entire object is the value.
  * `"regularField"` - sorting is done by `object.regularField` where object is
    one of the objects from the data array that the table displays.
  * `"deeply.nested.field"` - sorting is done by `object.deeply.nested.field`
    where object is one of the objects from the data array that the table displays.
  * any other value that has meaning to you - because this is what you will use
    in `fetchData({sortHeader}, updateData) ->` - here you will most likely
    make API requests that will contain `sortHeader.sortField`.

* `sortActive` (optional) is a boolean that can be set to `true` only on one
  header at a time. It symbolizes the fact that sorting is currently done by
  this column.

* `sortDirection` (optional, default value: `"ascending"`) can be either
  `"ascending"` or `"descending"`.

* `align` (optional, default value: `"left"`) ca be one of: `"left"`, `"right"`, or
  `"center"`.

The TableHeader objects expose the following properties and methods:

* `name`
* `sortField`
* `isSortActive()`
* `getSortDirection()`



## TableSort

This service exposes default sorting functionality in the cases where all the
data can be fetched at once and sorting doesn't need further API requests.

It essentially does an in-memory sort of your data.

```coffeescript
{sort} = TableSort
sortedData = sort(data, header)
```

It looks at `header.sortField` and `header.sortDirection` and sorts all the data
accordingly. It works automatically with `number`, `boolean` and `string` values.



## Caveats

Remember that `<th-table-cell>` and `<th-table-row type="actions">` transclude
their contents? This means that, in theory, their contents can only see the
scope outside thTable.

However, because of implementation limitations, there is a slight change to this
behavior for thTable: their contents have access to a new scope that inherits
the outside scope and overrides the `thTable` field as the controller of
`thTable`.



## FAQ

#### How do I enable sorting?

When creating the delegate, you set the `sortField` on the headers that you want
to be sortable.

#### How do I enable pagination?

You set the `pageSize` field when creating the delegate. The table won't display
pagination controls if:

* there is just one page
* you don't pass `totalItems` to `updateData({error, data, totalItems})`
