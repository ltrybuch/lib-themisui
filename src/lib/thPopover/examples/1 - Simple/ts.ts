import * as angular from "angular";

angular.module("thPopoverDemo")
  .controller("thPopoverDemoCtrl1", function() {

    this.popoverTemplate = require("./example.template.html") as string;

});
