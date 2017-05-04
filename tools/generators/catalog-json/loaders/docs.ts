import * as glob from "glob";
import * as path from "path";
import * as fs from "fs";
import Config from "../config";
import { getComponentMeta } from "../utils/io.utils";
import { camelToDisplayName, getUrlSlug } from "../utils/name.utils";
import { getComponentExamples } from "./examples";
import { getComponentReadme } from "./components";

import {
  Readme,
  Component,
  MarkdownDoc,
  Section,
} from "../../../../src/docs-app/catalog/catalog.interfaces";

function getDocumentationMarkdown(markdownPath: string): Readme {
  let markdownContent: string;

  if (fs.existsSync(markdownPath)) {
    markdownContent = fs.readFileSync(markdownPath, "utf8");
  }

  return {
    markdown: markdownContent,
  };
}

function getMarkdownDocs(rootPath: string): MarkdownDoc[] {
  const globalMarkdownFiles = glob.sync(path.join(rootPath, "*.md"));

  const globalFilesMeta = globalMarkdownFiles.map((markdownPath) => {
    const fileName = path.basename(markdownPath);
    return {
      name: fileName,
      displayName: camelToDisplayName(fileName),
      readme: getDocumentationMarkdown(markdownPath),
      urlSlug: getUrlSlug(fileName),
      isMarkdownDoc: true,
    };
  });

  return globalFilesMeta;
}

function loadGlobalDocumentationMeta(): MarkdownDoc[] {
  return getMarkdownDocs(Config.paths.documentation);
}

function loadDocumentationMeta(): Component[] {
  const allDirectories = glob.sync(path.join(Config.paths.documentation, "*", "/"));

  function getSections(directory: string): Section | undefined {
    const componentMeta = getComponentMeta(directory);
    const name = path.basename(directory);
    let sectionObj = undefined;

    if (componentMeta.section) {
      sectionObj = {
        displayName: componentMeta.displayName,
        name,
        ...componentMeta,
      };
    }

    return sectionObj;
  }

  function getGuideline(guidelineFolderName: string): Component {
    const componentMeta = getComponentMeta(guidelineFolderName);
    const name = path.basename(guidelineFolderName);

    const isComponentGuideline = fs.existsSync(path.join(guidelineFolderName, "index.ts"));

    const markDownDocMeta = isComponentGuideline ? {} : {isMarkdownDoc: true};

    const readme = isComponentGuideline
      ? getComponentReadme(guidelineFolderName, name)
      : getDocumentationMarkdown(path.join(guidelineFolderName, `${name}.md`));

    const examples = isComponentGuideline ? getComponentExamples(name) : null;

    return {
      ...componentMeta,
      ...markDownDocMeta,
      name,
      displayName: componentMeta.displayName,
      urlSlug: getUrlSlug(name),
      readme,
      examples,
    };
  }

  function scrapeGuidelines(section: Section) {
    const sectionGuidelinesPath = path.join(Config.paths.documentation, section.name, "*");
    const guidelineFileList = glob.sync(sectionGuidelinesPath).filter(function(item) {
      return fs.lstatSync(item).isDirectory();
    });

    return guidelineFileList.map(getGuideline);
  }

  const sections = allDirectories.map(getSections);
  const results: any = [];

  sections.forEach(function(section: Section) {
    const nestedSections = scrapeGuidelines(section);
    const rootLevelSectionMdDocs = getMarkdownDocs(path.join(Config.paths.documentation, section.name));

    const sectionDocs = [...nestedSections, ...rootLevelSectionMdDocs]
      .sort((a, b) => {
        if (a.name < b.name) {
          return -1;
        }
        if (a.name > b.name) {
          return 1;
        }
        return 0;
      });

    results.push({
      name: section.displayName,
      urlSlug: getUrlSlug(section.displayName),
      docs: sectionDocs,
    });
  });
  return results;

}

export {
  loadDocumentationMeta,
  loadGlobalDocumentationMeta,
}
