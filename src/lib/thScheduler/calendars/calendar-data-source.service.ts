import DataSource from "../../services/data-source.service";
import CalendarDataSourceInterface from "./calendar-data-source.interface";
import CalendarInterface from "./calendar.interface";

class CalendarDataSource implements CalendarDataSourceInterface {
  private _dataSource: kendo.data.DataSource;
  private _fetchPromise: Promise<number[]>;
  private colors = [
    {val: "#658cda"},
    {val: "#da6666"},
    {val: "#49b050"},
    {val: "#e7804c"},
    {val: "#8c66da"},
    {val: "#c4a882"},
    {val: "#64ad88"},
    {val: "#84aaa5"},
    {val: "#56bfb3"},
    {val: "#e77399"},
    {val: "#bfbf4b"},
    {val: "#8bbf3c"},
    {val: "#b473b4"},
    {val: "#a7a77d"},
    {val: "#f2a53d"},
    {val: "#658cb3"},
    {val: "#be9494"},
    {val: "#a992a9"},
    {val: "#8897a5"},
    {val: "#93a2be"},
  ];

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
    if (this._dataSource.get(id) !== undefined) {
      return this._dataSource.get(id).get("visible");
    } else {
      const err = new Error();
      // TODO: figure out the source of this error. Out of scope for CLIO-45876 (04/04/2017)
      console.warn("Known issue that is being investigated.\n");
      console.warn(`Stack trace: ${err.stack}`);
    }
  }

  setVisible(calendar: CalendarInterface) {
    this._dataSource.get(calendar.id).set("visible", calendar.visible);
    this._dataSource.sync();
  }

  getColor(id: number): string {
    return this._dataSource.get(id).get("color");
  }

  setColor(calendar: CalendarInterface) {
    this._dataSource.get(calendar.id).set("color", calendar.color);
    this._dataSource.sync();
  }

  getPotentialCalendarColors() {
    return this.colors;
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
class CalendarDataSourceFactory {
  public createDataSource(options: kendo.data.DataSourceOptions) {
    return new CalendarDataSource(options);
  }
}

export {
  CalendarDataSource,
  CalendarDataSourceFactory,
}
