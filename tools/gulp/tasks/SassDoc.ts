import {Gulpclass, Task} from "../../../node_modules/gulpclass/Decorators";
import * as fs from "fs";
const sassdoc = require("sassdoc") as any;
const sassSrc = "src/themes";
const sassdocPath = "src/docs-app/catalog/sassdoc.json";

@Gulpclass()
export class Default {

  @Task()
  generateSassDocs(cb: () => void) {
    sassdoc.parse(sassSrc)
      .then(function(data: string) {
        fs.writeFile(sassdocPath, JSON.stringify(data, null, 2), function(err) {
          if (err) {
            throw err;
          }
        });
        cb();
      });
  }
}
