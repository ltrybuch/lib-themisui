import * as angular from "angular";
const template = require("./toolbar.template.html") as string;

const ToolbarComponent: angular.IComponentOptions = {
  template,
  require: {
    dataGridCtrl: "^^thDataGrid",
  },
  transclude: true,
};

export { ToolbarComponent };
