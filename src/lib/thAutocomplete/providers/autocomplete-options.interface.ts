type Delegate = {
  autoBind?: boolean,
  dataSource: kendo.data.DataSource,
  displayField?: string,
  trackField?: string,
  filterType?: string,
  minLength?: number
};

type AutocompleteOptions = {
  dataTextField?: string,
  delegate: Delegate,
  change: any,
  combobox: boolean,
  enabled?: boolean,
  element: any,
  parentElement: any,
  filter?: string,
  dataSource?: Object,
  minLength?: number,
  multiple: boolean,
  ngChange: any,
  ngDisabled: any,
  ngRequired: any,
  placeholder: string,
  value: any,
  noDataTemplate?: string,
  rowTemplate?: string
};


export {
  AutocompleteOptions,
  Delegate
}
