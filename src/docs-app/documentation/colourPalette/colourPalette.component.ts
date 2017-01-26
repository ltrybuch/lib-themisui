import * as angular from "angular";
type scssVariables = {
  [id: string]: string;
};
// tslint:disable-next-line:max-line-length
const scssVariables = require("!!sass-variable-loader?preserveVariableNames!../../../themes/themis/colors.scss") as scssVariables;
const template = require("./colourPalette.template.html") as string;

class ColourPalette {
  public colours: {
    variable: string;
    hex: string;
  }[];

  /* @ngInject */
  constructor() {}

  $onInit() {
    this.colours = Object.keys(scssVariables)
      .filter(variable => scssVariables[variable].search(/^#([a-f0-9]{3,6})/i) >= 0)
      .sort()
      .map(variable => {
        return {
          variable: `$${variable}`,
          hex: scssVariables[variable].toUpperCase()
        };
      });
  }
}

angular.module("ThemisComponentsApp")
  .component("colourPalette", {
    controller: ColourPalette,
    template
  });
