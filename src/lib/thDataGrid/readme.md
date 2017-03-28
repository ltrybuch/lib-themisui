# Data Grid

<span class="badge orange">In Progress</span>

`th-data-grid` is used to display data in a table.

## Usage

```html
<th-data-grid options="demo.options"></th-data-grid>
```

## API Reference

| Property        | Type        | Description   |   |
|:-------------   |:-------     | :-------------|---|
| **options**    | Object      | The main configuration object for the component. | *required* |

### Delegate
The th-data-grid options object supplies configuration options for the component. Refer to the Demos for code samples.

* `options` (**required**) represents a dictionary of arguments passed to the component.
  * `dataSource` (**required**) - Use ```DataSource.createDataSource({})```
  which takes any valid [kendo.data.DataSource](http://docs.telerik.com/kendo-ui/api/javascript/data/datasource) options.
  * `columns` (**required**) - An array used for configuration of the grid columns.
