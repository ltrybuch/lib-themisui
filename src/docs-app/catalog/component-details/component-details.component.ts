import * as angular from "angular";
import {Readme, Component, ComponentExamples} from "../catalog.interfaces";

const template = require("./component-details.template.html") as string;
const projectReadMe = require("../../../../README.md") as string;

class ComponentDetails {
  name: string;
  component: Component;
  private: boolean;
  whitelistLocal: boolean | number[];
  readme: Readme;
  examples: ComponentExamples[];

  /* @ngInject */
  constructor(private $sce: angular.ISCEService) {}

  $onChanges() {
    if (!this.component || this.component.private) {
      this.readme = {
        html: null,
        markdown: projectReadMe
      };
      return;
    }

    this.name = this.component.name;

    this.readme = {
      markdown: this.component.readme.markdown,
      html: this.$sce.trustAsHtml(this.component.readme.html)
    };

    this.examples = this.component.examples;
    this.private = this.component.private;
    this.whitelistLocal = this.component.whitelistLocal;
  }

  exampleWhitelistLocal(exampleIndex: number) {
    if (this.whitelistLocal instanceof Array) {
      return this.whitelistLocal.some(whitelisted => whitelisted === exampleIndex);
    } else {
      return this.whitelistLocal === true;
    }
  }
}

angular.module("ThemisComponentsApp")
  .component("docsComponentDetails", {
    bindings: {
      name: "<",
      component: "<"
    },
    controller: ComponentDetails,
    template
  });
