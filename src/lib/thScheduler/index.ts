import * as angular from "angular";
import "@progress/kendo-ui/js/kendo.scheduler.js";
import { SchedulerComponent } from "./scheduler.component";
import CalendarEntriesService from "./multipleCalendars/calendar-entries.service";

angular.module("ThemisComponents")
  .service("CalendarEntriesService", CalendarEntriesService)
  .component("thScheduler", SchedulerComponent);
