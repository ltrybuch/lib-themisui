import * as glob from "glob";
import * as path from "path";
import * as fs from "fs";

const componentsRoot = path.join("src", "lib");
const componentDirectories = glob.sync(path.join(componentsRoot, "!(theme)", "/"));

/**
 * One-off demo module rename:
 *  - Iterate through example subfolders in themis_components
 *  - coffee.coffee ->
 *    - Update from angular.module('thDemo', ['ThemisComponents'])
 *      to angular.module("{component}Demo")
 *  - html.html ->
 *    - Update ng-app attribute to the module defined above
 */
function updateDemoModules() {
  // For each component
  componentDirectories.forEach(componentPath => {
    const componentName = path.basename(componentPath);
    const exampleDirectory = path.join(componentsRoot, componentName, "examples");
    if (!fs.existsSync(exampleDirectory) || !fs.statSync(exampleDirectory).isDirectory()) {
      return;
    }

    // For each example
    const exampleDirectories = glob.sync(path.join(exampleDirectory, "*", "/"));
    exampleDirectories.forEach((examplePath, index) => {
      const htmlPath = path.join(examplePath, "html.html");
      const coffeePath = path.join(examplePath, "coffee.coffee");
      const controllerName = `${componentName}DemoCtrl${index + 1}`;

      // Template
      if (fs.existsSync(htmlPath)) {
        const htmlFile = fs.readFileSync(htmlPath, "utf8");
        const updatedHtmlFile = htmlFile
          .replace(/ng-app=\"[a-zA-Z]+\"/, `ng-app="${componentName}Demo"`)
          .replace(/ng-controller=\"(DemoCtrl|DemoController)\s/,
            `ng-controller="${controllerName} `);

        if (htmlFile !== updatedHtmlFile) {
          fs.writeFile(htmlPath, updatedHtmlFile, err => {
            if (err) {
              console.log(err);
            }
            console.log(`${htmlPath} updated.`);
          });
        } else {
          console.log(`*** ${htmlPath} was NOT updated. ***`);
        }
      }

      // Controller
      if (fs.existsSync(coffeePath)) {
        const coffeeFile = fs.readFileSync(coffeePath, "utf8");
        const updatedCoffeeFile = coffeeFile
          .replace(/angular\.module(\(|\s)('|")[a-zA-Z]+('|"), \[('|")ThemisComponents('|")\]\)?/,
            `angular.module("${componentName}Demo")`)
          .replace(/\.controller(\(|\s)('|")(DemoCtrl|DemoController)('|")(\)|\s)?/,
            `.controller "${controllerName}"`);

        if (coffeeFile !== updatedCoffeeFile) {
          fs.writeFile(coffeePath, updatedCoffeeFile, err => {
            if (err) {
              console.log(err);
            }
            console.log(`${coffeePath} updated.`);
          });
        } else {
          console.log(`*** ${coffeePath} was NOT updated.***`);
        }
      }
    });

  });
}

updateDemoModules();
