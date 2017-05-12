import * as angular from "angular";
const template = require("./tooltip.template.html") as string;

class TooltipController {}

const TooltipComponent: angular.IComponentOptions = {
  template,
  controller: TooltipController,
  controllerAs: "tooltip",
  bindings: {
    template: "<"
  },
  transclude: true,
};

export default TooltipComponent;
