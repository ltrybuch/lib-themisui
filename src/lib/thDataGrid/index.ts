import * as angular from "angular";
import "@progress/kendo-ui/js/kendo.grid.js";
import { DataGridComponent } from "./data-grid.component";
import { DataGridService } from "./data-grid.service";
import { ToolbarComponent } from "./toolbar/toolbar.component";

angular.module("ThemisComponents")
  .component("thDataGrid", DataGridComponent)
  .component("thDataGridToolbar", ToolbarComponent)
  .service("DataGridService", DataGridService);
