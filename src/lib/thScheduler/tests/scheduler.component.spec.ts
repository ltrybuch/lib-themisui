const SpecHelpers: any = require("spec_helpers");
import * as angular from "angular";
import "angular-mocks";
import { entries as fixtureEntries, date as fixtureDate } from "../fixtures/entries";
import SchedulerDataSource from "../../services/scheduler-data-source.service";
import { SchedulerController } from "../scheduler.component";

let scope: {
  options: {
    dataSource?: kendo.data.DataSource,
    date?: Date
  }
};

let $componentController: ng.IComponentControllerService;

describe("ThemisComponents: Component: SchedulerController", () => {

  beforeEach(angular.mock.module("ThemisComponents"));

  describe("#validateArgs", () => {
    beforeEach(inject((_$componentController_: ng.IComponentControllerService) => {
      $componentController = _$componentController_;
    }));

    describe(`when "options" is not specified`, () => {
      it("throws an error", () => {
        const ctrl = $componentController("thScheduler", null) as SchedulerController;
        expect(() => ctrl.$onInit())
          .toThrowError(`thScheduler: You must provide the "options" parameter.`);
      });
    });

    describe(`when "options.dataSource" is not provided`, () => {
      it("throws an error", () => {
        const ctrl = $componentController("thScheduler", null, {options: {}}) as SchedulerController;
        expect(() => ctrl.$onInit())
          .toThrowError(`thScheduler: You must provide the "options.dataSource" property.`);
      });
    });

  });

  // TODO: #replace-with-integration-test
  describe("when all required parameters are provided", () => {

    beforeEach(() => {
      let schedulerDataSource = new SchedulerDataSource();

      scope = {
        options: {
          dataSource: schedulerDataSource.createDataSource({
            data: fixtureEntries
          }),
          date: new Date(fixtureDate)
        }
      };
    });

    it("creates a scheduler", () => {
      let {element} = SpecHelpers.compileDirective(
        `<th-scheduler options="options"></th-scheduler>`,
        scope
      );
      expect(element.find(".k-scheduler").length).toEqual(1);
    });

    it("renders the first entry", () => {
      let {element} = SpecHelpers.compileDirective(
        `<th-scheduler options="options"></th-scheduler>`,
        scope
      );
      expect(element.find(".product > h3").first().text()).toEqual("Brunch with Giles");
    });

  });

});
