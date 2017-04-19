import { CalendarDataSource, CalendarDataSourceFactory } from "../../calendars/calendar-data-source.service";
import { CalendarEntriesServiceFactory } from "../../calendar-entries.service";
import * as expectedEntries from "../../tests/fixtures/entries";
import CalendarEntryInterface from "../../calendar-entry.interface";

export default class DemoSchedulerController {
  private ModalManager: any;
  private calendarDataSource: CalendarDataSource;
  private options: any;
  private calendarsOptions: { dataSource: CalendarDataSource };

  constructor(
    CalendarDataSourceFactory: CalendarDataSourceFactory,
    CalendarEntriesServiceFactory: CalendarEntriesServiceFactory,
    ModalManager: any,
  ) {
    this.ModalManager = ModalManager;
    this.calendarDataSource = CalendarDataSourceFactory.createDataSource({
      transport: {
        read: {
          url: "calendars",
          dataType: "json",
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
    });

    const calendarEntriesService = CalendarEntriesServiceFactory.create(
      {
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
      },
      this.calendarDataSource,
      {
        create: () => "api/v4/calendar_entries?fields=id,summary,start_at,end_at,location",
        read: (id: number) => `api/v4/calendar_entries?calendar_id=${id}&fields=id,summary,start_at,end_at,location`,
        update: (id: number) => `api/v4/calendar_entries/${id}`,
        delete: (id: number) => `api/v4/calendar_entries/${id}`,
      },
    );

    this.calendarsOptions = {
      dataSource: this.calendarDataSource,
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
  }

  public openEditModal = (calendarEntry: CalendarEntryInterface, isNew: boolean, updateEntry: Function) => {
    const path = "/components/thScheduler/examples/4 - Save & Update/editModal.template.html";
    const modalParams = {
      name: "eventModal",
      size: "fullpage",
      context: {
        modalTitle: isNew ? "Add event" : "Edit event",
        calendarEntry: calendarEntry,
        onSave: updateEntry,
        isNew,
      },
      path,
    };
    this.ModalManager.show(modalParams);
  }
}
