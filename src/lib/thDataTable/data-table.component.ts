import * as angular from "angular";
import { DataTableUserOptions } from "./data-table.interfaces";
import { DataTableService } from "./data-table.service";
const template = require("./data-table.template.html") as string;

class DataTable {
  // We can set this to true once we actually want select ALL functionality in (CLIO-45222).
  static selectAllFunctionality = false;
  private dataTableUserOptions: DataTableUserOptions;
  private dataSource: kendo.data.DataSource;
  processedOptions: kendo.ui.GridOptions;
  wholePageSelected = false;
  partialPageSelected = false;
  showSelectAllBanner = false;
  selectionStatusDict: any = {};
  totalDataLength: number;
  numOfColumns: number;

  /* @ngInject */
  constructor(
    private DataTableService: DataTableService,
    private $scope: ng.IScope,
    private $element: angular.IAugmentedJQuery,
  ) {}

  $onInit() {
    if (DataTable.selectAllFunctionality) {
      this.numOfColumns = this.dataTableUserOptions.columns.length;
      this.DataTableService.initializeSelectAllBanner(this.$element, this.$scope);
    }

    this.dataSource = this.dataTableUserOptions.dataSource;
    this.totalDataLength = this.dataSource.data().length;
    this.processedOptions = this.DataTableService.getComponentOptions(this.dataTableUserOptions);
  }

  togglePage() {
    const currentPageRows = this.dataSource.view();

    currentPageRows.forEach((row: kendo.data.ObservableObject) => {
      this.selectionStatusDict[row.uid] = this.wholePageSelected;
    });

    this.onSelectionChangeHandler();
  }

  selectAll() {
    const data = this.dataSource.data();
    data.forEach((row: any) => this.selectionStatusDict[row.uID] = true);

    this.updatePageSelectionStatuses();
    this.onSelectionChangeHandler();
    this.showSelectAllBanner = false;
  }

  clearSelection() {
    this.selectionStatusDict = {};
    this.updatePageSelectionStatuses();
    this.onSelectionChangeHandler();
  }

  rowCheckboxClickHander() {
    this.updatePageSelectionStatuses();
    this.onSelectionChangeHandler();
  }

  getSelectedSize() {
    const selectedUIDs = this.getSelectedUIDs();
    return selectedUIDs.length;
  }

  private onSelectionChangeHandler() {
    if (typeof this.dataTableUserOptions.onSelectionChange === "function") {
      this.dataTableUserOptions.onSelectionChange(this.getSelectedUIDs());
    }
  }

  private updatePageSelectionStatuses() {
    const currentPageRows = this.dataSource.view();
    const selectionFilter = (row: kendo.data.ObservableObject) => this.selectionStatusDict[row.uid];
    const pageSelectedUIDs: string[] = currentPageRows.filter(selectionFilter);
    const pageSelectedSize = pageSelectedUIDs.length;
    const pageSize = this.dataSource.pageSize();

    this.wholePageSelected = pageSelectedSize > 0 && pageSelectedSize === pageSize;
    this.partialPageSelected = pageSelectedSize > 0 && pageSelectedSize < pageSize;
    this.showSelectAllBanner = this.wholePageSelected;
  }

  private getSelectedUIDs(): string[] {
    let selectedUIDs: string[] = [];

    for (const uID in this.selectionStatusDict) {
      if (this.selectionStatusDict.hasOwnProperty(uID)) {
        if (this.selectionStatusDict[uID]) {
          selectedUIDs = [ ...selectedUIDs, uID];
        }
      }
    }

    return selectedUIDs;
  }
}

const DataTableComponent: angular.IComponentOptions = {
  template,
  bindings: {
    dataTableUserOptions: "<options",
  },
  transclude: true,
  controller: DataTable,
};
export { DataTable, DataTableComponent };
