import CalendarDataSourceInterface from "./calendars/calendar-data-source.interface";
import SchedulerDataSource from "../services/scheduler-data-source.service";

type CalendarEntriesServiceOptions = {
  schema?: kendo.data.DataSourceSchema;
};

export default class CalendarEntriesService {
  private _entriesDataSource: kendo.data.SchedulerDataSource;
  private _queriedIds: number[] = [];
  private _calendarDataSource: CalendarDataSourceInterface;

  constructor(
    options: CalendarEntriesServiceOptions,
    calendarDataSource: CalendarDataSourceInterface,
  ) {
    this.setCalendarDataSource(calendarDataSource);

    Object.assign(options, {
      transport: {
        read: (e: kendo.data.DataSourceTransportOptions) => {
          this.getEntriesForCalendars()
            .then(function(entries: any) {
              e.success({ data: entries });
            }, function(reason: string) {
              console.log("reason", reason);
            });
        },
      },
    });

    this._entriesDataSource = new SchedulerDataSource().createDataSource(options);
  }

  private setCalendarDataSource(calendarDataSource: CalendarDataSourceInterface) {
    this._calendarDataSource = calendarDataSource;
    /* tslint:disable:max-line-length */
    this._calendarDataSource.bind("change", (e: kendo.data.DataSourceChangeEvent): Promise<void> => {
    /* tslint:enable:max-line-length */
      if (e.action === "itemchange" && e.field === "visible") {
        return this.onVisibilityChanged();
      }
    });
  }

  private async onVisibilityChanged(): Promise<void> {
    /**
     * Just noticed that calling "filter" calls the transport read function
     * which reloads the entries.
     */
    this._entriesDataSource.filter({
      operator: (entry: any) => (this._calendarDataSource.isVisible(entry.calendar_id)),
    });

    // This makes requests for calendar entries of calendars that have been toggled
    // visible but haven't yet been fetched.
    const ids = await this._calendarDataSource.getIds();
    ids.forEach((id) => {
      if (this._calendarDataSource.isVisible(id)) {
        if (!this._queriedIds.find((entryId) => entryId === id)) {
          this.addEntriesForCalendar(id);
        }
      }
    });
  }

  getEntriesDataSource(): kendo.data.SchedulerDataSource {
    return this._entriesDataSource;
  }

  async getEntriesForCalendar(id: number): Promise<any> {

    const appendCalendarIdToEntry = function(entries: any) {
      entries.forEach(function(entry: any) {
        entry.calendar_id = id;
      });
    };

    try {
      const response = await
        fetch(
          "api/v4/calendar_entries?calendar_id=" + id + "&fields=id,summary,start_at,end_at",
          {
            method: "GET",
            headers: {
              "Accept": "application/json",
              "Content-Type": "application/json",
              "Cache": "no-cache",
            },
            credentials: "same-origin",
          },
        );

      if (response.ok) {
        this._queriedIds.push(id);
        // TODO: Remove coupling to Clio API structure
        const responseData = await response.json();
        appendCalendarIdToEntry(responseData.data);
        return responseData.data;
      }
    } catch (reason) {
      return reason;
    }
  }

  /* tslint:disable:max-line-length */
  /**
   * TODO: Update links
   * @see {@link http://docs.telerik.com/kendo-ui/framework/datasource/overview#to-remote-service|To Remote Service}
   */
  /* tslint:enable:max-line-length */
  private prepareForCreate(rawData: any) {
    /* tslint:disable:max-line-length */
    // the "data" will need replacing with a dynamic key name if we allow custom API nested keys
    const models = (<any>this._entriesDataSource).reader.data.call((<any>this._entriesDataSource).reader, {data: rawData});
    /* tslint:enable:max-line-length */
    return models;
  }

  async addEntriesForCalendar(id: number): Promise<void> {
    try {
      const rawData = await this.getEntriesForCalendar(id);
      const entryModels = this.prepareForCreate(rawData);
      this._entriesDataSource.pushCreate(entryModels);
    } catch (reason) {
      console.warn(reason);
    }
  }

  async getEntriesForCalendars(): Promise<any[]> {
    try {
      const ids = await this._calendarDataSource.getIds();
      /* tslint:disable:max-line-length */
      const entryArrays = await Promise.all(ids.map(id => this._calendarDataSource.isVisible(id) ? this.getEntriesForCalendar(id) : null));
      /* tslint:enable:max-line-length */
      const entries =  [].concat(...entryArrays).filter(a => a !== null);
      return entries;
    } catch (reason) {
      console.warn(reason);
    }
  }
}

// wrapper factory for injection into an angular service
export class CalendarEntriesServiceFactory {
  public create(
    options: CalendarEntriesServiceOptions,
    calendarDataSource: CalendarDataSourceInterface,
  ) {
    return new CalendarEntriesService(options, calendarDataSource);
  }
}
