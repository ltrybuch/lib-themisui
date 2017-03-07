import {Gulpclass, SequenceTask} from "../../../node_modules/gulpclass/Decorators";

@Gulpclass()
export class Default {

  @SequenceTask()
  default() {
    return [
      "generateCatalogAndIndexes",
      "generateSassDocs",
      "webpackDev",
      "watch",
      "bs:start"
    ];
  }
}
