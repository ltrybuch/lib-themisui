import * as angular from "angular";

const template = require("./documentation.template.html") as string;
const readme = require("./readme.md") as string;

class Documentation {
  readme = readme;
}

const DocumentationComponent: angular.IComponentOptions = {
  controller: Documentation,
  template,
};

export default DocumentationComponent;
