import * as moment from "moment";
import * as angular from "angular";
import { TimePickerComponent, TimePickerController } from "../thTimePicker.component";
import { TimePickerService } from "../thTimePicker.service";
let SpecHelpers: any = require("spec_helpers.coffee");

let timePickerService: TimePickerService;
let $componentController: angular.IComponentControllerService;

describe("ThemisComponents: Component: TimePickerController", () => {
  const time = moment("9:00", "h:mm");
  const min = moment("0:00", "h:mm");
  const max = moment("24:00", "h:mm");
  const format = "format";

  beforeEach(angular.mock.module("ThemisComponents"));
  beforeEach(inject((
    _TimePickerService_: TimePickerService,
    _$componentController_: angular.IComponentControllerService,
  ) => {
    timePickerService = _TimePickerService_;
    $componentController = _$componentController_;
  }));

  describe("Validations", () => {
    it("should throw an error when ng-model is not present", () => {
      const template = `<th-time-picker></th-time-picker>`;
      expect(() => SpecHelpers.compileDirective(template)).toThrow();
    });
  });

  describe("Creation", () => {
    it("creates a new TimePicker", () => {
      const template = `<th-time-picker
        ng-model="time"
        min="min"
        max="max"
        format="format"
      ></th-time-picker>`;

      spyOn(timePickerService, "create").and.callThrough();
      const {element} = SpecHelpers.compileDirective(template, {
        time,
        min: min,
        max: max,
        format: format,
      });

      expect(timePickerService.create).toHaveBeenCalledWith(
        jasmine.objectContaining({
          element: element.find("input")[0],
          min: min.toDate(),
          max: max.toDate(),
          format,
          change: jasmine.any(Function),
          close: jasmine.any(Function),
        }),
      );
    });
  });

  describe("$onChanges", () => {
    let component: TimePickerController;
    const newTime = time.clone().add(1, "hours");
    const newMin = min.clone().add(1, "hour");
    const newMax = min.clone().add(1, "hour");

    beforeEach(() => {
      const locals = {
        $element: angular.element(`<div>${TimePickerComponent.template}</div>`),
        $attrs: {},
      };

      component = $componentController("thTimePicker", locals, {
        ngModel: time,
        min,
        max,
      }) as TimePickerController;
      component.$onInit();
    });

    it("updates the kendo time picker", () => {
      component.$onChanges({
        ngModel: {
          currentValue: newTime,
          previousValue: null,
          isFirstChange: () => false,
        },
      });

      expect((component as any).value).toEqual(newTime.toDate());
    });

    it("updates the kendo time picker", () => {
      component.$postLink();
      const componentAsAny = component as any;
      spyOn(componentAsAny.timePicker, "value");
      spyOn(componentAsAny.timePicker, "min");
      spyOn(componentAsAny.timePicker, "max");

      component.$onChanges({
        ngModel: { currentValue: newTime, previousValue: null, isFirstChange: () => false },
        min: { currentValue: newMin, previousValue: null, isFirstChange: () => false },
        max: { currentValue: newMax, previousValue: null, isFirstChange: () => false },
      });
      expect(componentAsAny.timePicker.value).toHaveBeenCalledWith(newTime.toDate());
      expect(componentAsAny.timePicker.min).toHaveBeenCalledWith(newMin.toDate());
      expect(componentAsAny.timePicker.max).toHaveBeenCalledWith(newMax.toDate());
    });
  });
});
