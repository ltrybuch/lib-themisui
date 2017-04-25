interface DataTableOptions {
  dataSource: kendo.data.DataSource;
  columns: any[];
  resizable?: boolean;
  selectable?: boolean;
  pageable?: boolean;
  onDataBound?: (uIDs: number[]) => void;
  onSelectionChange?: (selection: number[]) => void;
};

export {
  DataTableOptions
}
