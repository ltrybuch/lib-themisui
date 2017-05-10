import * as angular from "angular";

angular.module("thButtonDemo")
  .controller("thButtonDemoCtrl2", function() {
    this.action = function() {
      return alert("Hello!");
    };
});
