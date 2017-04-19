import CalendarDataSourceInterface from "./calendars/calendar-data-source.interface";
import SchedulerDataSource from "../services/scheduler-data-source.service";
import CalendarEntryInterface from "./calendar-entry.interface";

type CalendarEntriesServiceOptions = {
  schema?: kendo.data.DataSourceSchema;
  transport?: kendo.data.DataSourceTransport
};

class CalendarEntriesService {
  private entriesDataSource: kendo.data.SchedulerDataSource;
  private queriedIds: number[] = [];
  private calendarDataSource: CalendarDataSourceInterface;
  private verbUrls: {
    create: Function,
    read: Function,
    update: Function,
    delete: Function,
  };

  constructor(
    options: CalendarEntriesServiceOptions,
    calendarDataSource: CalendarDataSourceInterface,
    verbUrls: {
      create: Function,
      read: Function,
      update: Function,
      delete: Function,
    },
  ) {
    this.setCalendarDataSource(calendarDataSource);
    this.verbUrls = verbUrls;

    const transportDefaults = {
      create: (e: kendo.data.DataSourceTransportOptions) => {
        this.createCalendarEntry(e.data)
          .then(function(response) {
            e.success({ data: response.data });
          });
      },
      read: (e: kendo.data.DataSourceTransportOptions) => {
        this.getEntriesForCalendars()
          .then(function(entries) {
            e.success({ data: entries });
          }, function(reason) {
            console.log("reason", reason);
          });
      },
      update: (e: kendo.data.DataSourceTransportOptions) => {
        this.updateCalendarEntry(e.data.id, e.data)
          .then(function(response) {
            e.success({ data: response.data });
          });
      },
      destroy: (e: kendo.data.DataSourceTransportOptions) => {
        this.deleteRemoteEntry(e.data.id)
          .then(function() {
            e.success();
          }, function(reason) {
            e.error(reason);
          });
      },
    };

    // TODO: #test-needed
    if (options.transport) {
      options.transport = Object.assign({}, transportDefaults, options.transport);
    } else {
      options.transport = transportDefaults;
    }

    this.entriesDataSource = new SchedulerDataSource().createDataSource(options);
  }

  private setCalendarDataSource(calendarDataSource: CalendarDataSourceInterface) {
    this.calendarDataSource = calendarDataSource;
    this.calendarDataSource.bind("change", (e: kendo.data.DataSourceChangeEvent): Promise<void> => {
      const visibilityOrColorChanged = (e.action === "itemchange" && (e.field === "visible" || e.field === "color"));
      if (visibilityOrColorChanged) {
        return this.onVisibilityChanged();
      }
    });
  }

  /**
   * This function essentially repaints the calendar entries
   * after checking if they are cached, implicitly making a request if not
   */
  private async onVisibilityChanged(): Promise<void> {
    /**
     * Just noticed that calling "filter" calls the transport read function
     * which reloads the entries.
     */
    this.entriesDataSource.filter({
      operator: (entry: any) => (this.calendarDataSource.isVisible(entry.calendar_id)),
    });

    // This makes requests for calendar entries of calendars that have been toggled
    // visible but haven't yet been fetched.
    const ids = await this.calendarDataSource.getIds();
    ids.forEach((id) => {
      if (this.calendarDataSource.isVisible(id)) {
        if (!this.queriedIds.find((entryId) => entryId === id)) {
          this.addEntriesForCalendar(id);
        }
      }
    });
  }

  getEntriesDataSource(): kendo.data.SchedulerDataSource {
    return this.entriesDataSource;
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
          this.verbUrls.read(id),
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
        this.queriedIds.push(id);
        // TODO: Remove coupling to Clio API structure
        const responseData = await response.json();
        appendCalendarIdToEntry(responseData.data);
        return responseData.data;
      }
    } catch (reason) {
      return reason;
    }
  }

  private async deleteRemoteEntry(id: number): Promise<void> {
    const response = await
      fetch(
        this.verbUrls.delete(id),
        {
          method: "DELETE",
          headers: {
            "Accept": "application/json",
            "Content-Type": "application/json",
            "Cache": "no-cache",
          },
          credentials: "same-origin",
        },
      );

    if (response.ok) {
      return;
    }

    throw new Error(response.statusText);
  }

  removeEntry(entry: any) {
    const entryInstance = this.entriesDataSource.get(entry.id);
    try {
      /**
       * We need to handle the case when synchronization fails. This (and other functions that
       * call DataSource.sync) should return a promise so we can properly handle the error-case
       * and provide feedback to the user. #should-return-promise
       */
      this.entriesDataSource.remove(entryInstance);
      this.entriesDataSource.sync();
    } catch (reason) {
      console.warn(reason);
    }
  }

  /**
   * TODO: Update links
   * @see {@link http://docs.telerik.com/kendo-ui/framework/datasource/overview#to-remote-service|To Remote Service}
   */
  private prepareForCreate(rawData: any) {
    // the "data" will need replacing with a dynamic key name if we allow custom API nested keys
    /* tslint:disable:max-line-length */
    const models = (<any>this.entriesDataSource).reader.data.call((<any>this.entriesDataSource).reader, { data: rawData });
    /* tslint:enable:max-line-length */
    return models;
  }

  async createCalendarEntry(calendarEntry: CalendarEntryInterface): Promise<any> {
    try {
      const response = await

        fetch(
          this.verbUrls.create(),
          {
            method: "POST",
            headers: {
              "Accept": "application/json",
              "Content-Type": "application/json",
              "Cache": "no-cache",
            },
            credentials: "same-origin",
            body: JSON.stringify({ data: calendarEntry }),
          },
        );

      if (response.ok) {
        return await response.json();
      }

    } catch (reason) {
      return reason;
    }
  }

  async updateCalendarEntry(calendarEntryId: number, updatedData: CalendarEntryInterface) {
    try {
      const response = await
        fetch(
          this.verbUrls.update(calendarEntryId),
          {
            method: "PATCH",
            headers: {
              "Accept": "application/json",
              "Content-Type": "application/json",
              "Cache": "no-cache",
            },
            credentials: "same-origin",
            body: JSON.stringify({ data: updatedData }),
          },
        );


      if (response.ok) {
        return await response.json();
      }

    } catch (reason) {
      return reason;
    }
  }

  async addEntriesForCalendar(id: number): Promise<void> {
    try {
      const rawData = await this.getEntriesForCalendar(id);
      const entryModels = this.prepareForCreate(rawData);
      this.entriesDataSource.pushCreate(entryModels);
    } catch (reason) {
      console.warn(reason);
    }
  }

  async getEntriesForCalendars(): Promise<any[]> {
    try {
      const ids = await this.calendarDataSource.getIds();
      const entryArrays = await Promise.all(
        ids.map(id => this.calendarDataSource.isVisible(id) ? this.getEntriesForCalendar(id) : null),
      );
      const entries =  [].concat(...entryArrays).filter(a => a !== null);
      return entries;
    } catch (reason) {
      console.warn(reason);
    }
  }
}

// wrapper factory for injection into an angular service
class CalendarEntriesServiceFactory {
  public create(
    options: CalendarEntriesServiceOptions,
    calendarDataSource: CalendarDataSourceInterface,
    verbUrls: {
      create: Function,
      read: Function,
      update: Function,
      delete: Function,
    },
  ) {
    return new CalendarEntriesService(
      options,
      calendarDataSource,
      verbUrls,
    );
  }
}

export {
  CalendarEntriesService,
  CalendarEntriesServiceFactory,
}
