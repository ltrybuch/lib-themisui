import {Gulpclass, Task, SequenceTask} from "../../../node_modules/gulpclass/Decorators";
import {BundleLogger} from "../util/BundleLogger";
import {BrowserSyncNotifier} from "../util/BrowserSyncNotifier";
import * as gutil from "gulp-util";
import * as webpack from "webpack";

const webpackConfig = require("../../webpack/webpack.config.js")({
  cache: true,
  dev: true
});

@Gulpclass()
export class Webpack {
  private bundleLogger: BundleLogger;
  private bsNotifier: BrowserSyncNotifier;
  private devCompiler: any;

  constructor() {
    this.bundleLogger = new BundleLogger();
    this.bsNotifier = new BrowserSyncNotifier();
    this.devCompiler = webpack(webpackConfig);
  }

  @SequenceTask()
  webpackAndReload() {
    return ["webpackDev", "bs:reload"];
  }

  @Task()
  webpackDev(cb: Function) {
    // run webpack
    this.devCompiler.run((err: String, stats: any) => {
      if (stats.compilation.errors && stats.compilation.errors.length) {
        this.bsNotifier.error(stats.compilation.errors[0].name);
      }

      if (err) {
        throw new gutil.PluginError("webpack", err);
      }

      this.bundleLogger.stats("[webpack:dev]", stats);
      cb();
    });
  }
}
