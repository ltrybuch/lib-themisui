import * as angular from "angular";
import * as $ from "jquery";
import "@progress/kendo-ui/js/kendo.validator.js";

type validatorOptions = {
  element: HTMLElement,
  attrs: angular.IAttributes,
  rules?: any,
  messages?: any,
  validateInput: Function,
  customOptions?: {
    rules?: {
      [name: string]: () => void;
    },
    messages?: {
      [name: string]: string;
    },
  },
};

class ValidatorService {
  private options: any;

  create(options: validatorOptions) {
    const defaultOpts = {
      rules: {
        required: (ele: any) => {
          if (options.attrs.required) {
            return ele[0].value;
          } else {
            return true;
          }
        },
      },
      messages: {
        required: "Required",
      },
    };

    this.options = $.extend(true, {}, defaultOpts, options, options.customOptions);

    const validator = new kendo.ui.Validator(options.element, {
      messages: this.options.messages,
      rules: this.options.rules,
    });
    validator.bind("validateInput", this.options.validateInput);

    return validator;
  }
}

export {validatorOptions, ValidatorService};
