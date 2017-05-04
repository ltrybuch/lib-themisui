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
  registerComponent(componentName);
}

function registerComponent(componentName: string) {
  const JSInsert = insertContentIntoFile(
    `require "./${componentName}/"`,
    path.join("src", "lib", "index.coffee"),
    `require "./th`,
  );
  const themisCSSInsert = insertContentIntoFile(
    `@import "${componentName}/styles/themis";`,
    path.join("src", "lib", "index.themis.scss"),
    `@import "th`,
  );
  const apolloCSSInsert = insertContentIntoFile(
    `@import "${componentName}/styles/apollo";`,
    path.join("src", "lib", "index.apollo.scss"),
    `@import "th`,
  );

  if (!JSInsert || !themisCSSInsert || !apolloCSSInsert) {
    console.error("Error registering component.");
    return;
  }

  Utilities.writeFiles([
    themisCSSInsert,
    apolloCSSInsert,
    JSInsert,
  ]);
};

function insertContentIntoFile(content: string, filePath: string, importPattern: string) {
  const fileContent = fs.readFileSync(filePath, "utf8").split(os.EOL);
  const importContext = { importPattern: importPattern, import: content };
  const index = fileContent.findIndex(Utilities.findSortOrder.bind(importContext));

  if (index < 0) {
    return false;
  } else {
    return {
      path: filePath,
      content: Utilities.insertByIndex(fileContent, content, index + 1).join(os.EOL),
    };
  }
}

export default generateComponent;
