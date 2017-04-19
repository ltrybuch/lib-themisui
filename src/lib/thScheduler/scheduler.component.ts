import * as angular from "angular";
import CalendarEntryInterface from "./calendar-entry.interface";

const template = require("./scheduler.template.html") as string;

class SchedulerController {
  options: kendo.ui.SchedulerOptions;
  private editEventAction: Function;


  private validateArgs() {
    if (this.options === null || typeof this.options === "undefined") {
      throw new Error(`thScheduler: You must provide the "options" parameter.`);
    }
    if (this.options.dataSource === null || typeof this.options.dataSource === "undefined") {
      throw new Error(`thScheduler: You must provide the "options.dataSource" property.`);
    }
  }

  private launchEditEventAction(evt: kendo.ui.SchedulerEditEvent) {
    if (typeof this.editEventAction !== "function") {
      console.warn("SchedulerController: Must specify attribute 'edit-event-action' of type function.");
      return;
    }

    evt.preventDefault();
    const calendarEntry = evt.event.toJSON();
    const isNew = evt.event.id === evt.event._defaultId;

    this.editEventAction(
      calendarEntry,
      isNew,
      this.updateCalendarEntry.bind(this),
    );
  }

  /**
   * A somewhat ugly way of accessing the fields for a CalendarEntry that
   * were defined on the schema for the DataSource.
   */
  private getCalendarEntryFieldNames() {
    return Object.keys(this.options.dataSource.reader.reader.model.fields);
  }

  private updateCalendarEntryFields(
    entryModel: kendo.data.Model,
    calendarEntry: CalendarEntryInterface,
    fieldNames: Array<string>,
  ) {
    fieldNames.forEach((name) => {
      entryModel.set(name, calendarEntry[name]);
    });
  }

  private createNewCalendarEntry(
    calendarEntry: CalendarEntryInterface,
    fieldNames: Array<string>,
  ) {
    let newEntry: CalendarEntryInterface = {
      title: null,
      start: null,
      end: null,
      calendar: {
        id: 2,
      },
    };

    fieldNames
      .filter(fieldName => fieldName !== "id")
      .forEach((name) => {
        // TODO: This needs to update the nested id property of calendar when we implement the Set Calendar dropdown
        newEntry[name] = calendarEntry[name];
      });

    return newEntry;
  }

  /**
   * This is purely to facilitate demoing whilst we don't have the "Set Calendar" dropdown.
   * Once we can set a calendar, this method will go away.
   * @param entry
   */
  private setDefaultCalendarId(entry: CalendarEntryInterface) {
    entry.calendar_id = entry.calendar_id === 0 ? 1 : entry.calendar_id;
  }

  private updateCalendarEntry(entry: CalendarEntryInterface, isNewEntry: boolean) {
    const fieldNames = this.getCalendarEntryFieldNames();
    let calendarEntry;

    if (isNewEntry) {
      this.setDefaultCalendarId(entry);
      calendarEntry = this.createNewCalendarEntry(entry, fieldNames);

      this.options.dataSource.add(calendarEntry);
    } else {
      calendarEntry = this.options.dataSource.get(entry.id);
      this.updateCalendarEntryFields(calendarEntry, entry, fieldNames);
    }

    this.options.dataSource.sync();
  }

  $onInit() {
    this.validateArgs();

    Object.assign(this.options, {
      views: [
        "agenda",
        "day",
        { type: "week", selected: true },
        "month",
      ],
      edit: (evt: kendo.ui.SchedulerEditEvent) => this.launchEditEventAction(evt),
    });
  }
}

const SchedulerComponent: angular.IComponentOptions = {
  template,
  bindings: {
    options: "<",
    editEventAction: "<?",
  },
  controller: SchedulerController,
};

export {SchedulerController, SchedulerComponent};
