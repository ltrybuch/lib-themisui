const SpecHelpers: any = require("spec_helpers");
import * as expectedEntries from "./fixtures/entries";
import * as angular from "angular";
import "angular-mocks";
import SchedulerDataSource from "../../services/scheduler-data-source.service";
import { SchedulerController } from "../scheduler.component";

let bindings: {
  options: {
    dataSource?: kendo.data.DataSource,
    date?: Date,
  },
  editEventAction?: Function,
};

let $componentController: ng.IComponentControllerService;

describe("ThemisComponents: Component: SchedulerController", () => {

  beforeEach(angular.mock.module("ThemisComponents"));
  beforeEach(inject((_$componentController_: ng.IComponentControllerService) => {
    $componentController = _$componentController_;
  }));

  describe("#validateArgs", () => {
    describe(`when "options" is not specified`, () => {
      it("throws an error", () => {
        const $ctrl = $componentController("thScheduler", null) as SchedulerController;
        expect(() => $ctrl.$onInit())
          .toThrowError(`thScheduler: You must provide the "options" parameter.`);
      });
    });

    describe(`when "options.dataSource" is not provided`, () => {
      it("throws an error", () => {
        const $ctrl = $componentController("thScheduler", null, {options: {}}) as SchedulerController;
        expect(() => $ctrl.$onInit())
          .toThrowError(`thScheduler: You must provide the "options.dataSource" property.`);
      });
    });

  });

  // TODO: #replace-with-integration-test
  describe("when all required parameters are provided", () => {

    beforeEach(() => {
      const schedulerDataSource = new SchedulerDataSource();

      bindings = {
        options: {
          dataSource: schedulerDataSource.createDataSource({
            data: expectedEntries.items,
          }),
          date: new Date(expectedEntries.date),
        },
        editEventAction: () => undefined as any,
      };
    });

    it("creates a scheduler", () => {
      const {element} = SpecHelpers.compileDirective(
        `<th-scheduler options="options"></th-scheduler>`,
        bindings,
      );
      expect(element.find(".k-scheduler").length).toEqual(1);
    });

    it("renders the first entry", () => {
      const {element} = SpecHelpers.compileDirective(
        `<th-scheduler options="options"></th-scheduler>`,
        bindings,
      );
      expect(element.find(".product > h3").first().text()).toEqual("Brunch with Giles");
    });

    describe("when the user wants to create or edit an event", () => {
      let evt: JQueryEventObject;
      let $ctrl: SchedulerController;

      beforeEach(function() {
        spyOn(bindings, "editEventAction");
        $ctrl = $componentController("thScheduler", null, bindings) as SchedulerController;
        $ctrl.$onInit();
      });

      describe("and wants to add an event", () => {
        beforeEach(function() {
          evt = jQuery.Event( "add", { event: { title: "add", id: 0, _defaultId: 0} } );
        });

        it("calls 'editEventAction' with `isNew === true`", () => {
          $ctrl.options.edit(evt as any);

          expect(bindings.editEventAction).toHaveBeenCalledTimes(1);
          expect(bindings.editEventAction).toHaveBeenCalledWith(
            jasmine.objectContaining({title: "add"}),
            true,
          );
        });
      });

      describe("and wants to edit an event", () => {
        beforeEach(function() {
          evt = jQuery.Event( "edit", { event: { title: "edit", id: 1, _defaultId: 0} } );
        });

        it("calls 'editEventAction' with `isNew === false`", () => {
          $ctrl.options.edit(evt as any);

          expect(bindings.editEventAction).toHaveBeenCalledTimes(1);
          expect(bindings.editEventAction).toHaveBeenCalledWith(
            jasmine.objectContaining({title: "edit"}),
            false,
          );
        });
      });
    });

  });

});
