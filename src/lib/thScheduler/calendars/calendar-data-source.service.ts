import DataSource from "../../services/data-source.service";
import CalendarDataSourceInterface from "./calendar-data-source.interface";
import CalendarInterface from "./calendar.interface";

export default class CalendarDataSource implements CalendarDataSourceInterface {
  private _dataSource: kendo.data.DataSource;
  private _fetchPromise: Promise<number[]>;

  constructor(options: kendo.data.DataSourceOptions) {
    this._dataSource = new DataSource().createDataSource(options);

    // Wrap in a standard promise for now
    this._fetchPromise = new Promise((resolve, reject) => {
      this._dataSource.fetch()
        .then(() => resolve())
        .fail(() => reject());
    });
  }

  bind(eventName: string, handler: Function) {
    return this._dataSource.bind(eventName, handler);
  }

  isVisible(id: number): boolean {
    return this._dataSource.get(id).get("visible");
  }

  setVisible(calendar: CalendarInterface) {
    this._dataSource.get(calendar.id).set("visible", calendar.visible);
  }

  getCalendarsDataSource(): kendo.data.DataSource {
    return this._dataSource;
  }

  private async getCalendars(): Promise<CalendarInterface[]> {
    await this._fetchPromise;
    const rawData = this._dataSource.data();

    return rawData.map((calendar: kendo.data.DataSourceSchemaModel) => {
      return {
        id: calendar.id,
        name: calendar.name,
        visible: calendar.visible,
        color: calendar.color,
      };
    });
  }

  async getIds(): Promise<number[]> {
    const calendars = await this.getCalendars();
    return calendars.map((calender: CalendarInterface) => calender.id);
  }

  async fetch() {
    return await this.getCalendars();
  }
}

// wrapper factory for injection into an angular service
export class CalendarDataSourceFactory {
  public createDataSource(options: kendo.data.DataSourceOptions) {
    return new CalendarDataSource(options);
  }
}
