import * as angular from "angular";
import CalendarDataSource from "./calendar-data-source.service";
import CalendarInterface from "./calendar.interface";

const template = require("./calendars.template.html") as string;

class CalendarsController {
  private options: { dataSource: CalendarDataSource };

  /**
   * This is only public for testing purposes.
   * TODO: Figure out a way to expose private members
   * to tests so we don't have to make this public.
   */
  public calendars: CalendarInterface[] = [];

  private validateArgs() {
    if (this.options === null || typeof this.options === "undefined") {
      throw new Error(`thCalendars: You must provide the "options" parameter.`);
    }
    if (this.options.dataSource === null || typeof this.options.dataSource === "undefined") {
      throw new Error(`thCalendars: You must provide the "options.dataSource" property.`);
    }
  }

  async $onInit(): Promise<any> {
    this.validateArgs();
    this.calendars = await this.options.dataSource.fetch();
  }

  toggleVisibility(calendar: CalendarInterface) {
    this.options.dataSource.setVisible(calendar);
  }
}

const CalendarsComponent: angular.IComponentOptions = {
  template,
  bindings: {
    options: "=",
  },
  controller: CalendarsController,
};

export {CalendarsController, CalendarsComponent};
