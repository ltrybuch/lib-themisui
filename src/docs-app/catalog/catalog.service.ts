import * as angular from "angular";
import {Catalog, Component} from "./catalog.interfaces";
const componentCatalog = require("./catalog") as Catalog;

export class CatalogService {
  version: string;

  /**
   * Holds data for components
   */
  components: Component[];

  /**
   * Holds data for documentation under the Guidelines category
   */
  docs: Component[];

  /**
   * Holds data for documentation on the root level
   */
  globalDocs: Component[];

  /* @ngInject */
  constructor() {
    this.version = `v ${componentCatalog.version}`;
    this.components = componentCatalog.components;
    this.docs = componentCatalog.docs;
    this.globalDocs = componentCatalog.globalDocs;
  }

  getComponent(name: string) {
    return this.components.find(component => component.name === name);
  }

  getDoc(name: string) {
    return this.docs.find(doc => doc.name === name);
  }

  getGlobalDoc(name: string) {
    return this.globalDocs.find(doc => doc.name === name);
  }

  parseComponentName(camelCase: string): string {
    return camelCase && camelCase.replace(/[A-Z]/g, match => `-${match.toLowerCase()}`);
  }
}

angular.module("ThemisComponentsApp").service("catalogService", CatalogService);
