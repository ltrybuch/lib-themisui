import {Gulpclass, Task, SequenceTask} from "../../../node_modules/gulpclass/Decorators";

import * as catalogGenerator from "../../generators/catalog-json/index";
import * as exampleIndexGenerator from "../../generators/examplesIndexGenerator";

@Gulpclass()
export class Catalog {

  @Task()
  generateCatalog(cb: Function) {
    catalogGenerator.buildCatalog();
    cb();
  }

  @Task()
  generateExampleIndexes(cb: Function) {
    exampleIndexGenerator.generateExampleIndex();
    cb();
  }

  @SequenceTask()
  generateCatalogAndIndexes() {
    return ["generateCatalog", "generateExampleIndexes"];
  }

  @SequenceTask()
  regenerateCatalogAndReload() {
    return ["generateCatalogAndIndexes", "webpackAndReload"];
  }
}
