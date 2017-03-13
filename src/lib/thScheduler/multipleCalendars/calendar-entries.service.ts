import * as angular from "angular";
import CalendarDataSourceInterface from "../calendar-data-source.interface";
import CalendarDataSource from "../calendar-data-source.service";

class CalendarEntriesService {
  private _calendarDataSource: CalendarDataSourceInterface;

  /* @ngInject */
  constructor(private $http?: angular.IHttpService) {
    this._calendarDataSource = new CalendarDataSource();
  }

  set calendarDataSource(dataSource: CalendarDataSourceInterface) {
    this._calendarDataSource = dataSource;
  }

  public getCalendarIds(): Promise<number[]> {
    return new Promise((resolve) => {
      this._calendarDataSource.getIds().then((data) => {
        resolve(data);
      });
    });
  }

  public getEntriesForCalendar(id: number): Promise<object[]> {
    return new Promise((resolve, reject) => {
      this.$http
        .get(`calendar_entries?calendar_id=${id}`)
        .then(function(data) {
          resolve(data.data);
        }, function(reason) {
          reject(reason);
        });
    });
  }

  public getEntriesForCalendars() {
    return this.getCalendarIds()
      .then(ids => Promise.all(ids.map(id => this.getEntriesForCalendar(id))))
      .then(entries => [].concat(...entries))
      .catch(reason => {
        console.warn(reason);
      });
  }
}

export default CalendarEntriesService;
