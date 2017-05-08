import * as moment from "moment";
import * as angular from "angular";
import { TimePickerService } from "../thTimePicker.service";

let timePickerService: TimePickerService;

describe("ThemisComponents: Service: TimePickerService", () => {
  const element = document.createElement("div");
  const value = moment("9:00", "h:mm").toDate();
  const min = moment("0:00", "h:mm").toDate();
  const max = moment("24:00", "h:mm").toDate();
  const format = "format";
  const change = jasmine.createSpy("change");
  const close = (): any => { return undefined; };

  beforeEach(angular.mock.module("ThemisComponents"));
  beforeEach(inject((_TimePickerService_: TimePickerService) => {
    timePickerService = _TimePickerService_;
  }));

  describe("#create", () => {
    const options = {
      element,
      min,
      max,
      format,
      value,
      change,
      close,
    };

    beforeEach(() => {
      spyOn(kendo.ui, "TimePicker");
      timePickerService.create(options);
    });

    afterEach(() => change.calls.reset());

    it("should create a new kendo timepicker", () => {
      expect(kendo.ui.TimePicker).toHaveBeenCalledWith(
        element,
        jasmine.objectContaining({
          min,
          max,
          format,
          value,
          change: jasmine.any(Function),
          close,
          parseFormats: jasmine.any(Array),
        }),
      );
    });

    it("should have an argument 'change' that executes callback", () => {
      const options = (kendo.ui.TimePicker as any).calls.argsFor(0)[1];
      options.change.call({value: () => value});
      expect(change).toHaveBeenCalledWith(value);
    });
  });
});
