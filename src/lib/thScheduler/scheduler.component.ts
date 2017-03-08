import * as angular from "angular";

const template = require("./scheduler.template.html") as string;

class SchedulerController {
  private options: kendo.ui.SchedulerOptions;

  private validateArgs() {
    if (this.options === null || typeof this.options === "undefined") {
      throw new Error(`thScheduler: You must provide the "options" parameter.`);
    }
    if (this.options.dataSource === null || typeof this.options.dataSource === "undefined") {
      throw new Error(`thScheduler: You must provide the "options.dataSource" property.`);
    }
  }

  $onInit() {
    this.validateArgs();
    Object.assign(this.options, {
      views: [
        "agenda",
        "day",
        "week",
        "month"
      ]
    });
  }
}

const SchedulerComponent: angular.IComponentOptions = {
  template,
  bindings: {
    options: "="
  },
  controller: SchedulerController
};

export {SchedulerController, SchedulerComponent};
