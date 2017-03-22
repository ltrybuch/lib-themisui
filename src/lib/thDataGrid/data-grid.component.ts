import * as angular from "angular";
import { DataGridOptions } from "./data-grid.interfaces";
import { DataGridService } from "./data-grid.service";
const template = require("./data-grid.template.html") as string;

class DataGrid {
  wholePageSelected = false;
  partialPageSelected = false;
  selectedRows: boolean[] = [];
  private currentVisibleRows: number[] = [];
  private options: DataGridOptions;
  private datagrid: kendo.ui.Grid;
  static checkboxColumn = {
    width: "34px",
    title: "<span class='" + DataGridService.headerCheckboxCSSClass + "'></span>",
    template: `<span class="${DataGridService.rowCheckboxCSSClass}" data-uid="#= id #"></span>`
  };

  /* @ngInject */
  constructor(
    private $element: angular.IAugmentedJQuery,
    private DataGridService: DataGridService,
    private $scope: ng.IScope
  ) {}

  $onInit() {
    const options = { ...this.options };
    const datagridElement = angular.element(".th-data-grid", this.$element);
    if (options.selectable) {
      options.columns = [DataGrid.checkboxColumn, ...options.columns];
      options.onDataBound = this.setCurrentVisibleRows.bind(this);
    }

    this.datagrid = this.DataGridService.create(datagridElement[0], options, this.$scope);
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

const DataGridComponent: angular.IComponentOptions = {
  template,
  bindings: {
    options: "<"
  },
  transclude: true,
  controller: DataGrid
};
export { DataGrid, DataGridComponent };
