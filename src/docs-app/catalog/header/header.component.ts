import * as angular from "angular";
import { CatalogService } from "../catalog.service";
const template = require("./header.template.html") as string;

class HeaderController {
  private version: string;

  /* @ngInject */
  constructor(private catalogService: CatalogService) {}

  $onInit() {
    this.version = this.catalogService.version;
  }
}

const HeaderComponent: angular.IComponentOptions = {
  template,
  controller: HeaderController,
};

export {HeaderComponent};
