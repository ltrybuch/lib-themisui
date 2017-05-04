import * as angular from "angular";
import { SassDoc, SassDocExample } from "../../../../catalog/sassdoc.interfaces";
import "../spacingDemo/spacingDemo.component";

const fullDemoMarkup = require("!!raw-loader!./fullDemo/fullDemo.html") as string;
const fullDemoSass = require("!!raw-loader!./fullDemo/fullDemo.scss") as string;
const template = require("./spacingDemoCode.template.html") as string;

class SpacingDemoCode {
  private examplesToDisplay: SassDocExample[];
  private markupToRender: string;
  sassData: SassDoc[];
  exampleSize: string;
  showRender: boolean;
  spacingType: "inset" | "stack" | "inline";
  fullDemo: true;

  $onInit() {
    const exampleSize = `-${this.exampleSize || "s"}`;

    if (this.sassData) {
      this.examplesToDisplay = this.sassData
        .filter(sassDoc => {
          // Replace with ES6 string.endsWith when we have it!
          const targetIndex = sassDoc.context.name.length - exampleSize.length;
          const index = sassDoc.context.name.lastIndexOf(exampleSize);
          return index === targetIndex;
        })
        .reduce(((examples: SassDocExample[], sassDoc) => [...examples, ...sassDoc.example]), []);
    }

    if (this.showRender) {
      const exampleForRender = this.examplesToDisplay.find(example => example.type === "html");
      this.markupToRender = exampleForRender && exampleForRender.code;
    }

    if (this.fullDemo) {
      this.examplesToDisplay = [{
        type: "scss",
        code: fullDemoSass,
      }, {
        type: "html",
        code: fullDemoMarkup,
      }];
    }
  }
}

const spacingDemoCodeComponent: angular.IComponentOptions = {
  controller: SpacingDemoCode,
  template,
  bindings: {
    sassData: "<",
    exampleSize: "<",
    showRender: "<",
    spacingType: "<",
    fullDemo: "<",
  },
};

export default spacingDemoCodeComponent;
