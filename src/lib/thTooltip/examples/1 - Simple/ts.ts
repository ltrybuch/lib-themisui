import * as angular from "angular";

angular.module("thTooltipDemo")
  .controller("thTooltipDemoCtrl1", function() {
    this.tooltipTemplate = require("./example.template.html") as string;
});
