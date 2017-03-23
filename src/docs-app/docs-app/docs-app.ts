import * as angular from "angular";

require("./docs-app.scss");

const template = require("./docs-app.template.html") as string;

angular.module("ThemisComponentsApp")
  .component("docsApp", {
    template,
  });
