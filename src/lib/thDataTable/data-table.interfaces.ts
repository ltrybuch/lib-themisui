interface DataTableOptions {
  dataSource: kendo.data.DataSource;
  columns: any[];
  selectable?: boolean;
  pageable?: boolean;
  onDataBound?: (uIDs: number[]) => void;
  onSelectionChange?: (selection: number[]) => void;
  actionList: {name: string, href?: string, ngClick?: () => void}[];
};

export {
  DataTableOptions
}
