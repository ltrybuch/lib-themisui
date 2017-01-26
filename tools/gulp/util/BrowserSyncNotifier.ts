import {Config} from "../Config";
import * as browserSync from "browser-sync";

export class BrowserSyncNotifier {
  private bs: any;

  constructor() {
    this.bs = browserSync.get(Config.browserSync.instanceName);
  }

  error(msg: String) {
    this.bs.notify('<span style="font-weight: bold;">ERROR: </span>' + msg, 10000);
  }
}
