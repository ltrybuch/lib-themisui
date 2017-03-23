import { CatalogService } from "../catalog.service";
import { Component } from "../catalog.interfaces";
import { StateService } from "angular-ui-router";
import { searchModel } from "./search.interfaces";
import { Delegate } from "../../../lib/thAutocomplete/providers/autocomplete-options.interface";
import DataSource from "../../../lib/services/data-source.service";
const template = require("./search.template.html") as string;

class Search {
  static docRouteType = "doc";
  static componentRouteType = "component";
  searchDelegate: Delegate;
  model: searchModel = null;

  /* @ngInject */
  constructor(
    private catalogService: CatalogService,
    private $state: StateService,
  ) {}

  $onInit() {
    const data = this.createDataSource(this.catalogService.docs, this.catalogService.components);

    this.searchDelegate = {
      dataSource: new DataSource().createDataSource({ data }),
      displayField: "name",
      filterType: "contains",
    };
  }

  private createDataSource(docs: Component[], components: Component[]): searchModel[] {
    const docData = docs
      .filter(doc => !doc.private)
      .map(doc => {
        return {
          name: doc.displayName,
          type: Search.docRouteType,
          route: doc.name,
        };
    });

    const componentData = components
      .filter(component => !component.private)
      .map(component => {
        return {
          name: component.displayName,
          type: Search.componentRouteType,
          route: component.name,
        };
    });

    return [...docData, ...componentData];
  }

  onChange() {
    if (this.model) {
      this.$state.go(this.model.type, { name: this.model.route });
    }
  }
}

const SearchComponent: angular.IComponentOptions = {
  template,
  controller: Search,
};

export default SearchComponent;
