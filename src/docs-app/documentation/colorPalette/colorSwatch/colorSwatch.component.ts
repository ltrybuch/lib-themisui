import * as angular from "angular";
const template = require("./colorSwatch.template.html") as string;

const colorSwatchComponent: angular.IComponentOptions = {
  template,
  bindings: {
    colors: "<"
  }
};

export default colorSwatchComponent;
