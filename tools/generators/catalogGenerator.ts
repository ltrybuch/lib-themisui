import * as glob from "glob";
import * as path from "path";
import * as fs from "fs";
import {
  Dictionary,
  PackageJson,
  Readme,
  Component,
  ComponentMeta,
  ComponentExamples,
  Catalog
} from "../../src/docs-app/catalog/catalog.interfaces";

const catalogOutPath = "src/docs-app/catalog/catalog.json";
const docsComponentsRoot = path.join("src", "docs-app", "documentation");
const componentsRoot = path.join("src", "lib");
enum componentType {
  docs,
  components
}

function getProjectMeta(): PackageJson {
  const packageFile = fs.readFileSync("package.json", "utf8");
  return JSON.parse(packageFile);
}

function getComponentMeta(componentPath: string): ComponentMeta {
  try {
    return JSON.parse(fs.readFileSync(path.join(componentPath, "meta.json"), "utf8"));
  } catch (error) {
    return {
      private: false
    };
  }
}

function getExampleFiles(exampleDirectory: string, filename: string): string {
  const filePath = path.join(exampleDirectory, filename);

  if (fs.existsSync(filePath)) {
    return fs.readFileSync(filePath, "utf8");
  } else {
    return null;
  }
}

function getComponentReadme(componentPath: string, componentName: string): Readme {
  const emptyMd = `
    ${componentName} does not have a Readme

    You should really make one.
  `;

  const markdownPath = path.join(componentPath, "readme.md");
  const htmlPath = path.join(componentPath, "readme.html");
  let markdownContents: string;
  let htmlContents: string;

  if (fs.existsSync(markdownPath)) {
    markdownContents = fs.readFileSync(markdownPath, "utf8");
  }

  if (fs.existsSync(htmlPath)) {
    htmlContents = fs.readFileSync(htmlPath, "utf8");
  }

  return {
    markdown: markdownContents || emptyMd,
    html: htmlContents || ""
  };
}

function getComponentExamples(componentName: string): ComponentExamples[] {
  const exampleDirectory = path.join(componentsRoot, componentName, "examples");
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
          return Object.assign(files, {[fileName]: getExampleFiles(exampleDirectory, fileName)});
        }, {});

      return {
        name: path.basename(exampleDirectory),
        html: getExampleFiles(exampleDirectory, htmlFileName),
        coffee: getExampleFiles(exampleDirectory, coffeeFileName),
        typescript: getExampleFiles(exampleDirectory, typescriptFileName),
        others: otherFilesHash
      };
  });
}

function getComponents(type: componentType): Component[] {
  const root = type === componentType.components ? componentsRoot : docsComponentsRoot;
  const allDirectories = glob.sync(path.join(root, "!(theme)", "/"));

  return allDirectories.map(directory => {
    const componentMeta = getComponentMeta(directory);
    const componentName = path.basename(directory);
    const componentDisplayName = componentName.replace(/([A-Z])/g, " $1").slice(3);

    return Object.assign(componentMeta, {
      name: componentName,
      displayName: componentDisplayName,
      readme: getComponentReadme(directory, componentName),
      examples: type === componentType.components ? getComponentExamples(componentName) : null
    });
  });
}

function generateCatalog() {
  const projectMeta = getProjectMeta();

  // parse component/doc directories and compile a catalogObj
  const catalogObj: Catalog = {
    name: projectMeta.name,
    version: projectMeta.version,
    license: projectMeta.license,
    components: getComponents(componentType.components),
    docs: getComponents(componentType.docs)
  };

  // write catalogObj to file
  fs.writeFile(catalogOutPath, JSON.stringify(catalogObj, null, 2), function(err) {
    if (err) {
      return console.log(err);
    }
    console.log("catalog.json compiled");
  });
}

export {
  generateCatalog
}
