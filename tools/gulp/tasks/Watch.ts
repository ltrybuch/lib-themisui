import {Gulpclass, Task} from "../../../node_modules/gulpclass/Decorators";
import {Config} from "../Config";
import * as gulp from "gulp";

@Gulpclass()
export class Watch {

  @Task()
  watch(cb: Function) {
    gulp.watch([
      Config.assetPaths.examples,
      Config.assetPaths.meta,
      Config.assetPaths.docsMeta
    ], ["regenerateCatalogAndReload"]);

    gulp.watch([
      Config.assetPaths.theme
    ], ["generateSassDocs"]);

    gulp.watch([
      Config.assetPaths.lib,
      Config.assetPaths.docs,
      Config.assetPaths.readme
    ], ["webpackAndReload"]);
    cb();
  }
}
