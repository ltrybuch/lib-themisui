type AutocompleteDataOptions = {
  autoBind?: boolean,
  displayField: string,
  filter?: string,
  groupBy?: string,
  minLength?: number,
  rowTemplate?: string,
  noDataTemplate?: string,
  trackField?: string,
  dataSource: kendo.data.DataSource,
};

type AutocompleteConfiguration = {
  change: any,
  enabled?: boolean,
  element: any,
  ngDisabled: any,
  ngRequired: any,
  placeholder: string,
  value: any,
  options: AutocompleteDataOptions,
};

type AutocompleteType = "autocomplete" | "combobox" | "multiple";


export {
  AutocompleteConfiguration,
  AutocompleteDataOptions,
  AutocompleteType
}
