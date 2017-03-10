import * as angular from "angular";
import { SassDoc } from "../../catalog/sassdoc.interfaces";
import { breakPointReadmeFilter, breakpoint } from "./breakpoint";
import { PackageJson } from "../../catalog/catalog.interfaces";

const packageJson = require("../../../../package.json") as PackageJson;
const sassDoc = require("../../catalog/sassdoc.json") as SassDoc[];
const template = require("./flex.template.html") as string;
const readme = require("./readme.md") as string;

class Flex {
  readme: string;
  bootstrapVersion: string;
  breakPoints: breakpoint[];
  breakPointsTableData: any;

  /* @ngInject */
  constructor(
    private TableHeader: any,
    private SimpleTableDelegate: any
  ) {}

  $onInit() {
    this.bootstrapVersion = packageJson.devDependencies.bootstrap;
    this.breakPoints = this.parseBreakPointValues(
      sassDoc.find(variable => variable.context.name === "grid-breakpoints")
    );

    this.readme = breakPointReadmeFilter(readme, this.breakPoints);

    const breakPointsTableHeaders = [
      this.TableHeader({ name: "Name" }),
      this.TableHeader({ name: "Minimum Width" })
    ];

    this.breakPointsTableData = this.SimpleTableDelegate({
      headers: breakPointsTableHeaders,
      fetchData: ({}, updateData: any) => updateData({ data: this.breakPoints })
    });
  }

  private parseBreakPointValues(breakPointDocObject: SassDoc) {
    let breakPoints: breakpoint[];
    const breakPointRawValues = breakPointDocObject && breakPointDocObject.context.value
      .replace(/\s/g, "")
      .replace(/(\()(.+)(\))/, (_wholeMatch, _bracket, body) => `{${body}}`)
      .replace(/(\d+px)/g, (value) => `"${value}"`)
      .replace(/(\w+)(?=:)/g, (name) => `"${name}"`);

    try {
      const breakPointValuesObject = JSON.parse(breakPointRawValues);

      breakPoints = Object.keys(breakPointValuesObject)
        .map(breakpointName => {
          return {
            name: breakpointName,
            value: breakPointValuesObject[breakpointName]
          };
        });
    } catch (error) {}

    return breakPoints;
  }
}

const flexDocComponent: angular.IComponentOptions = {
  template,
  controller: Flex
};

export default flexDocComponent;
