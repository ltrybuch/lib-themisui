import * as angular from "angular";
import CalendarDataSource from "./calendar-data-source.service";
import CalendarInterface from "./calendar.interface";

const template = require("./calendars.template.html") as string;
const colorTemplate = require("./color.template.html") as string;

class CalendarsController {
  private options: { dataSource: CalendarDataSource };
  // TODO: Nail down a simpler approach to testing private members (if really required)
  public calendarBeingEdited: CalendarInterface;

  /**
   * This is only public for testing purposes.
   * TODO: Figure out a way to expose private members
   * to tests so we don't have to make this public.
   */
  public calendars: CalendarInterface[] = [];

  public colorTooltipOptions = {
    position: "bottom",
    showOn: "click",
    autoHide: false,
  };

  public colorsTooltipContent = colorTemplate;

  public colors = this.options.dataSource.getPotentialCalendarColors();

  public validateArgs() {
    if (this.options === null || typeof this.options === "undefined") {
      throw new Error(`thCalendars: You must provide the "options" parameter.`);
    }
    if (this.options.dataSource === null || typeof this.options.dataSource === "undefined") {
      throw new Error(`thCalendars: You must provide the "options.dataSource" property.`);
    }
  }

  async setCalendars() {
    this.calendars = await this.options.dataSource.fetch();
  }

  async $onInit() {
    this.validateArgs();
    await this.setCalendars();
  }

  toggleVisibility(calendar: CalendarInterface) {
    this.options.dataSource.setVisible(calendar);
  }

  setCalendarBeingEdited(calendar: CalendarInterface) {
    this.calendarBeingEdited = calendar;
  }

  setColorForCalendarBeingEdited(color: string) {
    if (this.calendarBeingEdited === null || typeof this.calendarBeingEdited === "undefined") {
      throw new Error(`thCalendars: called "setColorForCalendarBeingEdited" with no active calendar.`);
    }

    this.calendarBeingEdited.color = color;
    this.options.dataSource.setColor(this.calendarBeingEdited);
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
