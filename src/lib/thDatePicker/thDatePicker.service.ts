import "@progress/kendo-ui/js/kendo.datepicker.js";

interface DatePickerServiceOptions extends kendo.ui.DatePickerOptions {
  element: Element;
  dateFormat?: string;
  ngDisabled?: boolean;
}

class DatepickerService {
  create(options: DatePickerServiceOptions) {
    const datepicker = new kendo.ui.DatePicker(options.element, {
      min: options.min,
      max: options.max,
      value: options.value,
      format: options.dateFormat,
      footer: "Today",
      change: function() {
        if (options["change"]) {
          options["change"](this.value());
        }
      },
      close: options["close"],
      open: options["open"]
    });

    datepicker.enable(!options.ngDisabled); // calling enable after init, because no corresponding option when creating kendo-datepicker
    return datepicker;
  }
}

export { DatepickerService };
