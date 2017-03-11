import * as angular from "angular";
import {Catalog, Component} from "./catalog.interfaces";
const componentCatalog = require("./catalog") as Catalog;

export class CatalogService {
  version: string;
  components: Component[];
  docs: Component[];

  /* @ngInject */
  constructor() {
    this.version = `v ${componentCatalog.version}`;
    this.components = componentCatalog.components;
    this.docs = componentCatalog.docs;
  }

  getComponent(name: string) {
    return this.components.filter(component => component.name === name)[0];
  }

  getDoc(name: string) {
    return this.docs.filter(doc => doc.name === name)[0];
  }

  parseComponentName(camelCase: string): string {
    return camelCase.replace(/[A-Z]/g, match => `-${match.toLowerCase()}`);
  }
}

angular.module("ThemisComponentsApp").service("catalogService", CatalogService);
