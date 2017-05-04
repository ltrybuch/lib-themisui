interface RowActionsProcessed {
  [fnName: string]: (data: any) => void;
};

interface DataTableUserOptions {
  dataSource: kendo.data.DataSource;
  columns: any[];
  resizable?: boolean;
  selectable?: boolean;
  pageable?: boolean;
  onDataBound?: (uIDs: string[]) => void;
  pageRefreshOnDataBound?: (uIDs: string[]) => void;
  onSelectionChange?: (selection: string[]) => void;
  rowActionsTemplate?: string;
  rowActions?: RowActionsProcessed;
};

export {
  DataTableUserOptions,
  RowActionsProcessed,
}
