import * as angular from "angular";
import { fakeResponse } from "../../../services/http-mocking.service";
import * as expectedEntries from "../../tests/fixtures/entries";
import * as expectedCalendars from "../../tests/fixtures/calendars";
import SchedulerDataSource from "../../../services/scheduler-data-source.service";
import CalendarEntriesService from "../../multipleCalendars/calendar-entries.service";

fakeResponse(/calendars/, expectedCalendars.apiNestedItems);
fakeResponse(/calendar_entries\?calendar_id\=1/, expectedEntries.firstCalendarEntriesItems);
fakeResponse(/calendar_entries\?calendar_id\=2/, expectedEntries.secondCalendarEntriesItems);

angular.module("thSchedulerDemo")
  .controller("thSchedulerDemoCtrl3", function(
    SchedulerDataSource: SchedulerDataSource,
    CalendarEntriesService: CalendarEntriesService
  ) {

    this.options = {
      dataSource: SchedulerDataSource.createDataSource({
        schema: {
          data: "entries",
          model: {
            fields: {
              end: { from: "end", type: "date" },
              id: { from: "id", type: "number" },
              start: { from: "start", type: "date" },
              title: { from: "title" },
              calendar_id: { from: "calendar_id" }
            },
            id: "id"
          }
        },
        transport: {
          read: function(e: kendo.data.DataSourceTransportOptions) {
            CalendarEntriesService.getEntriesForCalendars()
              .then(function(entries) {
                e.success({ entries: entries });
              });
          }
        }
      }),
      date: new Date(expectedEntries.date)
    };
  });
