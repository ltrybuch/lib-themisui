import * as fs from "fs";
import * as path from "path";
import * as types from "./types";
const mkdirp = require("mkdirp");

function writeFiles(files: types.fileInfo[]) {
  files.forEach(file => {
    mkdirp(path.dirname(file.path), () => {
      fs.writeFile(file.path, file.content, (err) => {
        if (err) {
          return console.error(err);
        }
        console.log(`File written to: ${file.path}`);
      });
    });
  });
};

function toKebabCase(input: string) {
  return input
    .replace(/\s/g, "-")
    .toLowerCase();
};

function toCamelCase(input: string) {
  return input
    .toLowerCase()
    .replace(/-/g, " ")
    .replace(/\s([a-z]){0,1}/g, (match) => {
      return match.trim().toUpperCase();
    });
};

function isDirty(input: string) {
  const blacklist = /[\#^!~*|&;\$%@"'<>\(\)\+,]/g;

  const match = input.match(blacklist);
  return (match && match.length > 0);
};

function createFileInfo(collection: types.fileInfo[], filePath: string): types.fileInfo[] {
  if (!fs.existsSync(filePath) || fs.statSync(filePath).isDirectory()) {
    return collection;
  }

  return [
    ...collection,
    {
      path: filePath.replace(this.templatePath, this.destinationPath),
      content: fs.readFileSync(filePath, "utf8"),
    },
  ];
}

function findSortOrder(line: string, index: number, array: string[]) {
  const nextLine = array[index + 1];

  if (nextLine && nextLine.startsWith(this.importPattern)) {
    return nextLine.localeCompare(this.import) > 0;
  } else if (line.startsWith(this.importPattern)) {
    return true;
  }
}

function insertByIndex(array: any[], item: any, index: number) {
  return [...array.slice(0, index), item, ...array.slice(index)];
}

export {
  createFileInfo,
  findSortOrder,
  insertByIndex,
  isDirty,
  toCamelCase,
  toKebabCase,
  writeFiles,
}
