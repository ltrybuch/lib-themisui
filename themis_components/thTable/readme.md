# DataTable — `thTable` / `thTableRow` / `TableDelegate`

## Description

This component can replace all DataTables used in Clio right now.

## Usage

`th-table` receives a single attribute, the `delegate`, which is an object that
manages the entire state of the table:
* data
* headers
* pagination
* sorting
* what rows to display for each data object

Inside `th-table` you don't actually define the contents of the table, you only
need to define all the row types that your table will need to display. Then it's
up to the delegate to display those rows however it needs for each data object.

A row type can be defined by adding a `th-table-row` component inside
`th-table`. It accepts 2 attributes:
* `type`, which is needed by the delegate to differentiate between multiple row
  types.
* `object-reference`, which defines the symbol that you can use to access each
  data object when implementing the template for a table row. The default value
  is `item`.

For convenience, there are already a few delegates and row types defined and ready
to use for the most common datatables in Clio. You can see examples of their usage
below:

## Simple table (example: `/matters`)

```coffeescript
controller: ->
  @tableDelegate = new SimpleTableDelegate
    data: mattersArray

    # If these are defined, the table displays pagination at the bottom.
    page: 1
    pageSize: 20
    totalItems: 223
    onChangePage: (page) ->

    onSort: (field, direction) ->

    onSelect: (object) ->

    headers: [
      new TableHeader
        name: 'Column title'
        sortField: 'fieldName'
        sortEnabled: 'ascending|descending'
        align: 'left(default)|right|center'

      # ...
    ]
```

```html
<th-table delegate="controller.tableDelegate">
  <th-table-row type="cells" [object-reference="item"]>
    <th-table-cell>
      You can implement each cell however you want - the contents are transcluded.
      You can use {{item}} or whatever is configured by object-reference to access
      the current object in the row.
    </th-table-cell>
    <th-table-cell>...</th-table-cell>
    <th-table-cell>...</th-table-cell>
  </th-table-row>

  <th-table-row type="actions" [object-reference="item"] [start-column="1(default)|2|..."]>
    This is where you would add action buttons for the current {{item}} in the row.
  </th-table-row>
</th-table>
```

## Table with subheadings (example: `/tasks`)

This is work in progress - it has not yet been released in ThemisUI.

```coffeescript
controller: ->
  @tableDelegate = new SectionsTableDelegate
    # Format of the individual objects in the array:
    # {
    #  title: 'Overdue'
    #  tasks: arrayOfTasks
    # }
    data: sectionsArray

    # If these are defined, the table displays pagination at the bottom.
    page: 1
    pageSize: 20
    totalItems: 223
    onChangePage: (page) ->

    onSort: (field, direction) ->
    onSelect: (object) ->

    headers: [
      new TableHeader
        name: 'Column title'
        sortField: 'fieldName'
        sortEnabled: 'false(default)|ascending|descending'
        align: 'left(default)|right|center'

      # ...
    ]
```

```html
<th-table delegate="controller.tableDelegate">
  <th-table-row type="section-title" [object-reference="item"]>
    {{item.title}}
  </th-table-row>

  <th-table-row type="cells" [object-reference="item"]>
    <th-table-cell>
      You can implement each cell however you want - the contents are transcluded.
      You can use {{item}} or whatever is configured by object-reference to access
      the current object in the row.
    </th-table-cell>
    <th-table-cell>...</th-table-cell>
    <th-table-cell>...</th-table-cell>
  </th-table-row>
</th-table>
```

## Table with groups (example: `/bills` -> Billable Clients)

This is work in progress - it has not yet been released in ThemisUI.

```coffeescript
controller: ->
  @tableDelegate = new GroupTableDelegate
    # Format of the individual objects in the array:
    # {
    #  header: contactObject
    #  items: arrayOfMatters
    # }
    data: arrayOfGroups

    page: 1
    pageSize: 20
    totalItems: 223
    onChangePage: (page) ->

    onSelect: (object) ->

    headers: [
      new TableHeader
        name: 'Column title'
        align: 'left(default)|right|center'
      # ...
    ]
```

```html
<th-table delegate="controller.tableDelegate">
  <th-table-row type="group-header-cells" [object-reference="item"]>
    <th-table-cell>
      You can implement each cell however you want - the contents are transcluded.
      You can use {{item}} or whatever is configured by object-reference to access
      the current object in the row.
    </th-table-cell>
    <th-table-cell>...</th-table-cell>
    <th-table-cell>...</th-table-cell>
  </th-table-row>

  <th-table-row type="group-item-cells" [object-reference="item"]>
    <th-table-cell>
      You can implement each cell however you want - the contents are transcluded.
      You can use {{item}} or whatever is configured by object-reference to access
      the current object in the row.
    </th-table-cell>
    <th-table-cell>...</th-table-cell>
    <th-table-cell>...</th-table-cell>
  </th-table-row>
</th-table>
```

## Old design

This is the initial design that was proposed. It hasn't been used because it's
not flexible enough for all datatables in Clio.

```html
<th-table objects="arrayOfObjects"
          [object-reference="item"]

          [page="1"]
          [page-size="20"]
          [total-objects="233"]
          [change-page="(page) ->"]

          [on-sort="(field, order) ->"]>

  <!-- First define all <th-table-cell>s that you want to display on
       each table row.
    -->

  <th-table-cell [header-title="title for the entire column"]
                 [header-align="left(default)|right|center"]

                 [sortable="fieldName"]
                 [default-sort-order="ascending|descending"]>

    You can implement each cell however you want - the contents are transcluded.
    You can use {{item}} or whatever is configured by object-reference to access
    the current object in the row.

  </th-table-cell>

  ...

  <th-table-cell ...> ... </th-table-cell>



  <!-- After defining all cells you can define an optional row extension. This
       will be displayed on each row, below the set of cells.

       This must be defined at the end of the table definition, not before or
       between <th-table-cell>s. Otherwise, <th-table> will throw an error.
    -->

  [<th-table-row-extension [start-column=1(default)|2|...]>

    This is where you would add action buttons for the current {{item}} in the row.
    The contents of this component will get transcluded.

  </th-table-row-extension>]

</th-table>
```

## TODO

* How do we style columns? How do we set widths for them?
* Rename normal to simple
