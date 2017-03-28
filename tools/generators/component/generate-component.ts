import * as fs from "fs";
import * as glob from "glob";
import * as os from "os";
import * as path from "path";
import * as types from "./types";
import * as Utilities from "./utilities";

function generateComponent(name: string) {
  const kebabCasedName = Utilities.toKebabCase(name);
  const camelCasedName = Utilities.toCamelCase(name);
  const pascalCasedName = camelCasedName[0].toUpperCase() + camelCasedName.slice(1);
  const componentName = `th${pascalCasedName}`;
  const templatePath = path.join("tools", "generators", "templates", "component");
  const destinationPath = path.join("src", "lib", componentName);
  const CSSimportString = `@import "${componentName}/index";`;
  const JSimportString = `require "./${componentName}/"`;

  const templateFiles: types.fileInfo[] = glob.sync(path.join(templatePath, "**/*"))
    .reduce(Utilities.createFileInfo.bind({ templatePath, destinationPath }), [])
    .map((fileInfo: types.fileInfo) => {
      if (fileInfo.path.includes("template.component.ts")) {
        return {
          path: fileInfo.path.replace("template.component.ts", `${kebabCasedName}.component.ts`),
          content: fileInfo.content
          .replace("template.template.html", `${kebabCasedName}.template.html`)
          .replace(/Template/g, pascalCasedName),
        };

      } else if (fileInfo.path.includes("template.template.html")) {
        return {
          path: fileInfo.path.replace("template.template.html", `${kebabCasedName}.template.html`),
          content: fileInfo.content,
        };

      } else if (fileInfo.path.includes("readme.md")) {
        return {
          path: fileInfo.path,
          content: fileInfo.content
            .replace("# Component Template", `# ${name}`)
            .replace(/th-template/g, `th-${kebabCasedName}`),
        };

      } else if (fileInfo.path.includes("index.ts")) {
        return {
          path: fileInfo.path,
          content: fileInfo.content
            .replace("thTemplate", componentName)
            .replace("template.component", `${kebabCasedName}.component`)
            .replace(/TemplateComponent/g, `${pascalCasedName}Component`),
        };

      } else if (fileInfo.path.includes("template.component.spec.ts")) {
        return {
          path: fileInfo.path.replace("template.component.spec.ts", `${kebabCasedName}.component.spec.ts`),
          content: fileInfo.content.replace("Template", pascalCasedName),
        };

      } else if (fileInfo.path.includes("ts.ts")) {
        return {
          path: fileInfo.path,
          content: fileInfo.content.replace(/thTemplateDemo/g, `${componentName}Demo`),
        };

      } else if (fileInfo.path.includes("html.html")) {
        return {
          path: fileInfo.path,
          content: fileInfo.content
            .replace(/thTemplateDemo/g, `${componentName}Demo`)
            .replace(/th-template/g, `th-${kebabCasedName}`),
        };

      } else {
        return fileInfo;
      }
    });

  Utilities.writeFiles(templateFiles);
  registerComponent(CSSimportString, JSimportString);
}

function registerComponent(CSSImport: string, JSImport: string) {
  const indexCSSPath = path.join("src", "lib", "index.scss");
  const indexJSPath = path.join("src", "lib", "index.coffee");
  const CSSContent = fs.readFileSync(indexCSSPath, "utf8").split(os.EOL);
  const JSContent = fs.readFileSync(indexJSPath, "utf8").split(os.EOL);
  const CSSImportContext = { importPattern: `@import "th`, import: CSSImport };
  const JSImportContext = { importPattern: `require "./th`, import: JSImport };
  const CSSIndex = CSSContent.findIndex(Utilities.findSortOrder.bind(CSSImportContext));
  const JSIndex = JSContent.findIndex(Utilities.findSortOrder.bind(JSImportContext));

  if (CSSIndex < 0 || JSIndex < 0) {
    console.error("Error registering component.");
    return;
  }

  const JSFileInfo = {
    path: indexJSPath,
    content: Utilities.insertByIndex(JSContent, JSImport, JSIndex + 1).join(os.EOL),
  };

  const CSSFileInfo = {
    path: indexCSSPath,
    content: Utilities.insertByIndex(CSSContent, CSSImport, CSSIndex + 1).join(os.EOL),
  };

  Utilities.writeFiles([CSSFileInfo, JSFileInfo]);
};

export default generateComponent;
