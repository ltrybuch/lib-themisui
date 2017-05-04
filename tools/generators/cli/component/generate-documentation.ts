import * as fs from "fs";
import * as glob from "glob";
import * as os from "os";
import * as path from "path";
import * as types from "./types";
import * as Utilities from "./utilities";

function getDestinationPath(docType: string, docName: string) {
  const documentationPath = path.join("src", "docs-app", "documentation");
  return (docType === "Top level") ? documentationPath : path.join(documentationPath, docType.toLowerCase(), docName);
}

function generateDocumentation(options: types.documentationOptions) {
  const camelCasedName = Utilities.toCamelCase(options.documentationName);
  const destinationPath = getDestinationPath(options.docType, camelCasedName);

  const metaFileInfo = options.displayName
    ? [{ path: path.join(destinationPath, "meta.json"), content: JSON.stringify({ displayName: options.displayName }) }]
    : [];

  const markdownFileName = `${camelCasedName}.md`;
  const markdownContent = `# ${options.displayName || options.documentationName}${os.EOL}`;
  const markdownFileInfo = {
    path: path.join(destinationPath, markdownFileName),
    content: markdownContent,
  };

  if (!options.docFunctionality) {
    Utilities.writeFiles([...metaFileInfo, markdownFileInfo]);
  } else {
    const kebabCasedName = Utilities.toKebabCase(options.documentationName);
    const pascalCasedName = camelCasedName[0].toUpperCase() + camelCasedName.slice(1);
    const templatePath = path.join("tools", "generators", "templates", "documentation");

    const readmeFileInfo = options.docFunctionality.includes("Markdown")
      ? [{ path: path.join(destinationPath, "readme.md"), content: markdownContent }]
      : [];
    const cssFileInfo = options.docFunctionality.includes("CSS")
      ? [{ path: path.join(destinationPath, "index.scss"), content: os.EOL }]
      : [];

    const CSSimportString = cssFileInfo.length ? `@import "../documentation/${camelCasedName}/index";` : null;
    const JSimportString = `import "./${camelCasedName}";`;

    const templateFiles: types.fileInfo[] = glob.sync(path.join(templatePath, "**/*"))
      .reduce(Utilities.createFileInfo.bind({ templatePath, destinationPath }), [])
      .map((fileInfo: types.fileInfo) => {
        if (fileInfo.path.includes("documentation.component.ts")) {
          const readmePropSearchString = !readmeFileInfo.length ? `${os.EOL}  readme = readme;${os.EOL}` : null;
          const readmeImportSearchString = !readmeFileInfo.length
            ? `const readme = require("./readme.md") as string;${os.EOL + os.EOL}`
            : null;

          return {
            path: fileInfo.path.replace("documentation.component.ts", `${kebabCasedName}.component.ts`),
            content: fileInfo.content
              .replace(readmeImportSearchString, "")
              .replace(readmePropSearchString, "")
              .replace("documentation.template.html", `${kebabCasedName}.template.html`)
              .replace(/Documentation/g, pascalCasedName),
          };

        } else if (fileInfo.path.includes("documentation.template.html")) {
          const markdownDirectiveSearchString = !readmeFileInfo.length
            ? `<div docs-bind-markdown="$ctrl.readme"></div>`
            : null;

          return {
            path: fileInfo.path.replace("documentation.template.html", `${kebabCasedName}.template.html`),
            content: fileInfo.content.replace(
              markdownDirectiveSearchString,
              `<h1>${options.displayName || options.documentationName}</h1>`,
            ),
          };

        } else if (fileInfo.path.includes("index.ts")) {
          return {
            path: fileInfo.path,
            content: fileInfo.content
              .replace("documentation.component", `${kebabCasedName}.component`)
              .replace("documentation", camelCasedName)
              .replace(/Documentation/g, pascalCasedName),
          };

        } else {
          return fileInfo;
        }
      });

    Utilities.writeFiles([...metaFileInfo, ...readmeFileInfo, ...cssFileInfo, ...templateFiles]);
    registerDocumentation(CSSimportString, JSimportString);
  }
}

function registerDocumentation(CSSImport: string, JSImport: string) {
  const indexCSSPath = path.join("src", "docs-app", "docs-app", "docs-app.scss");
  const indexJSPath = path.join("src", "docs-app", "documentation", "index.ts");
  const CSSContent = CSSImport ? fs.readFileSync(indexCSSPath, "utf8").split(os.EOL) : [];
  const JSContent = fs.readFileSync(indexJSPath, "utf8").split(os.EOL);
  const CSSImportContext = { importPattern: `@import "../documentation/`, import: CSSImport };
  const JSImportContext = { importPattern: `import "./`, import: JSImport };
  const CSSIndex = CSSContent.findIndex(Utilities.findSortOrder.bind(CSSImportContext));
  const JSIndex = JSContent.findIndex(Utilities.findSortOrder.bind(JSImportContext));

  if ((CSSImport && CSSIndex < 0) || JSIndex < 0) {
    console.error("Error registering documentation.");
    return;
  }

  const JSFileInfo = {
    path: indexJSPath,
    content: Utilities.insertByIndex(JSContent, JSImport, JSIndex + 1).join(os.EOL),
  };

  const CSSFileInfo = CSSImport
    ? [{ path: indexCSSPath, content: Utilities.insertByIndex(CSSContent, CSSImport, CSSIndex + 1).join(os.EOL) }]
    : [];

  Utilities.writeFiles([...CSSFileInfo, JSFileInfo]);
}

export default generateDocumentation;
