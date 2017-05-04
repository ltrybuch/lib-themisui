import { getProjectMeta, writeToFile } from "./utils/io.utils";
import { loadComponentsMeta } from "./loaders/components";
import { loadDocumentationMeta, loadGlobalDocumentationMeta } from "./loaders/docs";
import Config from "./config";
import { Catalog } from "../../../src/docs-app/catalog/catalog.interfaces";
import CatalogBuilder from "./catalog.builder";

function buildCatalog() {
  const projectMeta = getProjectMeta();

  const catalog: Catalog = new CatalogBuilder()
    .setName(projectMeta.name)
    .setVersion(projectMeta.version)
    .setLicense(projectMeta.license)
    .setComponents(loadComponentsMeta())
    .setDocs(loadDocumentationMeta())
    .setGlobalDocs(loadGlobalDocumentationMeta())
    .build();

  writeToFile(Config.outputFiles.catalogJson, catalog);
}

export {
  buildCatalog
}
