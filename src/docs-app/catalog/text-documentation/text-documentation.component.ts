import * as angular from "angular";
import { CatalogService } from "../catalog.service";
const template = require("./text-documentation.template.html") as string;

class TextDocumentation {
  doc: string;
  text: string;

  /* @ngInject */
  constructor(private catalogService: CatalogService) {}

  $onInit() {
    const docObj = this.catalogService.getDoc(this.doc)
      || this.catalogService.getGlobalDoc(this.doc);

    if (docObj) {
      this.text = docObj.readme && docObj.readme.markdown;
    }
  }
}

const TextDocumentationComponent: angular.IComponentOptions = {
  template,
  controller: TextDocumentation,
  bindings: {
    doc: "<"
  }
};

export default TextDocumentationComponent;
