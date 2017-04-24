import * as angular from "angular";
import { DataTableOptions } from "./data-table.interfaces";
import { DataTableService } from "./data-table.service";
const template = require("./data-table.template.html") as string;

class DataTable {
  // We can set this to true once we actually want select ALL functionality in (CLIO-45222).
  static selectAllFunctionality = false;

  private currentVisibleRows: number[] = [];
  private options: DataTableOptions;
  private datatable: kendo.ui.Grid;
  wholePageSelected = false;
  partialPageSelected = false;
  showSelectAllBanner = false;
  selectedRows: boolean[] = [];
  totalLength: number;

  /* @ngInject */
  constructor(
    private $element: angular.IAugmentedJQuery,
    private DataTableService: DataTableService,
    private $scope: ng.IScope,
  ) {}

  $onInit() {
    const options = { ...this.options };
    const datatableElement = angular.element(".th-data-table", this.$element);

    if (options.selectable) {
      options.columns = [DataTableService.checkboxColumn, ...options.columns];
      options.onDataBound = this.setCurrentVisibleRows.bind(this);
    }

    this.datatable = this.DataTableService.create(datatableElement[0], options, this.$scope);
    this.totalLength = this.options.dataSource.data().length;

    if (DataTable.selectAllFunctionality) {
      this.DataTableService.initializeSelectAllBanner(this.$element, this.$scope, this.options.columns.length);
    }
  }

  togglePage() {
    const rows = this.currentVisibleRows;
    const isSelected = (id: number) => this.selectedRows[id] === true;
    const allSelected = rows.every(isSelected);

    rows.forEach(rowId => {
      this.selectedRows[rowId] = !allSelected;
    });

    this.updateHeaderCheckboxState();
  }

  selectAll() {
    const data = this.options.dataSource.data();

    data.forEach((e: any) => {
      this.selectedRows[e.id] = true;
    });

    this.updateHeaderCheckboxState();
    this.showSelectAllBanner = false;
  }

  clearSelection() {
    this.selectedRows = [];
    this.updateHeaderCheckboxState();
  }

  getSelectedSize() {
    const selectedIDs = this.getSelectedIDs();
    return selectedIDs.length;
  }

  updateHeaderCheckboxState() {
    const rows = this.currentVisibleRows;
    const isSelected = (id: number) => this.selectedRows[id] === true;
    const allSelected = rows.every(isSelected);

    this.partialPageSelected = !allSelected && rows.some(isSelected);
    this.wholePageSelected = allSelected;
    this.showSelectAllBanner = allSelected;

    if (typeof this.options.onSelectionChange === "function") {
      this.options.onSelectionChange(this.getSelectedIDs());
    }
  }

  private getSelectedIDs(): number[] {
    return this.selectedRows.reduce((selectedIDs, selected, uID) => {
      if (selected) {
        return [...selectedIDs, uID];
      } else {
        return selectedIDs;
      }
    }, []);
  }

  private setCurrentVisibleRows(uIDs: number[]) {
    this.currentVisibleRows = uIDs;
    this.updateHeaderCheckboxState();
  }
}

const DataTableComponent: angular.IComponentOptions = {
  template,
  bindings: {
    options: "<",
  },
  transclude: true,
  controller: DataTable,
};
export { DataTable, DataTableComponent };
