# Data Table

<span class="badge orange">In Progress</span>

`th-data-table` is used to display data in a table.

## Example

```html
<th-data-table options="demo.options"></th-data-table>
<th-data-table options="demo.options">
  <th-data-table-toolbar>
    <bulk-actions></bulk-actions>
    <custom-actions></custom-actions>
  </th-data-table-toolbar>
</th-data-table>
```

## API Reference

| Property        | Type        | Description   |   |
|:-------------   |:-------     | :-------------|---|
| **options**     | Object      | The main configuration object for the component. | **required** |

### Options Object (**required**)

Configure th-data-table by providing the following options. Refer to the Demos for code samples.

| Property            | Type      | Description   |   |
|:-------------       |:-------   | :-------------|---|
| **dataSource**        | Object    | Use ```DataSource.createDataSource({})``` | **required** |
| **columns**           | Array     | An array used for configuration of the table columns. | **required** |
| **resizable**         | Boolean   | Enable column resizing for the Data Table | *optional* |
| **selectable**        | Boolean   | Applies checkboxes to rows. | *optional* |
| **pageable**          | Boolean   | Applies pagination to the table. | *optional* |
| **onDataBound**       | Function  | Called when data is bound. The first parameter will be an array of ID of all selected items. | *optional* |
| **onSelectionChange** | Function  | Called whenever selection is updated. The first parameter will be an array of ID of all selected items. | *optional* |

DataSource Reference: [kendo.data.DataSource](http://docs.telerik.com/kendo-ui/api/javascript/data/datasource) options.

Note: [Miniumum column widths](http://docs.telerik.com/kendo-ui/api/javascript/ui/grid#configuration-columns.minResizableWidth) can be set in your `options.columns` config.
