const SpecHelpers: any = require("spec_helpers");
import * as expectedEntries from "./fixtures/entries";
import * as angular from "angular";
import "angular-mocks";
import SchedulerDataSource from "../../services/scheduler-data-source.service";
import { SchedulerController } from "../scheduler.component";

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
    let scope: {
      options: kendo.ui.SchedulerOptions,
      editEventAction: Function;
    };

    beforeEach(() => {
      const schedulerDataSource = new SchedulerDataSource();

      scope = {
        options: {
          dataSource: schedulerDataSource.createDataSource({
            data: expectedEntries.items,
          }),
          date: new Date(expectedEntries.date),
        },
        editEventAction: jasmine.createSpy("editEventAction"),
      };
    });

    it("creates a scheduler", () => {
      const {element} = SpecHelpers.compileDirective(
        `<th-scheduler options="options"></th-scheduler>`,
        scope,
      );
      expect(element.find(".k-scheduler").length).toEqual(1);
    });

    it("renders the first entry", () => {
      const {element} = SpecHelpers.compileDirective(
        `<th-scheduler options="options"></th-scheduler>`,
        scope,
      );
      expect(element.find(".product > h3").first().text()).toEqual("Write poetry");
    });

    describe("when the user wants to create or edit an event", () => {
      let evt: JQueryEventObject;
      let $ctrl: SchedulerController;

      beforeEach(function() {
        $ctrl = $componentController("thScheduler", null, scope) as SchedulerController;
        $ctrl.$onInit();
      });

      describe("and wants to add an event", () => {
        it("calls 'editEventAction' with `isNew === true`", () => {
          evt = jQuery.Event(
            "add",
            { event: new kendo.data.ObservableObject({ title: "add", id: 0, _defaultId: 0 }) },
          );

          $ctrl.options.edit(evt as any);

          expect(scope.editEventAction).toHaveBeenCalledTimes(1);
          expect(scope.editEventAction).toHaveBeenCalledWith(
            jasmine.objectContaining({title: "add"}),
            true,
            jasmine.any(Function),
          );
        });
      });

      describe("and wants to edit an event", () => {
        it("calls 'editEventAction' with `isNew === false`", () => {
          evt = jQuery.Event(
            "edit",
            { event: new kendo.data.ObservableObject({ title: "edit", id: 1, _defaultId: 0 }) },
          );
          $ctrl.options.edit(evt as any);

          expect(scope.editEventAction).toHaveBeenCalledTimes(1);
          expect(scope.editEventAction).toHaveBeenCalledWith(
            jasmine.objectContaining({title: "edit"}),
            false,
            jasmine.any(Function),
          );
        });
      });
    });

  });

});
