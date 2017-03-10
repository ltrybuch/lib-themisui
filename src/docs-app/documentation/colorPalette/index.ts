import * as angular from "angular";
import colorPaletteComponent from "./colorPalette.component";
import colorSwatchComponent from "./colorSwatch/colorSwatch.component";

angular.module("ThemisComponentsApp")
  .component("colorPalette", colorPaletteComponent)
  .component("colorSwatch", colorSwatchComponent);
