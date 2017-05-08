import * as angular from "angular";
import FilterSetFactory from "./filters/filterSet.service";
import { FilterComponentOptions } from "./thFilter.interface";
const template = require("./thFilter.template.html") as string;

class FilterController {
  isLoading: boolean;
  private options: FilterComponentOptions;
  private filterSet: FilterSetFactory;
  private initPromises: Promise<undefined>[] = [];

  /* @ngInject */
  constructor(private $scope: angular.IScope, private $q: angular.IQService) {}

  $onInit() {
    this.filterSet = this.options.filterSet;

    if (this.filterSet instanceof FilterSetFactory === false) {
      throw new Error("thFilter: options must specify 'filterSet'.");
    }
  }

  $postLink() {
    this.isLoading = true;
    this.$q.when((Promise.all(this.initPromises) as angular.IPromise<undefined[]>))
      .then(() => {
        this.isLoading = false;
        if (typeof this.filterSet.onInitialized === "function") {
          this.filterSet.onInitialized();
        }
      })
      .catch(() => {
        throw new Error("thFilter: Some filters were unable to load.");
      });
  }

  registerInitPromise(promise: Promise<undefined>) {
    this.initPromises.push(promise);
  }

  clearFilters() {
    this.$scope.$broadcast("th.filters.clear");
    this.filterSet.onFilterChange();
  }
}

const FilterComponent: angular.IComponentOptions = {
  bindings: {
    options: "<",
  },
  controllerAs: "thFilter",
  template,
  transclude: true,
  controller: FilterController,
};

export default FilterComponent;
