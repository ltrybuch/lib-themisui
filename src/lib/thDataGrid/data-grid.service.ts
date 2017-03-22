import * as angular from "angular";
import { DataGridOptions } from "./data-grid.interfaces";
import "@progress/kendo-ui/js/kendo.grid.js";

class DataGridService {
  static headerCheckboxCSSClass = "page-checkbox-container";
  static rowCheckboxCSSClass = "row-checkbox-container";
  static placeholder = "________";
  static pageCheckbox = `
    <th-checkbox
      ng-click="$ctrl.togglePage()"
      ng-model="$ctrl.wholePageSelected"
      indeterminate="$ctrl.partialPageSelected"
      >
    </th-checkbox>`;
  static rowCheckbox = `
    <th-checkbox
      ng-model="$ctrl.selectedRows[${DataGridService.placeholder}]"
      ng-click="$ctrl.updateHeaderCheckboxState()"
      >
    </th-checkbox>`;

  /* @ngInject */
  constructor(private $compile: ng.ICompileService) {}

  create(element: Element, options: DataGridOptions, $scope: angular.IScope) {
    const $element = angular.element(element);

    const kendoOptions: kendo.ui.GridOptions = {
      columns: options.columns,
      dataSource: options.dataSource,
      pageable: options.pageable,
      dataBound: (_e: kendo.ui.GridDataBoundEvent) => {
        let uIDs: number[];

        if (options.selectable) {
          uIDs = this.initCheckBoxes($element, $scope);
        }

        if (typeof options.onDataBound === "function") {
          options.onDataBound(uIDs || []);
        }
      }
    };

    return new kendo.ui.Grid(element, kendoOptions);
  }

  private initCheckBoxes($element: JQuery, $scope: angular.IScope) {
    const $headContainer = angular.element("." + DataGridService.headerCheckboxCSSClass, $element);
    const $rowContainers = angular.element("." + DataGridService.rowCheckboxCSSClass, $element);
    let uIDs: number[] = [];

    $rowContainers.each((_index, rowContainer) => {
      const rowUID = rowContainer.getAttribute("data-uid");
      const $rowCheckboxContainer = angular.element(rowContainer);
      const rowCheckbox = DataGridService.rowCheckbox.replace(DataGridService.placeholder, rowUID);
      const $rowCheckbox = this.$compile(rowCheckbox)($scope);

      uIDs = [...uIDs, parseInt(rowUID, 10)];
      $rowCheckboxContainer.append($rowCheckbox);
    });

    const $pageCheckbox = this.$compile(DataGridService.pageCheckbox)($scope);
    $headContainer.empty().append($pageCheckbox);

    return uIDs;
  }
}

export { DataGridService };
