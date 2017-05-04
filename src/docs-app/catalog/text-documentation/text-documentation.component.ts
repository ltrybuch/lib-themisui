import * as angular from "angular";
import { CatalogService } from "../catalog.service";
const template = require("./text-documentation.template.html") as string;

class TextDocumentation {
  slug: string;
  text: string;

  /* @ngInject */
  constructor(private catalogService: CatalogService) {}

  $onInit() {
    const docObj = this.catalogService.getDocByUrlSlug(this.slug)
      || this.catalogService.getGlobalDocByUrlSlug(this.slug);

    if (docObj) {
      this.text = docObj.readme && docObj.readme.markdown;
    }
  }
}

const TextDocumentationComponent: angular.IComponentOptions = {
  template,
  controller: TextDocumentation,
  bindings: {
    slug: "<",
  },
};

export default TextDocumentationComponent;
