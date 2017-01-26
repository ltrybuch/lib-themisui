import {Gulpclass, SequenceTask} from "../../../node_modules/gulpclass/Decorators";

@Gulpclass()
export class Default {

  @SequenceTask()
  default() {
    return [
      "generateCatalogAndIndexes",
      "webpackDev",
      "watch",
      "bs:start"
    ];
  }
}
