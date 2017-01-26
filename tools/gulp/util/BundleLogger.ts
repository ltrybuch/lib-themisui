import * as gutil from "gulp-util";

export class BundleLogger {

  stats(label: String, stats: any) {
    if (stats) {
      gutil.log(label, stats.toString({
        chunks: false,
        colors: true
      }));
    }
  }
}
