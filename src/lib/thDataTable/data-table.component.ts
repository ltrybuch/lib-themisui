import * as angular from "angular";
import { DataTableOptions } from "./data-table.interfaces";
import { DataTableService } from "./data-table.service";
const template = require("./data-table.template.html") as string;

class DataTable {
  static checkboxColumn = {
    width: "34px",
    title: "<span class='" + DataTableService.headerCheckboxCSSClass + "'></span>",
    template: `<span class="${DataTableService.rowCheckboxCSSClass}" data-uid="#= id #"></span>`,
  };

  private currentVisibleRows: number[] = [];
  private options: DataTableOptions;
  private datatable: kendo.ui.Grid;
  wholePageSelected = false;
  partialPageSelected = false;
  selectedRows: boolean[] = [];
  actionList: any[];

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
      options.columns = [DataTable.checkboxColumn, ...options.columns];
      options.onDataBound = this.setCurrentVisibleRows.bind(this);
    }

    this.datatable = this.DataTableService.create(datatableElement[0], options, this.$scope);
    this.actionList = options.actionList;
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

  clearSelection() {
    this.selectedRows = [];
    this.updateHeaderCheckboxState();
  }

  updateHeaderCheckboxState() {
    const rows = this.currentVisibleRows;
    const isSelected = (id: number) => this.selectedRows[id] === true;
    const allSelected = rows.every(isSelected);

    this.partialPageSelected = !allSelected && rows.some(isSelected);
    this.wholePageSelected = allSelected;

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
