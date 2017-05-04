import * as angular from "angular";
import {CatalogService} from "../catalog.service";
import {Component, MarkdownDoc, Section} from "../catalog.interfaces";
const template = require("./component-list.template.html") as string;

class ComponentList {
  viewType: string;
  components: Component[];
  sections: Section[];
  globalDocs: MarkdownDoc[];

  /* @ngInject */
  constructor(catalogService: CatalogService) {
    this.components = catalogService.components;
    this.globalDocs = catalogService.globalDocs;
    this.sections = catalogService.sections;
    this.viewType = "as-list";
  }
}

angular.module("ThemisComponentsApp")
  .component("docsComponentList", {
    controller: ComponentList,
    template,
  });
