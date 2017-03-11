import {CatalogService} from "../catalog.service";
const template = require("./header.template.html") as string;

class HeaderController {
    private version: string;

    /* @ngInject */
    constructor(catalogService: CatalogService) {
        this.version = catalogService.version;
    }

    $onInit() {
        console.log("header controller onInit");
    }
}

const HeaderComponent = {
  template,
  controller: HeaderController
};

export {HeaderComponent};
