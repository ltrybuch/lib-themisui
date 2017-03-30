# Data Table

<span class="badge orange">In Progress</span>

`th-data-table` is used to display data in a table.

## Usage

```html
<th-data-table options="demo.options"></th-data-table>
```

## API Reference

| Property        | Type        | Description   |   |
|:-------------   |:-------     | :-------------|---|
| **options**    | Object      | The main configuration object for the component. | *required* |

### Delegate
The th-data-table options object supplies configuration options for the component. Refer to the Demos for code samples.

* `options` (**required**) represents a dictionary of arguments passed to the component.
  * `dataSource` (**required**) - Use ```DataSource.createDataSource({})```
  which takes any valid [kendo.data.DataSource](http://docs.telerik.com/kendo-ui/api/javascript/data/datasource) options.
  * `columns` (**required**) - An array used for configuration of the table columns.
