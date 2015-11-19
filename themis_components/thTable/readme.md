# DataTable — `thTable` / `thTableCell` / `thTableRowExtension`

### Description

I think tables and lists should be separate components. Why? Because if we make
them a single generic component, then we will have to make compromises in their
usage (it gets more complicated that it should be).


### List component w/ pagination

```html
<th-list objects="arrayOfObjects"
         [objectReference="item"]
         [pageNumber="1"]
         [totalPages="10"]
         [changePage="(page) ->"]>
  Whatever you implement here will get replicated for each object in the array
  that's passed to th-list. You can use the objectReference to access fields of
  the current object. By default it's set as {{item}}.
</th-list>
```

### Table component w/ pagination, sortable header, custom rows and custom cells

```html
<th-table objects="arrayOfObjects"
          [objectReference="item"]

          [pageNumber="1"]
          [totalPages="10"]
          [changePage="(page) ->"]

          [onSort="(field, order) ->"]>

  <th-table-cell [headerTitle="Title for the entire column"] [sortable="fieldName"]>
    You can implement each cell however you want - the contents are transcluded.
    You can use {{item}} or whatever is configured by objectReference to access
    the current object in the row.
  </th-table-cell>

  [...]

  <th-table-cell [headerTitle="Title for the entire column"] [sortable="fieldName"]>
    [...]
  </th-table-cell>

  <th-table-row-extension position="below(default)|above">
    You can add an optional row extension that is displayed below or above each
    set of cells. This is where you would add action buttons for the current
    {{item}} in the row.
  </th-table-row-extension>

</th-table>
```

### Selecting rows in the table

If you wanted to implement selection of rows via checkboxes, like we have in
`/bills` right now, you could add an initial `th-table-cell` like so:

```html
<th-table-cell>
  <th-checkbox ng-model="isSelected object" ng-change="(object) ->"></th-checkbox>
</th-table-cell>
```

The checkbox would need to be changed to:
* accept state through ng-model as one-way data binding
* send out an action (call a function) on toggle
