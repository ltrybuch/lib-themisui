# th-autocomplete

`th-autocomplete` is used to suggest options to the user based on keyboard input.

## Example

```html
<th-autocomplete delegate="demo.delegate"></th-autocomplete>
<th-autocomplete delegate="demo.delegate" ng-model="demo.value"></th-autocomplete>
<th-autocomplete delegate="demo.delegate" on-change="demo.onChange"></th-autocomplete>
<th-autocomplete delegate="demo.delegate" placeholder="Select an option"></th-autocomplete>
<th-autocomplete delegate="demo.delegate" combobox="true"></th-autocomplete>
<th-autocomplete delegate="demo.delegate" multiple="true"></th-autocomplete>
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
| **condensed**    | String      | Applies condensed styling to the component. | *optional* |
| **group-by**     | String      | Enables grouping of results by a certain value (e.g. `practice_area_id`). | *optional* |
| **combobox**     | Boolean     | Enables the combobox functionality, allowing the user to select options without entering any text. | *optional* |
| **multiple**     | Boolean     | Enables multiple-selection, allowing the user to select more than one value | *optional* |
| **delegate**     | Object      | The main configuration object for the component. | *required* |
| **row-template** | Object      | Specify a custom row template (**experimental**) | *required* |

### Delegate
The th-autocomplete delegate supplies configuration options for the component. Refer to the Demos for code samples.

* `delegate` (**required**) represents a dictionary of arguments passed to the component.
  * `dataSource` (**required**) - Use ```DataSource.createDataSource({})``` 
  which takes any valid [kendo.data.DataSource](http://docs.telerik.com/kendo-ui/api/javascript/data/datasource) options.
  * `displayField` (*required*) the item field to display (ex: `name`).
  * `trackField` (*optional*) defines the unique key to use for indexing list items internally (defaults to `id`).
