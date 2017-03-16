import {CatalogService} from "../catalog.service";
const template = require("./header.template.html") as string;

class HeaderController {
    private version: string;

    /* @ngInject */
    constructor(public catalogService: CatalogService) {}

    $onInit() {
        this.version = this.catalogService.version;
    }
}

const HeaderComponent = {
  template,
  controller: HeaderController
};

export {HeaderComponent};
