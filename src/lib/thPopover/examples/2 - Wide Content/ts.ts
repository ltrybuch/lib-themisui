import * as angular from "angular";

angular.module("thPopoverDemo")
  .controller("thPopoverDemoCtrl2", function() {

    this.popoverTemplate = require("./example.template.html") as string;

});
