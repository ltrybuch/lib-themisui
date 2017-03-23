import * as angular from "angular";
const template = require("./spacingDemo.template.html") as string;
const fullDemoTemplate = require("!!raw-loader!./fullDemo/fullDemo.html") as string;

class SpacingDemo {
  spacingType: "inset" | "stack" | "inline";
  type: "padding" | "margin";
  codeDemo: string;
  fullDemo: boolean;

  $onInit() {
    this.type = this.spacingType === "inset" ? "padding" : "margin";

    if (this.fullDemo) {
      this.codeDemo = fullDemoTemplate;
    }
  }
}

const spacingDemoComponent: angular.IComponentOptions = {
  controller: SpacingDemo,
  template,
  bindings: {
    spacingType: "<",
    codeDemo: "<",
    fullDemo: "<",
  },
};

export default spacingDemoComponent;
