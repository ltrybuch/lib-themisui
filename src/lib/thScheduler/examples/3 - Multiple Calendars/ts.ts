import * as angular from "angular";
import { fakeResponse } from "../../../services/http-mocking.service";
import * as expectedEntries from "../../tests/fixtures/entries";
import * as expectedCalendars from "../../tests/fixtures/calendars";
import CalendarInterface from "../../calendars/calendar.interface";

fakeResponse(/(calendars)/, expectedCalendars.apiNestedItems);
fakeResponse(/calendars\/1/, expectedCalendars.apiNestedFirstItem, "PATCH");
fakeResponse(/calendars\/2/, expectedCalendars.apiNestedSecondItem, "PATCH");
fakeResponse(/calendar_id=1/, expectedEntries.apiNestedOneCalendarEntriesItems);
fakeResponse(/calendar_id=2/, expectedEntries.apiNestedSecondCalendarEntriesItems);

angular.module("thSchedulerDemo")
  .controller("thSchedulerDemoCtrl3", function(
    CalendarDataSourceFactory,
    CalendarEntriesServiceFactory,
    ModalManager,
  ) {
    this.calendarDataSource = CalendarDataSourceFactory.createDataSource({
      transport: {
        read: {
          url: "calendars",
          dataType: "json",
        },
        update: {
          type: "patch",
          dataType: "json",
          url: function (calendar: CalendarInterface) {
            return `calendars/${calendar.id}`;
          },
        },
      },
      schema: {
        data: "data",
        model: {
          id: "id",
          fields: {
            id: { type: "number" },
            visible: { type: "boolean" },
            color: { type: "string" },
          },
        },
      },
      // "autoSync": true makes the request as expected, but doesn't seem to update the entries in the UI
      autoSync: false,
    });

    const calendarEntriesService = CalendarEntriesServiceFactory.create({
      schema: {
        data: "data",
        model: {
          fields: {
            end: { type: "date" },
            id: { type: "number" },
            start: { type: "date" },
            title: { type: "string" },
            calendar_id: { type: "number" },
          },
          id: "id",
        },
      },
    }, this.calendarDataSource);

    this.calendarsOptions = {
      dataSource: this.calendarDataSource,
    };

    this.openEditModal = (event: any, isNew: boolean) => {
      const path = "/components/thScheduler/examples/3 - Multiple Calendars/editModal.template.html";
      const modalParams = {
        name: "eventModal",
        size: "fullpage",
        context: {
          modalTitle: isNew ? "Add event" : "Edit event",
          openDiscardModal: this.openDiscardModal,
          event,
        },
        path,
      };
      ModalManager.show(modalParams);
    };

    this.openDiscardModal = () => {
      const path = "/components/thScheduler/examples/3 - Multiple Calendars/discardModal.template.html";
      const modalParams = {
        name: "discardModal",
        path,
      };
      return ModalManager.show(modalParams);
    };

    this.options = {
      dataSource: calendarEntriesService.getEntriesDataSource(),
      date: new Date(expectedEntries.date),
      resources: [
        {
          field: "calendar_id",
          dataValueField: "id",
          dataTextField: "id",
          dataSource: this.calendarDataSource.getCalendarsDataSource(),
        },
      ],
    };
  });
