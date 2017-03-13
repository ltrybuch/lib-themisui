import * as angular from "angular";

const template = require("./fixtures.template.html") as string;

class Fixtures {}

angular.module("ThemisComponentsApp")
  .component("fixtures", {
    controller: Fixtures,
    template
});
