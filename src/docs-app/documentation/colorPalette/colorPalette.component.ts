import * as angular from "angular";
import {ScssVariables, ColorData, variableFilterCallback} from "./colorPalette.interfaces";
import "./colorSwatch/colorSwatch.component";

// tslint:disable-next-line:max-line-length
const scssVariables = require("!!sass-variable-loader?preserveVariableNames!../../../themes/themis/colors.scss") as ScssVariables;
const template = require("./colorPalette.template.html") as string;

class ColorPalette {
  rawColors: ColorData[];
  semanticColors: ColorData[];
  deprecatedColors: ColorData[];

  /* @ngInject */
  constructor() {}

  $onInit() {
    this.rawColors = this.toColorData(
      scssVariables,
      variable => variable.indexOf("deprecated") === -1 && variable.indexOf("color") === -1
    );

    this.semanticColors = this.toColorData(
      scssVariables,
      variable => variable.indexOf("deprecated") === -1 && variable.indexOf("color") !== -1
    );

    this.deprecatedColors = this.toColorData(
      scssVariables,
      variable => variable.indexOf("deprecated") !== -1
    );
  }

  private toColorData(variables: ScssVariables, condition: variableFilterCallback): ColorData[] {
    return Object.keys(variables)
      .filter(condition)
      .sort()
      .map(variable => {
        return {
          variable: `$${variable}`,
          hex: variables[variable].toUpperCase()
        };
      });
  }
}

angular.module("ThemisComponentsApp")
  .component("colorPalette", {
    controller: ColorPalette,
    template
  });
