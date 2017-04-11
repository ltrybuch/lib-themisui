import * as angular from "angular";
import "@progress/kendo-ui/js/kendo.scheduler.js";
import "@progress/kendo-ui/js/kendo.tooltip.js";
import { SchedulerComponent } from "./scheduler.component";
import {CalendarEntriesServiceFactory} from "./calendar-entries.service";
import {CalendarDataSourceFactory} from "./calendars/calendar-data-source.service";
import {CalendarsComponent} from "./calendars/calendars.component";

angular.module("ThemisComponents")
  .service("CalendarEntriesServiceFactory", CalendarEntriesServiceFactory)
  .service("CalendarDataSourceFactory", CalendarDataSourceFactory)
  .component("thCalendars", CalendarsComponent)
  .component("thScheduler", SchedulerComponent);
