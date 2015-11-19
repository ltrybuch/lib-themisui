# DataTable — `thTable` / `thTableCell` / `thTableRowExtension`

### Description

This component replaces all DataTables used in Clio right now.

### Usage

```html
<th-table objects="arrayOfObjects"
          [object-reference="item"]

          [page="1"]
          [page-size="20"]
          [total-objects="233"]
          [change-page="(page) ->"]

          [on-sort="(field, order) ->"]>

  <th-table-cell [header-title="title for the entire column"]
                 [header-align="left(default)|right|center"]
                 [sortable="fieldName"]
                 [default-sort-order="ascending|descending"]>
    You can implement each cell however you want - the contents are transcluded.
    You can use {{item}} or whatever is configured by object-reference to access
    the current object in the row.
  </th-table-cell>

  ... <!-- Define all <th-table-cell>s first. -->

  <th-table-cell ...> ... </th-table-cell>

  <!-- Then define an optional row extension for things like action buttons. -->

  <th-table-row-extension>
    You can add an optional row extension that is displayed below or above each
    set of cells. This is where you would add action buttons for the current
    {{item}} in the row.
  </th-table-row-extension>

</th-table>
```

### Example of extending the table

If you wanted to implement selection of rows via checkboxes, like we have in
`/bills` right now, you could add an initial `th-table-cell` like so:

```html
<th-table-cell>
  <th-checkbox ng-model="isSelected object" ng-change="(object) ->"></th-checkbox>
</th-table-cell>
```

The checkbox would need to be changed to:
* accept state through ng-model through one-way data binding
* send out an action (call a function) on toggle
