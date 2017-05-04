import * as angular from "angular";

const template = require("./template.template.html") as string;

class Template {}

const TemplateComponent: angular.IComponentOptions = {
    controller: Template,
    template,
};

export default TemplateComponent;
