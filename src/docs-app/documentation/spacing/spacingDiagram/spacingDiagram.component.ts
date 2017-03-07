import * as angular from "angular";
import { SassDoc } from "../sassdoc.types";
const template = require("./spacingDiagram.template.html") as string;

class SpacingDiagram {
  sassDocObj: SassDoc;
  value: string;
  spacingType: "inset" | "stack" | "inline";
  type: "padding" | "margin";
  className: string;
  displayName: string;

  $onInit() {
    this.displayName = this.getDisplayName(this.sassDocObj);
    this.className = this.sassDocObj && this.sassDocObj.context.name.replace(".", "");
    this.type = this.spacingType === "inset" ? "padding" : "margin";
  }

  private getDisplayName(sassDocObj: SassDoc) {
    const nameParts = sassDocObj && sassDocObj.context.name.match(/\w+-\w+-(\w+)/);

    if (nameParts && nameParts.length > 1) {
      return nameParts[1];
    }

    return "";
  }
}

angular.module("ThemisComponentsApp")
  .component("spacingDiagram", {
    controller: SpacingDiagram,
    template,
    bindings: {
      sassDocObj: "<",
      value: "<",
      spacingType: "<"
    }
});
