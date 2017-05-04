import {
  Catalog,
  Component,
  MarkdownDoc,
} from "../../../src/docs-app/catalog/catalog.interfaces";
import CatalogModel from "./catalog.model";

class CatalogBuilder implements Catalog {
  name: string;
  version: string;
  license: string;
  components: Component[];
  docs: Component[];
  globalDocs: MarkdownDoc[];

  setName(name: string): CatalogBuilder {
    this.name = name;
    return this;
  }

  get Name() {
    return this.name;
  }

  setVersion(version: string): CatalogBuilder {
    this.version = version;
    return this;
  }

  get Version() {
    return this.version;
  }

  setLicense(license: string): CatalogBuilder {
    this.license = license;
    return this;
  }

  get License() {
    return this.license;
  }

  setComponents(components: Component[]): CatalogBuilder {
    this.components = components;
    return this;
  }

  get Components() {
    return this.components;
  }

  setDocs(docs: Component[]): CatalogBuilder {
    this.docs = docs;
    return this;
  }

  get Docs() {
    return this.docs;
  }

  setGlobalDocs(globalDocs: MarkdownDoc[]): CatalogBuilder {
    this.globalDocs = globalDocs;
    return this;
  }

  get GlobalDocs() {
    return this.globalDocs;
  }

  build(): Catalog {
    return new CatalogModel(this);
  }
}

export default CatalogBuilder;
