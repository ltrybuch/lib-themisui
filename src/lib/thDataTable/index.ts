import * as angular from "angular";
import "@progress/kendo-ui/js/kendo.grid.js";
import { DataTableComponent } from "./data-table.component";
import { DataTableService } from "./data-table.service";
import { ToolbarComponent } from "./toolbar/toolbar.component";

angular.module("ThemisComponents")
  .component("thDataTable", DataTableComponent)
  .component("thDataTableToolbar", ToolbarComponent)
  .service("DataTableService", DataTableService);
