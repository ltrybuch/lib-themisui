import * as angular from "angular";
import "@progress/kendo-ui/js/kendo.scheduler.js";
import {SchedulerComponent} from "./scheduler.component";

angular.module("ThemisComponents")
  .component("thScheduler", SchedulerComponent);
