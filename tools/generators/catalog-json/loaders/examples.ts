import * as glob from "glob";
import * as path from "path";
import * as fs from "fs";
import Config from "../config";
import { getExampleFiles } from "../utils/io.utils";

import {
  Dictionary,
  ComponentExamples,
} from "../../../../src/docs-app/catalog/catalog.interfaces";

function getComponentExamples(componentName: string): ComponentExamples[] {
  const exampleDirectory = path.join(Config.paths.components, componentName, "examples");
  const coffeeFileName = "coffee.coffee";
  const htmlFileName = "html.html";
  const typescriptFileName = "ts.ts";
  const exampleFileNames = [coffeeFileName, htmlFileName, typescriptFileName];

  if (!fs.existsSync(exampleDirectory) || !fs.statSync(exampleDirectory).isDirectory()) {
    return [];
  }

  return glob.sync(path.join(exampleDirectory, "*", "/"))
    .map(exampleDirectory => {
      const otherFilesHash: Dictionary = glob.sync(path.join(exampleDirectory, "*"))
        .map(filePath => path.basename(filePath))
        .filter(fileName => !exampleFileNames.includes(fileName))
        .reduce((files, fileName) => {
          return {...files, [fileName]: getExampleFiles(exampleDirectory, fileName)};
        }, {});

      return {
        name: path.basename(exampleDirectory),
        html: getExampleFiles(exampleDirectory, htmlFileName),
        coffee: getExampleFiles(exampleDirectory, coffeeFileName),
        typescript: getExampleFiles(exampleDirectory, typescriptFileName),
        others: otherFilesHash,
      };
  });
}

export {
  getComponentExamples,
}
