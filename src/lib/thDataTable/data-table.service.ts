import * as angular from "angular";
import { DataTableUserOptions } from "./data-table.interfaces";
import "@progress/kendo-ui/js/kendo.grid.js";
const selectAllBannerTemplate = require("./templates/select-all-banner.template.html") as string;
const pageCheckboxTemplate = require("./templates/page-checkbox.template.html") as string;
const rowCheckboxTemplate = require("./templates/row-checkbox.template.html") as string;

class DataTableService {
  /* @ngInject */
  constructor(
    private $compile: ng.ICompileService,
  ) {}

  getComponentOptions(
    options: DataTableUserOptions,
  ) {
    const checkboxColumn = {
      title: pageCheckboxTemplate,
      width: "34px",
      command: {
        template: rowCheckboxTemplate,
      },
    };

    const columnsOptions: kendo.ui.GridColumn[] = options.selectable
      ? [checkboxColumn, ...options.columns]
      : options.columns;

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
      resizable: options.resizable,
      dataSource: options.dataSource,
      pageable: pageSizeOptions,
      columns: columnsOptions,
      selectable: false,
    };

    return kendoOptions;
  }

  initializeSelectAllBanner($element: JQuery, $scope: angular.IScope) {
    const $selectAllBanner = this.$compile(selectAllBannerTemplate)($scope);

    angular.element($element).find("thead").append($selectAllBanner);
  }
}

export { DataTableService };
