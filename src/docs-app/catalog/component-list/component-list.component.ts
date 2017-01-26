import * as angular from "angular";
import {CatalogService} from "../catalog.service";
import {Component} from "../catalog.interfaces";
const template = require("./component-list.template.html") as string;

class ComponentList {
  version: string;
  viewType: string;
  components: Component[];
  docs: Component[];

  /* @ngInject */
  constructor(catalogService: CatalogService) {
    this.version = catalogService.version;
    this.components = catalogService.components;
    this.docs = catalogService.docs;
    this.viewType = "as-list";
  }
}

angular.module("ThemisComponentsApp")
  .component("docsComponentList", {
    controller: ComponentList,
    template
  });
