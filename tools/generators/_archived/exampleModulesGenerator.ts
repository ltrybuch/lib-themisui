import * as glob from "glob";
import * as path from "path";
import * as fs from "fs";
import * as os from "os";

const componentsRoot = path.join("src", "lib");
const componentDirectories = glob.sync(path.join(componentsRoot, "!(theme)", "/"));

/**
 * Iterate through themis_components subfolders
 *  - Build themis_components/index.examples.ts requiring each "{component}/examples"
 *  - In each example folder, build index.ts which:
 *    - Defines module for component example:
 *        angular.module("{component}Demo", ["ThemisComponents"])
 *    - Require each example subfolder: require "./1 - Styles/coffee.coffee"
 */
function generateExampleIndex() {
  const exampleIndexPath = path.join(componentsRoot, "index.examples.ts");
  let exampleIndex = "";

  // For each component
  componentDirectories.forEach(componentPath => {
    const componentName = path.basename(componentPath);
    const exampleDirectory = path.join(componentsRoot, componentName, "examples");
    if (!fs.existsSync(exampleDirectory) || !fs.statSync(exampleDirectory).isDirectory()) {
      return;
    }

    exampleIndex += `import "./${componentName}/examples";${os.EOL}`;
    const componentExampleIndexPath = path.join(exampleDirectory, "index.ts");
    let componentExampleIndex = `import * as angular from "angular";${os.EOL}`;
    componentExampleIndex += `angular.module("${componentName}Demo", ["ThemisComponents"]);`;
    componentExampleIndex += os.EOL;

    // For each example
    const exampleDirectories = glob.sync(path.join(exampleDirectory, "*", "/"));
    exampleDirectories.forEach(examplePath => {
      if (fs.existsSync(path.join(examplePath, "ts.ts"))) {
        componentExampleIndex += `import "./${path.basename(examplePath)}/ts";${os.EOL}`;
      } else if (fs.existsSync(path.join(examplePath, "coffee.coffee"))) {
        componentExampleIndex += `import "./${path.basename(examplePath)}/coffee";${os.EOL}`;
      }
    });

    fs.writeFile(componentExampleIndexPath, componentExampleIndex, err => {
      if (err) {
        console.log(err);
      }
    });
  });

  fs.writeFile(exampleIndexPath, exampleIndex, err => {
    if (err) {
      console.log(err);
    }
    console.log("indexes done");
  });
}

export {
  generateExampleIndex as generateExampleIndex
};
