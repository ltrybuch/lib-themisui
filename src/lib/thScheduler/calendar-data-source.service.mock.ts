import * as expectedCalendars from "./tests/fixtures/calendars";
import CalendarDataSourceInterface from "./calendar-data-source.interface";

export default class CalendarDataSourceMock implements CalendarDataSourceInterface {
  public getIds() {
    return new Promise(function(resolve) {
      resolve(expectedCalendars.ids);
    });
  }
}
