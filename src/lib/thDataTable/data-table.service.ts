import * as angular from "angular";
import { DataTableOptions } from "./data-table.interfaces";
import "@progress/kendo-ui/js/kendo.grid.js";

class DataTableService {
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
  static checkboxColumn = {
    width: "34px",
    title: "<span class='" + DataTableService.headerCheckboxCSSClass + "'></span>",
    template: `<span class="${DataTableService.rowCheckboxCSSClass}" data-uid="#= id #"></span>`,
  };
  static rowCheckbox = `
    <th-checkbox
      ng-model="$ctrl.selectedRows[${DataTableService.placeholder}]"
      ng-click="$ctrl.updateHeaderCheckboxState()"
      >
    </th-checkbox>`;
  static selectAllBanner = `
    <tr class="select-all-banner" ng-show="$ctrl.showSelectAllBanner">
      <th colspan="${DataTableService.placeholder}">
        All {{ $ctrl.selectedRows.length }} rows on this page selected.
        <a
          class="select-all-rows"
          ng-click="$ctrl.selectAll()"
          >
          Select all {{ $ctrl.totalLength }} rows
        </a>
      </th>
    </tr>`;

  /* @ngInject */
  constructor(private $compile: ng.ICompileService) {}

  create(element: Element, options: DataTableOptions, $scope: angular.IScope) {
    const $element = angular.element(element);
    const pageSizeOptions: kendo.ui.GridPageable = options.pageable
      ? {
        numeric: false,
        pageSize: 50,
        pageSizes: [50, 100, 150, 200],
        messages: {
          display: "{0}\u2013{1} of {2}",
          itemsPerPage: "Results per page",
          empty: "No results to display",
        },
      }
      : false;

    const kendoOptions: kendo.ui.GridOptions = {
      columns: options.columns,
      dataSource: options.dataSource,
      pageable: pageSizeOptions,
      dataBound: (_e: kendo.ui.GridDataBoundEvent) => {
        let uIDs: number[];

        if (options.selectable) {
          uIDs = this.initCheckBoxes($element, $scope);
        }

        if (typeof options.onDataBound === "function") {
          options.onDataBound(uIDs || []);
        }
      },
    };

    return new kendo.ui.Grid(element, kendoOptions);
  }

  initializeSelectAllBanner($element: JQuery, $scope: angular.IScope, colspan: number) {
    const selectAllBanner = DataTableService.selectAllBanner.replace(DataTableService.placeholder, colspan.toString());
    const $selectAllBanner = this.$compile(selectAllBanner)($scope);

    angular.element($element).find("thead").append($selectAllBanner);
  }

  private initCheckBoxes($element: JQuery, $scope: angular.IScope) {
    const $headContainer = angular.element("." + DataTableService.headerCheckboxCSSClass, $element);
    const $rowContainers = angular.element("." + DataTableService.rowCheckboxCSSClass, $element);
    let uIDs: number[] = [];

    $rowContainers.each((_index, rowContainer) => {
      const rowUID = rowContainer.getAttribute("data-uid");
      const $rowCheckboxContainer = angular.element(rowContainer);
      const rowCheckbox = DataTableService.rowCheckbox.replace(DataTableService.placeholder, rowUID);
      const $rowCheckbox = this.$compile(rowCheckbox)($scope);

      uIDs = [...uIDs, parseInt(rowUID, 10)];
      $rowCheckboxContainer.append($rowCheckbox);
    });

    const $pageCheckbox = this.$compile(DataTableService.pageCheckbox)($scope);
    $headContainer.empty().append($pageCheckbox);

    return uIDs;
  }
}

export { DataTableService };
