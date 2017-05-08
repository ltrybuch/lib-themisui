# Filter

<span class="badge orange">In Progress</span>

`th-filter` is used to filter a set of data by applying operators to the fields of a dataset.

### Example

```html
<th-filter options="demo.filterOptions">
  <th-static-filters></th-static-filters>
  <th-custom-filters></th-custom-filters>
  <th-search-row></th-search-row>
</th-filter>
```

## Transcludable Components
| Component        | Description   |
|:-------------    | :-------------|
| `th-static-filters` | Used to display filters that are always available. |
| `th-custom-filters` | Used to display filters that users can optionally activate. |
| `th-search-row` | Used to display a search filter. This filters on the `query` or another given field. |

## API Reference

### Properties
| Property         | Type        | Description   |   |
|:-------------    |:-------     | :-------------|---|
| **options**      | Object      | The main configuration object for the component. | **required** |

### Options Object (**required**)
Configure th-filter by providing the following options. Refer to the Demos for code samples.

| Property            | Type     | Description   |   |
|:-------------       |:-------  | :-------------|---|
| **filterSet**       | FilterSet| A `FilterSet` object that holds the current state of the filter (*See [FilterSet](#filterset)*). | **required** |
| **staticFilters**   | Array    | An array of filters that are statically available (*See [Filter Types](#filter-types)*). When the `th-static-filters` component is transcluded into the filter component, this property becomes **required**. | *optional* |
| **customFilterTypes**   | Array    | An additional array of filters that users can optionally activate (*See [Filter Types](#filter-types)*).  When the `th-custom-filters` component is transcluded into the filter component, this property becomes **required**. | *optional* |
| **customFilterUrl**   | String    | A URL endpoint that returns an array of filter options. When the `th-custom-filters` component is transcluded into the filter component, and a `customFilterTypes` array is not provided, this property becomes **required**. | *optional* |
| **customFilterConverter**   | CustomFilterConverter    | A subclass of the `CustomFilerConverter` factory that implements a `mapToCustomFilterArray` method. This method will be called with the data returned from `customFilterUrl` and should return an array containing custom filter objects. (*See [CustomFilterConverter Example](#customfilterconverter-example)*) | *optional* |
| **fieldIdentifier**   | String    | The name of the field that the `th-search-row` component will query. Defaults to `query`. | *optional* |
| **initialState**   | Object    | An object of where the keys are the `fieldIdentifier`'s and values are objects representing the initial state of the field. | *optional* |

#### CustomFilterConverter Example

```TypeScript
class MyCustomFilterConverter extends CustomFilterConverter {
  private getType(fieldType: string) {
    switch(fieldType) {
      case "picklist":
        return "select";
      case "text_line":
        return "input";
      default:
        throw new Error("unsupported field_type");
    }
  }

  private mapSelectOptions(options: CustomField[]) {
    if (options instanceof Array !== true) {
      return;
    }

    return options.map(option => {
      return {
        name: option.option,
        value: option.id,
      };
    });
  }

  mapToCustomFilterArray(data: any[]) {
    return data.map((item: MyData[]) => {
      return {
        fieldIdentifier: item.id,
        name: item.name,
        type: this.getType(item.field_type),
        selectOptions: this.mapSelectOptions(item.custom_field_picklist_options),
      };
    });
  }
}
```

## FilterSet

### Example

```TypeScript
const filterSet = new FilterSet({
  onFilterChange: updateDataSource,
  onInitialized: updateDataSource,
});

function updateDataSource() {
  dataSource.filter(filterSet.getState());
}
```

### Properties
The `FilterSet` constructor takes a configuration object with the following callbacks for triggering updates on your view components.

| Property         | Type        | Description   |   |
|:-------------    |:-------     | :-------------|---|
| **onFilterChange** | Function  | Called whenever the state of the filter changes. | **required** |
| **onInitialized**  | Function  | Called when the filter is first initialized. | *optional* |

### Methods
| Method         | Returns     | Description   |
|:-------------  |:-------     | :-------------|
| **getState()** | Object  | Returns the filter's current state in the shape of `{ [field]: { operator: string; value: any; } }` |
| **getDataSourceState()**  | Array  | Returns an array with a DataSource-compatible filter state for client-side filtering. The operators are formatted to follow the [DataSource standard](http://docs.telerik.com/kendo-ui/api/javascript/data/datasource#configuration-filter.operator), and each filter state in the array follows the shape: `{ field: string; operator: string; value: any; }`. |
| **getMetaData()**  | Object  | Returns an object holding the filter metadata in the shape of `{ [field]: any }`  |
| **find()**  | Boolean  | Behaves like `Array.prototype.find`, takes a predicate function that receives the current filter object: `.find(filter => filter.fieldIdentifier === "name")`.  |

## Filter Types
Filter types are used to set up the filters in both the `staticFilters` and `customFilters` arrays passed to `th-filter`'s configuration object.

### Properties

| Property         | Type        | Description   |   |
|:-------------    |:-------     | :-------------|---|
| **type** | String  | The filter's type. Accepted values are: `select`, `input`, `number`, `currency`, `checkbox`, `url`, `email`, `autocomplete` and `date`. | **required** |
| **name**  | String  | The label given to the filter. | **required** |
| **fieldIdentifier**  | String  | The name of the field in your data that the filter acts on. | **required** |
| **metadata**  | Any  | Additional data to be returned by `getMetadata(). | *optional* |

### Select Filter
The select filter accepts additional properties:

```TypeScript
const selectFilter = {
  type: "select",
  name: "Sample Select",
  fieldIdentifier: "sampleFieldId",

  selectOptions: [
    {
      name: "Option one",
      value: "1",
    },
    {
      name: "Option two",
      value: "2",
    },
  ],

  selectOptionsUrl: "./sampleoptions.json",
  selectOptionsNameField: "altname",
  selectOptionsValueField: "altvalue",
  selectOptionsCallback: response => response.map(item => ({ name: item.color, value: item.id })),

  placeholder: "Placeholder string",
};
```

| Property         | Type        | Description   |   |
|:-------------    |:-------     | :-------------|---|
| **selectOptions** | Array  | Holds the select options avaiable to the user. Objects are name-value pairs. | **required** |
| **selectOptionsUrl**  | String  | If the `selectOptions` array is not provided, then a url to fetch options would be required.  | **required** |
| **selectOptionsNameField**  | String  | The name-field to use in the returned JSON. Defaults to `name`. | *optional* |
| **selectOptionsValueField**  | String  | The value-field to use in the returned JSON. Defaults to `value`. | *optional* |
| **selectOptionsCallback**  | Function  | A map function that receives the response object as an argument. This function should return the array of name-value pair objects for the select to use. | *optional* |
| **placeholder**  | String  | The placeholder to be used in the select element. | *optional* |

### Input Filter
The input filter accepts one additional property:

```TypeScript
const inputFilter = {
  type: "input",
  name: "Sample Input",
  fieldIdentifier: "sampleFieldId",

  placeholder: "Placeholder string",
};
```

| Property         | Type        | Description   |   |
|:-------------    |:-------     | :-------------|---|
| **placeholder**  | String  | The placeholder to be used in the input element. | *optional* |

### Autocomplete Filter
The autocomplete filter accepts additional properties:

```TypeScript
const autocompleteFilter = {
  type: "autocomplete",
  name: "Sample Input",
  fieldIdentifier: "sampleFieldId",

  autocompleteOptions: {
    modelClass: "Contact",
    trackField: "id",
    displayField: "name",
    queryField: "query",
    queryParams: {
      sampleQueryParam: "test data"
    },
  },

  placeholder: "Placeholder string",
};
```

| Property         | Type        | Description   |   |
|:-------------    |:-------     | :-------------|---|
| **autocompleteOptions** | Object  | The main configuration object for the autocomplete filter. | **required** |
| **placeholder**  | String  | The placeholder to be used in the autocomplete element. | *optional* |

#### AutocompleteOptions Object (**required**)

| Property         | Type        | Description   |   |
|:-------------    |:-------     | :-------------|---|
| **modelClass** | String  | The autocomplete field will instantiate the given `modelClass` instance and call `query` for each request, passing the search term and any additional parameters supplied in `queryParams`. | **required** |
| **trackField**  | String  | The unique key to use for each item returned from `ModelClass.query`, for indexing autocomplete options. Defaults to `id`.| *optional* |
| **displayField**  | String  | Te field to display to the user, for each item returned from `ModelClass.query`. Defaults to `name`. | *optional* |
| **queryField**  | String  | The field to query. Defaults to `query`. | *optional* |
| **queryParams**  | Object  | Any additional parameters to pass to `ModelClass.query`. | *optional* |
