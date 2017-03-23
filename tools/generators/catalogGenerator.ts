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
  globalDocs,
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
    return {};
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
  let markdownContent: string;
  let htmlContent: string;

  if (fs.existsSync(markdownPath)) {
    markdownContent = fs.readFileSync(markdownPath, "utf8");
  }

  if (fs.existsSync(htmlPath)) {
    htmlContent = fs.readFileSync(htmlPath, "utf8");
  }

  return {
    markdown: markdownContent || emptyMd,
    html: htmlContent || ""
  };
}

function getDocumentationMarkdown(markdownPath: string): Readme {
  let markdownContent: string;

  if (fs.existsSync(markdownPath)) {
    markdownContent = fs.readFileSync(markdownPath, "utf8");
  }

  return {
    markdown: markdownContent,
    html: ""
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
          return {...files, [fileName]: getExampleFiles(exampleDirectory, fileName)};
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
  const isDoc = type === componentType.docs;
  const isGlobalDoc = type === componentType.globalDocs;
  const isComponent = type === componentType.components;
  const root = isComponent ? componentsRoot : docsComponentsRoot;
  const allDirectories = !isGlobalDoc && glob.sync(path.join(root, "*", "/"));
  const allMarkdownFiles = isGlobalDoc && glob.sync(path.join(root, "*.md"));

  function scrapeComponentData(directory: string) {
    const componentMeta = getComponentMeta(directory);
    const name = path.basename(directory);
    const componentFileList = isDoc && glob.sync(path.join(directory, "*"));

    const isMarkdownDoc = componentFileList
      && componentFileList.length <= 2
      && componentFileList.every(file => file.endsWith(".md") || file.endsWith("meta.json"));
    const markDownDocMeta = isMarkdownDoc ? {isMarkdownDoc} : {};

    const displayName = componentMeta.displayName || (isComponent
      ? name.replace(/([A-Z])/g, " $1").slice(3)
      : name.replace(/^\w/, match => match.toUpperCase()).replace(/([A-Z])/g, " $1"));

    const readme = isComponent
      ? getComponentReadme(directory, name)
      : isMarkdownDoc ? getDocumentationMarkdown(componentFileList[0]) : null;

    const examples = isComponent ? getComponentExamples(name) : null;

    return  {
      ...componentMeta,
      ...markDownDocMeta,
      name,
      displayName,
      readme,
      examples
    };
  };

  function scrapeDocumentData(path: string): Component {
    const readme = getDocumentationMarkdown(path);
    const name = path.replace(/.+\/(.+)(.md$)/, "$1");
    const displayName = name
      .replace(/^\w/, match => match.toUpperCase())
      .replace(/([A-Z])/g, " $1");

    return {
      examples: null,
      isMarkdownDoc: true,
      name,
      displayName,
      readme,
    };
  }

  if (isGlobalDoc) {
    return allMarkdownFiles.map(scrapeDocumentData);
  } else {
    return allDirectories.map(scrapeComponentData);
  }
}

function generateCatalog() {
  const projectMeta = getProjectMeta();

  // parse component/doc directories and compile a catalogObj
  const catalogObj: Catalog = {
    name: projectMeta.name,
    version: projectMeta.version,
    license: projectMeta.license,
    components: getComponents(componentType.components),
    docs: getComponents(componentType.docs),
    globalDocs: getComponents(componentType.globalDocs)
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
