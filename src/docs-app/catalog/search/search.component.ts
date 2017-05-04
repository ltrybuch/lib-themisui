import { CatalogService } from "../catalog.service";
import { Component, Section } from "../catalog.interfaces";
import { StateService } from "angular-ui-router";
import { searchModel } from "./search.interfaces";
import { AutocompleteDataOptions } from "../../../lib/thAutocomplete/providers/autocomplete.interface";
import DataSource from "../../../lib/services/data-source.service";
const template = require("./search.template.html") as string;

class Search {
  static docRouteType = "doc";
  static componentRouteType = "component";
  searchOptions: AutocompleteDataOptions;
  model: searchModel = null;

  /* @ngInject */
  constructor(
    private catalogService: CatalogService,
    private $state: StateService,
  ) {
    this.onChange = this.onChange.bind(this);
  }

  $onInit() {
    const data = this.createDataSource(this.catalogService.sections, this.catalogService.components);

    this.searchOptions = {
      dataSource: new DataSource().createDataSource({ data }),
      displayField: "name",
      filter: "contains",
    };
  }

  private createDataSource(sections: Section[], components: Component[]): searchModel[] {
    const docData = sections
      .map(section => {
        return section.docs.filter(doc => !doc.private)
          .map(doc => {
            return {
              name: doc.displayName,
              section: doc.urlSlug,
              type: Search.docRouteType,
              route: doc.urlSlug,
            };
          });
      });

    const componentData = components
      .filter(component => !component.private)
      .map(component => {
        return {
          name: component.displayName,
          type: Search.componentRouteType,
          route: component.urlSlug,
        };
    });

    return [...[].concat(...docData), ...componentData];
  }

  onChange(newModel: searchModel) {
    this.model = newModel;
    if (this.model) {
      const routeParams = this.model.type === "doc"
        ? { section: this.model.section, slug: this.model.route }
        : { slug: this.model.route };
      this.$state.go(this.model.type, routeParams);
    }
  }
}

const SearchComponent: angular.IComponentOptions = {
  template,
  controller: Search,
};

export default SearchComponent;
