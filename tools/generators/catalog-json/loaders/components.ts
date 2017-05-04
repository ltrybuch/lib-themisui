import * as glob from "glob";
import * as path from "path";
import * as fs from "fs";
import Config from "../config";
import { getComponentMeta } from "../utils/io.utils";
import { getComponentExamples } from "./examples";
import { getUrlSlug } from "../utils/name.utils";

import {
  Readme,
  Component,
} from "../../../../src/docs-app/catalog/catalog.interfaces";

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
    html: htmlContent || "",
  };
}

function loadComponentsMeta(): Component[] {
  const allDirectories = glob.sync(path.join(Config.paths.components, "*", "/"));

  function scrapeComponentData(directory: string) {
    const componentMeta = getComponentMeta(directory);
    const name = path.basename(directory);
    const markDownDocMeta = {};
    const displayName = componentMeta.displayName || name.replace(/([A-Z])/g, " $1").slice(3);
    const readme = getComponentReadme(directory, name);
    const examples = getComponentExamples(name);

    return  {
      ...componentMeta,
      ...markDownDocMeta,
      name,
      displayName,
      readme,
      examples,
      urlSlug: getUrlSlug(name),
    };
  }
  return allDirectories.map(scrapeComponentData);
}

export {
  getComponentReadme,
  loadComponentsMeta,
}
