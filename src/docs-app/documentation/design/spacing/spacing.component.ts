import * as angular from "angular";
import { SassDoc } from "../../../catalog/sassdoc.interfaces";
import "prismjs";

const template = require("./spacing.template.html") as string;
const sassDoc = require("../../../catalog/sassdoc.json") as SassDoc[];

class Spacing {
  mixinInclude = "@include ";
  variables: SassDoc[];
  insets: SassDoc[];
  stacks: SassDoc[];
  inlines: SassDoc[];
  cssClasses: SassDoc[];
  variableTableData: any;
  insetsTableData: any;
  stacksTableData: any;
  inlinesTableData: any;
  sassObjectsByType: {
    insets: SassDoc[],
    stacks: SassDoc[],
    inlines: SassDoc[],
  };

  /* @ngInject */
  constructor(
      private SimpleTableDelegate: any,
      private TableHeader: any,
      private $timeout: angular.ITimeoutService,
    ) {}

  $onInit() {
    const spacingSass = sassDoc.filter(variable => {
      return variable.group.some(group => group === "spacing");
    });

    const variableTableHeaders = [
      this.TableHeader({ name: "Size name" }),
      this.TableHeader({ name: "Value" }),
      this.TableHeader({ name: "Variable" }),
    ];

    const mixinTableHeaders = [
      this.TableHeader({ name: "Size" }),
      this.TableHeader({ name: "CSS" }),
      this.TableHeader({ name: "Mixin" }),
      this.TableHeader({ name: "Helper class" }),
    ];

    const prepMixinData = (sass: SassDoc) => {
      const context = Object.assign({}, sass.context, {
        code: sass.context.code.replace(" !important;", ""),
        name: this.mixinInclude + sass.context.name,
      });

      return Object.assign({}, sass, { context });
    };

    this.variables = spacingSass.filter(sass => sass.context.type === "variable");

    this.insets = spacingSass
      .filter(sass => sass.context.type === "mixin" && sass.context.name.indexOf("inset") > -1)
      .map(prepMixinData);

    this.stacks = spacingSass
      .filter(sass => sass.context.type === "mixin" && sass.context.name.indexOf("stack") > -1)
      .map(prepMixinData);

    this.inlines = spacingSass
      .filter(sass => sass.context.type === "mixin" && sass.context.name.indexOf("inline") > -1)
      .map(prepMixinData);

    this.cssClasses = spacingSass.filter(sass => sass.context.type === "css");

    this.variableTableData = this.SimpleTableDelegate({
      headers: variableTableHeaders,
      fetchData: ({}, updateData: any) => updateData({ data: this.variables }),
    });

    this.insetsTableData = this.SimpleTableDelegate({
      headers: mixinTableHeaders,
      fetchData: ({}, updateData: any) => updateData({ data: this.insets }),
    });

    this.stacksTableData = this.SimpleTableDelegate({
      headers: mixinTableHeaders,
      fetchData: ({}, updateData: any) => updateData({ data: this.stacks }),
    });

    this.inlinesTableData = this.SimpleTableDelegate({
      headers: mixinTableHeaders,
      fetchData: ({}, updateData: any) => updateData({ data: this.inlines }),
    });

    this.sassObjectsByType = {
      insets: this.getAssociatedSassObjects(this.insets),
      stacks: this.getAssociatedSassObjects(this.stacks),
      inlines: this.getAssociatedSassObjects(this.inlines),
    };
  }

  $postLink() {
    this.$timeout(() => Prism.highlightAll(false));
  }

  getMixinValue(mixinObj: SassDoc) {
    const size = mixinObj.description;
    const foundVariable = this.variables.find(variable => variable.description === size);
    return foundVariable && foundVariable.context.value;
  }

  getCssClassObjFromMixin(mixinObj: SassDoc) {
    return this.cssClasses.find(classObj => {
      const mixinName = mixinObj.context.name.replace(this.mixinInclude, "");
      return classObj.context && classObj.context.name.indexOf(mixinName) > -1;
    });
  }

  private getAssociatedSassObjects(mixinObjects: SassDoc[]) {
    const cssClassesObjs = mixinObjects.map(mixinObj => {
      return this.getCssClassObjFromMixin(mixinObj);
    });

    return [...mixinObjects, ...cssClassesObjs];
  }
}

const spacingDocComponent: angular.IComponentOptions = {
  controller: Spacing,
  template,
};

export default spacingDocComponent;
