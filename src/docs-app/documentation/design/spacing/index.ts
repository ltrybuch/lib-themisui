import * as angular from "angular";
import spacingDocComponent from "./spacing.component";
import spacingDiagramComponent from "./spacingDiagram/spacingDiagram.component";
import spacingDemoComponent from "./spacingDemo/spacingDemo.component";
import spacingDemoCodeComponent from "./spacingDemoCode/spacingDemoCode.component";

angular.module("ThemisComponentsApp")
  .component("spacing", spacingDocComponent)
  .component("spacingDiagram", spacingDiagramComponent)
  .component("spacingDemo", spacingDemoComponent)
  .component("spacingDemoCode", spacingDemoCodeComponent);

