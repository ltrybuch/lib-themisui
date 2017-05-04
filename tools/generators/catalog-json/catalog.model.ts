import {
  Catalog,
  Component,
  MarkdownDoc,
} from "../../../src/docs-app/catalog/catalog.interfaces";
import CatalogBuilder from "./catalog.builder";

class CatalogModel implements Catalog {
  name: string;
  version: string;
  license: string;
  components: Component[];
  docs: Component[];
  globalDocs: MarkdownDoc[];

  constructor(builder: CatalogBuilder) {
    this.name = builder.Name;
    this.version = builder.Version;
    this.license = builder.License;
    this.components = builder.Components;
    this.docs = builder.Docs;
    this.globalDocs = builder.GlobalDocs;
  }
}

export default CatalogModel;
