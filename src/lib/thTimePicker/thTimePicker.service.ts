import "@progress/kendo-ui/js/kendo.timepicker.js";

interface TimePickerServiceOptions extends kendo.ui.TimePickerOptions {
  element: Element;
}

class TimePickerService {
  create(options: TimePickerServiceOptions) {
    const timePicker = new kendo.ui.TimePicker(options.element, {
      min: options.min,
      max: options.max,
      format: options.format,
      value: options.value,
      change: function() {
        if (options.change) {
          options.change(this.value());
        }
      },
      close: options.close,
      parseFormats: [
        "H:mt",
        "Hmt",
        "H:m t",
        "Hm t",
        "Ht",
        "H t",
        "H:m",
        "Hm",
        "H",
      ],
    });
    return timePicker;
  }
}

export { TimePickerService };
