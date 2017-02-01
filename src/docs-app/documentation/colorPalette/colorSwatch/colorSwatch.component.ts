import * as angular from "angular";
const template = require("./colorSwatch.template.html") as string;

angular.module("ThemisComponentsApp")
  .component("colorSwatch", {
    template,
    bindings: {
      colors: "<"
    }
  });
