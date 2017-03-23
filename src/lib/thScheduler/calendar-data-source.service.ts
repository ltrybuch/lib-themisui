import DataSource from "../services/data-source.service";
import CalendarDataSourceInterface from "./calendar-data-source.interface";

export default class CalendarDataSource implements CalendarDataSourceInterface {
  // FIXME: Replace this with a ThemisUI DataSource Service once we have a DataSourceFactory
  private dataSource: kendo.data.DataSource;

  constructor() {
    this.init();
  }

  private init() {
    this.dataSource = new DataSource().createDataSource({
      transport: {
        read: {
          url: "calendars",
          dataType: "json",
        },
      },
      schema: {
        data: "calendars",
        model: {
          id: "id",
          fields: {
            id: { from: "id", type: "number" },
          },
        },
      },
    });
  }

  public getIds() {
    return new Promise((resolve) => {
      this.dataSource.fetch()
        .then(() => {
          const ids = this.dataSource.data()
          // #for-discussion #fe-craft-meeting
            .map(function(calendarObj: kendo.data.DataSourceSchemaModel) {
              return calendarObj.id;
            });
          resolve(ids);
        }).fail(function(reason) {
          console.warn("CalendarDataSource.getIds failed:", reason);
        });
    });
  }
}
