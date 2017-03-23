import * as angular from "angular";
import {CatalogService} from "../catalog.service";
import {Component} from "../catalog.interfaces";
const template = require("./component-list.template.html") as string;

class ComponentList {
  viewType: string;
  components: Component[];
  docs: Component[];
  globalDocs: Component[];

  /* @ngInject */
  constructor(catalogService: CatalogService) {
    this.components = catalogService.components;
    this.globalDocs = catalogService.globalDocs;
    this.docs = catalogService.docs;
    this.viewType = "as-list";
  }
}

angular.module("ThemisComponentsApp")
  .component("docsComponentList", {
    controller: ComponentList,
    template,
  });
