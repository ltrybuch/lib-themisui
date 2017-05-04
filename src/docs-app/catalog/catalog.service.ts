import * as angular from "angular";
import { Catalog, Component, MarkdownDoc, Section } from "./catalog.interfaces";
const componentCatalog = require("./catalog") as Catalog;

export class CatalogService {
  version: string;

  /**
   * Holds data for components
   */
  components: Component[];

  /**
   * Holds section data for documentation
   */
  sections: Section[];

  /**
   * Holds data for sectioned documentation
   */
  allDocs: MarkdownDoc[];

  /**
   * Holds data for documentation on the root level
   */
  globalDocs: MarkdownDoc[];

  /* @ngInject */
  constructor() {
    this.version = `v ${componentCatalog.version}`;
    this.components = componentCatalog.components;

    this.sections = componentCatalog.docs;

    this.allDocs = [].concat(...this.sections.map((section) => section.docs));

    this.globalDocs = componentCatalog.globalDocs;
  }

  getComponent(slug: string) {
    return this.components.find(component => component.urlSlug === slug);
  }

  getDocByUrlSlug(urlSlug: string) {
    return this.allDocs.find(doc => doc.urlSlug === urlSlug);
  }

  getGlobalDocByUrlSlug(urlSlug: string) {
    return this.globalDocs.find(doc => doc.urlSlug === urlSlug);
  }

  parseComponentName(camelCase: string): string {
    return camelCase && camelCase.replace(/[A-Z]/g, match => `-${match.toLowerCase()}`);
  }
}

angular.module("ThemisComponentsApp").service("catalogService", CatalogService);
