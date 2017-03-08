import {Gulpclass, SequenceTask} from "../../../node_modules/gulpclass/Decorators";

@Gulpclass()
export class Default {

  @SequenceTask()
  herokuPreBuild() {
    return [
      "generateCatalogAndIndexes",
      "generateSassDocs",
      "webpackDev"
    ];
  }

}
