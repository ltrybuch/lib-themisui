import * as angular from "angular";
const template = require("./toolbar.template.html") as string;

class Toolbar {
}

const ToolbarComponent: angular.IComponentOptions = {
  template,
  require: {
    dataTableCtrl: "^^thDataTable",
  },
  transclude: true,
  controller: Toolbar,
};

export { ToolbarComponent };
