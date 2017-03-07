import * as angular from "angular";
import "@progress/kendo-ui/js/kendo.validator.js";

class ValidatorService {
  private options: any;

  create(options: {element: HTMLElement, attrs: angular.IAttributes, rules?: any, messages?: any}) {
    const defaultOpts = {
      messages: {
        required: "This field is required."
      }
    };

    this.options = jQuery.extend(true, {}, defaultOpts, options);

    return new kendo.ui.Validator(options.element, {
      messages: this.options.messages,
      rules: this.options.rules
    });
  }
}

angular.module("ThemisComponents")
  .service("ValidatorService", ValidatorService);
