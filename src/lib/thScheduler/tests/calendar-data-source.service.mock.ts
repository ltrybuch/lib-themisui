import * as expectedCalendars from "./fixtures/calendars";
import CalendarDataSourceInterface from "../calendars/calendar-data-source.interface";
import DataSource from "../../services/data-source.service";

export default class CalendarDataSourceMock implements CalendarDataSourceInterface {
  private _visibleChangeHandler: Function;
  private _dataSource: kendo.data.DataSource;

  constructor() {
    this._dataSource = new DataSource().createDataSource({});
  }

  getIds(): Promise<number[]> {
    return new Promise(function(resolve) {
      resolve(expectedCalendars.ids);
    });
  }

  isVisible(id: number): boolean {
    return expectedCalendars.items.find((item) => item.id === id).visible;
  }

  setVisible() {
    return;
  }

  setColor() {
    return;
  }

  getCalendarsDataSource(): kendo.data.DataSource {
    return this._dataSource;
  }

  bind(_eventName: string, handler: Function) {
    this._visibleChangeHandler = handler;
  }

  triggerVisibilityEvent(): Promise<any> {
    return this._visibleChangeHandler({
      action: "itemchange",
      field: "visible",
    });
  }
}
