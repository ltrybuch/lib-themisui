import * as angular from "angular";

const template = require("./scheduler.template.html") as string;

class SchedulerController {
  public options: kendo.ui.SchedulerOptions;
  private editEventAction: (event: {title: string}, isNew: boolean) => void;

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
    const isNew = evt.event.id === evt.event._defaultId;
    const event = {
      title: evt.event.title,
    };
    this.editEventAction(event, isNew);
  }

  $onInit() {
    this.validateArgs();

    Object.assign(this.options, {
      views: [
        "agenda",
        "day",
        "week",
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
