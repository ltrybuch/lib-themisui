# DataTable — `thTable`

## Description

This component was built to replace all DataTables used in Clio.



## Usage

`th-table` receives a single attribute, the `delegate`, which is an object that
manages the entire state of the table:
* data
* headers
* pagination
* sorting
* loading and error states

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

### `cells`

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

### `actions`

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

### `no-data`

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
  * When this is set, the table will display pagination controls at the bottom.

* `currentPage` (optional, default value: 1)
  * The current page to display when the table is initialized.


The SimpleTableDelegate instance exposes the following methods and properties
that you can use:

* `headers`
  * Reference to the headers that you pass to the delegate on creation.

* `triggerFetchData()`
  * Manually calls `fetchData()` with the current state of the table
    (pagination, sorting)

* `getData()`
  * Returns an array of data that the table currently displays.

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

* `name` (optional, default value: `""`) is what will be displayed as the column
  title in the table.

* `sortField` (optional) is the field in the data objects that sorting will be
  made by. Setting this field enables sorting for that specific column.

* `sortActive` (optional) can be set to `true` only on one header at a time
  and it symbolizes the fact that sorting is currently done by this column.

* `sortDirection` (optional, default value: `"ascending"`) can be either
  `"ascending"` or `"descending"`.



## TableSort

This service exposes default sorting functionality in the cases where all the
data can be fetched at once and sorting doesn't need further API requests.

```coffeescript
{sort} = TableSort
sort(data, header)
```

It looks at `header.sortField` and `header.sortDirection` and sorts all the data
accordingly.

`sortField` can have the following values:

* `""` - this means that the entire object is the value
* `"regularField"`
* `"deeply.nested.field"`
