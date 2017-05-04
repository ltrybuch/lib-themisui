import * as fs from "fs";
import * as path from "path";

import {
  ComponentMeta,
  PackageJson,
} from "../../../../src/docs-app/catalog/catalog.interfaces";

function loadFileAsJson(path: string): any {
  try {
    return JSON.parse(fs.readFileSync(path, "utf8"));
  } catch (error) {
    return {};
  }
}

function getComponentMeta(basePath: string): ComponentMeta {
  try {
    return loadFileAsJson(path.join(basePath, "meta.json"));
  } catch (error) {
    return {};
  }
}

function getProjectMeta(): PackageJson {
  return loadFileAsJson("package.json");
}

function writeToFile(outputFilePath: string, contents: object): void {
  fs.writeFile(outputFilePath, JSON.stringify(contents, null, 2), function(err: any) {
    if (err) {
      throw new Error(err);
    }
  });
}

function getExampleFiles(exampleDirectory: string, filename: string): string {
  const filePath = path.join(exampleDirectory, filename);

  if (fs.existsSync(filePath)) {
    return fs.readFileSync(filePath, "utf8");
  } else {
    return null;
  }
}

export {
  getComponentMeta,
  getExampleFiles,
  getProjectMeta,
  writeToFile,
}
