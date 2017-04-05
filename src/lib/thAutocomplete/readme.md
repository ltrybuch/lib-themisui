# Autocomplete

<span class="badge green">Ready</span>

`th-autocomplete` is used to suggest options to the user based on keyboard input.

### Example

```html
<th-autocomplete options="demo.options"></th-autocomplete>
<th-autocomplete options="demo.options" ng-model="demo.value"></th-autocomplete>
<th-autocomplete options="demo.options" ng-model="demo.value" on-change="demo.onChange"></th-autocomplete>
<th-autocomplete options="demo.options" placeholder="Select an option"></th-autocomplete>
<th-autocomplete options="demo.options" condensed></th-autocomplete>
<th-autocomplete options="demo.options" combobox></th-autocomplete>
<th-autocomplete options="demo.options" multiple></th-autocomplete>
```

## API Reference

### Properties
| Property         | Type        | Description   |   |
|:-------------    |:-------     | :-------------|---|
| **ng-model**     | Object      | Updated to `value` when the user selects an option from the component. | *optional* |
| **on-change**    | Function    | Called whenever `value` is updated within the component. | *optional* |
| **ng-disabled**  | Boolean     | Disables the component when true. | *optional* |
| **placeholder**  | String      | Default text that is displayed prior to the user selecting an option. | *optional* |
| **name**         | String      | The name used when submitting `th-autocomplete` as part of a form. | *optional* |
| **options**      | Object      | The main configuration object for the component. | **required** |

### Attributes
| Property         | Description   |   |
|:-------------    | :-------------|---|
| **condensed**    | Applies condensed styling to the component. | *optional* |
| **combobox**     | Enables the combobox functionality, allowing the user to select options without entering any text. | *optional* |
| **multiple**     | Enables multiple-selection, allowing the user to select more than one value. | *optional* |

### Options Object (**required**)
Configure th-autocomplete by providing the following options. Refer to the Demos for code samples.

| Property            | Type      | Description   |   |
|:-------------       |:-------   | :-------------|---|
| **autoBind**        | Boolean   | Auto-load data on initialization (*only applies to combobox and multiple and defaults to true*). | *optional* |
| **displayField**    | String    | The item field to use for the display label (ex: `name`). | **required** |
| **trackField**      | String    | Defines the unique key to use for indexing list items internally (defaults to `id`). | *optional* |
| **filter**          | String    | The filtering strategy (defaults to `startswith`). Use one of (`startswith`,`endswith`,`contains`). | *optional* |
| **groupBy**         | String    | Enables grouping of results by a field. (e.g. `category`). | *optional* |
| **minLength**       | String    | The minimum number of characters a user must type before the component will attempt to fetch results. | *optional* |
| **noDataTemplate**  | String    | Specify a custom no data results found template for the dropdown results. | *optional* |
| **rowTemplate**     | String    | Specify a custom row template for the dropdown results. | **experimental** |
| **dataSource**      | Object    | Use ```DataSource.createDataSource({})``` | **required** |

DataSource Reference: [kendo.data.DataSource](http://docs.telerik.com/kendo-ui/api/javascript/data/datasource) options.

### Ng-Model Initial Values
Set the initial value of the component with the ng-model property. Refer to the table below for expected values per type.

| Component Type  | Data Type   | Example  |
|:-------------   | :---------  |----------|
| Autocomplete    | Object      | `{id: 6, name: "Winnipeg", province: "Manitoba"}` |
| Combobox        | Object      | `{id: 6, name: "Winnipeg", province: "Manitoba"}` |
| Multiple        | Array[int]  | `[6, 27]` |
