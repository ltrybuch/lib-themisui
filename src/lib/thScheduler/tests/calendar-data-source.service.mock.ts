import * as expectedCalendars from "./fixtures/calendars";
import CalendarDataSourceInterface from "../calendars/calendar-data-source.interface";

export default class CalendarDataSourceMock implements CalendarDataSourceInterface {
  private _visibleChangeHandler: Function;

  getIds(): Promise<number[]> {
    return new Promise(function(resolve) {
      resolve(expectedCalendars.ids);
    });
  }

  isVisible(id: number): boolean {
    return expectedCalendars.items.find((item) => item.id === id).visible;
  }

  setVisible() {
  }

  bind(_eventName: string, handler: Function) {
    this._visibleChangeHandler = handler;
  }

  triggerVisibilityEvent(): Promise<any> {
    return this._visibleChangeHandler({
      action: "itemchange",
      field: "visible"
    });
  }
}
