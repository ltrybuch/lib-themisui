import {Gulpclass, Task} from "../../../node_modules/gulpclass/Decorators";
import {Config} from "../Config";
import * as browserSync from "browser-sync";

@Gulpclass()
export class BrowserSync {
  private bs: any;

  constructor() {
    this.bs = browserSync.create(Config.browserSync.instanceName);
  }

  @Task("bs:start")
  start(cb: Function) {
    this.bs.init(Config.browserSync);
    cb();
  }

  @Task("bs:reload")
  reload(cb: Function) {
    this.bs.reload({stream: false});
    cb();
  }
}
