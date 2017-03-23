import * as angular from "angular";
import { fakeResponse } from "../../../services/http-mocking.service";
import * as expectedEntries from "../../tests/fixtures/entries";
import * as expectedCalendars from "../../tests/fixtures/calendars";

fakeResponse(/calendars/, expectedCalendars.apiNestedItems);
fakeResponse(/calendar_id=1/, expectedEntries.apiNestedOneCalendarEntriesItems);
fakeResponse(/calendar_id=2/, expectedEntries.apiNestedSecondCalendarEntriesItems);

angular.module("thSchedulerDemo")
  .controller("thSchedulerDemoCtrl3", function(CalendarDataSourceFactory, CalendarEntriesServiceFactory) {
    this.calendarDataSource = CalendarDataSourceFactory.createDataSource({
      transport: {
        read: {
          url: "calendars",
          dataType: "json"
        }
      },
      schema: {
        data: "data",
        model: {
          id: "id",
          fields: {
            id: { from: "id", type: "number" },
            visible: { from: "visible", type: "boolean" }
          }
        }
      }
    });

    const calendarEntriesService = CalendarEntriesServiceFactory.create({
      schema: {
        data: "data",
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
      }
    }, this.calendarDataSource);

    this.calendarsOptions = {
      dataSource: this.calendarDataSource
    };

    this.options = {
      dataSource: calendarEntriesService.getEntriesDataSource(),
      date: new Date(expectedEntries.date)
    };
  });
